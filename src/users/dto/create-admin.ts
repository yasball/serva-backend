import * as Y from 'yup';

export const CreateAdminSchema = Y.object()
  .shape({
    username: Y.string().min(4).max(255).required(),
    password: Y.string().min(6).max(255).required(),

    firstname: Y.string().min(2).max(255).required(),
    lastname: Y.string().min(2).max(255).required(),
    middlename: Y.string(),
  })
  .stripUnknown();

export type CreateAdminDto = Y.InferType<typeof CreateAdminSchema>;
