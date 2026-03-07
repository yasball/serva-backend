import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { CommandRunnerModule } from 'nest-commander';
import { CreateAdminCommand } from './commands/create-admin.command';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule, CommandRunnerModule],
  providers: [UsersService, CreateAdminCommand],
  controllers: [UsersController],
})
export class UsersModule {}
