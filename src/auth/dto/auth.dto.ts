import * as Y from 'yup';

export const LoginSchema = Y.object()
  .shape({
    username: Y.string().required(),
    password: Y.string().required(),
  })
  .stripUnknown();

export type LoginDto = Y.InferType<typeof LoginSchema>;
