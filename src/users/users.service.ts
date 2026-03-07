import { Injectable } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { CreateAdminDto } from './dto/create-admin';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class UsersService {
  private readonly saltRounds = 12;

  public constructor(private readonly prisma: PrismaService) {}

  private hashPassword(password: string) {
    return bcrypt.hash(password, this.saltRounds);
  }

  public comparePassword(password: string, hash: string) {
    return bcrypt.compare(password, hash);
  }

  public async createAdmin(data: CreateAdminDto) {
    const password = await this.hashPassword(data.password);

    // eslint-disable-next-line
    const user = await this.prisma.user.create({
      data: {
        ...data,
        password,
        role: 'admin',
      },
    });

    // eslint-disable-next-line
    return user;
  }
}
