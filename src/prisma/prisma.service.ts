import { Injectable } from '@nestjs/common';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from 'src/__generated__/prisma/client';
import configuration from 'src/config/configuration';

@Injectable()
export class PrismaService extends PrismaClient {
  constructor() {
    const adapter = new PrismaPg({
      connectionString: configuration().DATABASE_URL,
    });
    super({ adapter });
  }
}
