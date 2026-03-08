import type { User, Session } from '../__generated__/prisma/browser';

declare global {
  declare namespace Express {
    export interface Request {
      user?: User;
      session?: Session;
    }
  }
}

export {};
