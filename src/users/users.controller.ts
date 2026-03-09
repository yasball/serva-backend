import { BadGatewayException, Controller, Get, Query } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Roles } from '../auth/decorators/roles.decorator';
import { UserRole } from '../__generated__/prisma/enums';

@Controller('users')
export class UsersController {
  public constructor(private readonly prisma: PrismaService) {}

  @Roles(UserRole.admin)
  @Get('/')
  public async getUsers(
    @Query('limit') _limit = 25,
    @Query('offset') _offset = 0,
  ) {
    try {
      const limit = Number(_limit) || 25;
      const offset = Number(_offset) || 0;

      const [data, count] = await Promise.all([
        this.prisma.user.findMany({
          select: {
            id: true,
            username: true,
            lastname: true,
            firstname: true,
            middlename: true,
            role: true,
            is_active: true,
            created_at: true,
            updated_at: true,
          },
          orderBy: {
            created_at: 'desc',
          },
          take: limit,
          skip: offset,
        }),
        this.prisma.user.count({}),
      ]);

      return {
        data,
        count,
      };
    } catch (e) {
      console.error(e);
      throw new BadGatewayException('Неизвестная ошибка: ', String(e));
    }
  }
}
