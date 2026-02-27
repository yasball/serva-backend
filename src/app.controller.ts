import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller('/api/')
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('/ping/')
  getPong() {
    return this.appService.getPong();
  }
}
