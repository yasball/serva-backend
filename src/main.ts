import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import configuration from './config/configuration';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.setGlobalPrefix('/api');

  await app.listen(configuration().PORT);
}

// eslint-disable-next-line @typescript-eslint/no-floating-promises
bootstrap();
