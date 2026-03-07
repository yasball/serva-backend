import * as Y from 'yup';

export const JwtPayloadSchema = Y.object()
  .shape({
    session_id: Y.number().positive().required(),
    user_id: Y.number().positive().required(),
    type: Y.string().oneOf(['access', 'refresh']).required(),
  })
  .stripUnknown();

export type JwtPayloadDto = Y.InferType<typeof JwtPayloadSchema>;
