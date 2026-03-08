import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import type { LoginDto } from './dto/auth.dto';
import { UsersService } from '../users/users.service';
import { PrismaService } from '../prisma/prisma.service';
import type { Request } from 'express';
import { Public } from './decorators/public.decorator';
import { CurrentUser } from './decorators/current-user.decorator';
import type { User } from '../__generated__/prisma/browser';

@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly usersService: UsersService,
    private readonly prisma: PrismaService,
  ) {}

  @Public()
  @Post('/tokens/')
  async tokens(@Req() req: Request, @Body() dto: LoginDto) {
    if (!dto || !dto.username || !dto.password) {
      throw new BadRequestException('Credentials required');
    }

    const { username, password } = dto;

    const user = await this.prisma.user.findUnique({
      where: { username },
    });

    if (
      /* */
      !user ||
      /* */
      !user.is_active ||
      /* prettier-ignore */
      !(
        await this.usersService.comparePassword(
          password,
          user.password
        )
      )
    ) {
      throw new BadRequestException('Invalid credentials');
    }

    const session = await this.authService.createSession(
      user.id,
      req.ip,
      req.headers['user-agent'],
    );

    return this.authService.generateTokens(session.id, user.id);
  }

  @Public()
  @Post('/refresh/')
  async refresh(@Body('refresh') refreshToken: string) {
    return this.authService.refreshTokens(refreshToken);
  }

  @Get('/me/')
  async me(@CurrentUser() user: User) {
    return user;
  }
}
