export default () => ({
  PORT: parseInt(process.env.PORT || '', 10) || 8008,

  DATABASE_URL:
    process.env.DATABASE_URL ||
    'postgresql://postgres:password@localhost:5432/serva_db',

  MINIO: {
    ENDPOINT: process.env.MINIO_ENDPOINT || 'localhost:9000',
    ACCESS_KEY: process.env.MINIO_ACCESS_KEY || 'minioadmin',
    SECRET_KEY: process.env.MINIO_SECRET_KEY || 'minioadmin',
    BUCKET_NAME: process.env.MINIO_BUCKET_NAME || 'serva-bucket',
  },
});
