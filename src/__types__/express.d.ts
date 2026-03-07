import type { User, Session } from 'src/__generated__/prisma';

declare global {
  declare namespace Express {
    export interface Request {
      user?: User;
      session?: Session;
    }
  }
}

export {};
