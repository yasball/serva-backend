import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './prisma/prisma.module';
import { join } from 'path';
import { UsersModule } from './users/users.module';
import { AuthModule } from './auth/auth.module';

import { CommandRunnerModule } from 'nest-commander';

@Module({
  imports: [
    ConfigModule.forRoot({
      envFilePath: join(process.cwd(), '.env'),
      isGlobal: true,
    }),
    PrismaModule,
    UsersModule,
    AuthModule,
    CommandRunnerModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
