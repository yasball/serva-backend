import { CommandFactory } from 'nest-commander';
import { AppModule } from './app.module';

async function bootstrap() {
  await CommandFactory.run(AppModule);
}

// eslint-disable-next-line @typescript-eslint/no-floating-promises
bootstrap();
