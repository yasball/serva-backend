import { Command, CommandRunner, Option } from 'nest-commander';
import { UsersService } from '../users.service';
import { CreateAdminDto } from '../dto/create-admin';

@Command({
  name: 'create:admin',
  description: 'Create admin user',
})
export class CreateAdminCommand extends CommandRunner {
  constructor(private readonly usersService: UsersService) {
    super();
  }

  async run(passedParam: string[], options: CreateAdminDto): Promise<void> {
    const { username, password, firstname, lastname, middlename } = options;

    if (!username || !password || !firstname || !lastname) {
      throw new Error('Username, password, firstname and lastname required');
    }

    const user = await this.usersService.createAdmin({
      username,
      password,

      firstname,
      lastname,
      middlename,
    });

    console.log('Admin created:', user.id);
  }

  @Option({
    flags: '-u, --username <username>',
    description: 'Admin username, min: 4',
  })
  parseUsername(val: string): string {
    return val;
  }

  @Option({
    flags: '-p, --password <password>',
    description: 'Admin password, min: 6',
  })
  parsePassword(val: string): string {
    return val;
  }

  @Option({
    flags: '-f, --firstname <firstname>',
    description: 'Admin firstname, min: 2',
  })
  parseFirstname(val: string): string {
    return val;
  }

  @Option({
    flags: '-l, --lastname <lastname>',
    description: 'Admin lastname, min: 2',
  })
  parseLastname(val: string): string {
    return val;
  }

  @Option({
    flags: '-m, --middlename <middlename>',
    description: 'Admin middlename (optional)',
  })
  parseMiddlename(val: string): string {
    return val;
  }
}
