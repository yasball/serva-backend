import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import ms from 'ms';
import { JwtPayloadDto } from './dto/jwt.dto';
import { PrismaService } from '../prisma/prisma.service';

import { createHash } from 'node:crypto';

@Injectable()
export class AuthService {
  constructor(
    private jwtService: JwtService,
    private prisma: PrismaService,
  ) {}

  private accessExpires = '60m' as const;
  private refreshExpires = '30d' as const;

  private session_max_age = '30d' as const;

  public async createSession(user_id: number, ip = '', user_agent = '') {
    const session = await this.prisma.session.create({
      data: {
        user_id,
        ip,
        user_agent,
        expires_at: new Date(Date.now() + ms(this.session_max_age)),
        refresh_hash: '' /* Записывается после создания сессии */,
      },
    });

    return session;
  }

  public async generateTokens(session_id: number, user_id: number) {
    const accessToken = this.jwtService.sign<JwtPayloadDto>(
      { session_id, user_id, type: 'access' },
      { expiresIn: ms(this.accessExpires) },
    );

    const refreshToken = this.jwtService.sign<JwtPayloadDto>(
      { session_id, user_id, type: 'refresh' },
      { expiresIn: ms(this.refreshExpires) },
    );

    const hash = createHash('sha256').update(refreshToken).digest('hex');

    await this.prisma.session.update({
      where: { id: session_id },
      data: {
        refresh_hash: hash,
      },
    });

    return {
      access: accessToken,
      refresh: refreshToken,
    };
  }

  public async refreshTokens(refreshToken: string) {
    let payload: JwtPayloadDto;

    try {
      payload = this.jwtService.verify<JwtPayloadDto>(refreshToken);
    } catch (e) {
      throw new UnauthorizedException('Invalid refresh token');
    }

    if (payload.type !== 'refresh') {
      throw new UnauthorizedException('Wrong token type');
    }

    const session = await this.prisma.session.findUnique({
      where: { id: payload.session_id },
      select: {
        id: true,
        expires_at: true,
        refresh_hash: true,
        user: {
          select: {
            id: true,
            is_active: true,
          },
        },
      },
    });

    return this.prisma.$transaction(async (tx) => {
      const hash = createHash('sha256').update(refreshToken).digest('hex');

      if (
        !session ||
        /*  */
        session.refresh_hash != hash ||
        /* */
        session.expires_at < new Date()
      ) {
        throw new UnauthorizedException('Session expired');
      }

      return this.generateTokens(session.id, payload.user_id);
    });
  }
}
