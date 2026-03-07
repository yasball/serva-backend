-- CreateTable
CREATE TABLE "auth"."sessions" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "ip" TEXT NOT NULL,
    "user_agent" TEXT NOT NULL,
    "refreshToken" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sessions_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "auth"."sessions" ADD CONSTRAINT "sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
