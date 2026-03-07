import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './prisma/prisma.module';
import { join } from 'path';
import { UsersModule } from './users/users.module';
import { AuthModule } from './auth/auth.module';

import { CommandRunnerModule } from 'nest-commander';
import { JwtModule } from '@nestjs/jwt';
import configuration from './config/configuration';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: join(process.cwd(), '.env'),
    }),
    JwtModule.registerAsync({
      global: true,
      useFactory() {
        return {
          secret: configuration().JWT_SECRET,
        };
      },
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
