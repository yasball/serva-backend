import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../../prisma/prisma.service';
import { JwtPayloadDto } from '../dto/jwt.dto';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly jwt: JwtService,
    private readonly prisma: PrismaService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const req = context.switchToHttp().getRequest();

    const header = req.headers.authorization;

    if (!header) {
      throw new UnauthorizedException('No token');
    }

    const [bearer, token] = header.split(' ');

    if (
      bearer != 'Bearer' ||
      /* */
      !token
    ) {
      throw new UnauthorizedException('Invalid token');
    }

    let payload: JwtPayloadDto;

    try {
      payload = await this.jwt.verifyAsync<JwtPayloadDto>(token);
    } catch {
      throw new UnauthorizedException('Invalid token');
    }

    if (payload.type !== 'access') {
      throw new UnauthorizedException('Wrong token type');
    }

    const session = await this.prisma.session.findUnique({
      where: { id: payload.session_id },
      select: {
        id: true,
        expiresAt: true,
        user: {
          select: {
            id: true,
            username: true,
            firstname: true,
            lastname: true,
            middlename: true,
            role: true,
            is_active: true,
          },
        },
      },
    });

    if (!session) {
      throw new UnauthorizedException('Session not found');
    }

    if (session.expiresAt < new Date()) {
      throw new UnauthorizedException('Session expired');
    }

    if (session.user.id !== payload.user_id) {
      throw new UnauthorizedException('Session mismatch');
    }

    if (!session.user.is_active) {
      throw new UnauthorizedException('User is not active');
    }

    req.user = session.user;
    req.session = { ...session, user: undefined };

    return true;
  }
}
