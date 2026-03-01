-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "auth";

-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "core";

-- CreateEnum
CREATE TYPE "auth"."UserRole" AS ENUM ('admin', 'employee');

-- CreateEnum
CREATE TYPE "core"."QRType" AS ENUM ('self_service', 'public_appeal', 'priority_service');

-- CreateEnum
CREATE TYPE "core"."RequestStatus" AS ENUM ('new', 'assigned', 'completed', 'cancelled');

-- CreateEnum
CREATE TYPE "core"."RequestSource" AS ENUM ('telegram', 'web', 'employee');

-- CreateTable
CREATE TABLE "auth"."users" (
    "id" SERIAL NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "firstname" TEXT NOT NULL,
    "lastname" TEXT NOT NULL,
    "middlename" TEXT,
    "role" "auth"."UserRole" NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_by_id" INTEGER,
    "updated_by_id" INTEGER,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."cities" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_by_id" INTEGER,
    "updated_by_id" INTEGER,

    CONSTRAINT "cities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."organizations" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "bin" TEXT,
    "legal_address" TEXT,
    "city_id" INTEGER,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_by_id" INTEGER,
    "updated_by_id" INTEGER,

    CONSTRAINT "organizations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."namespaces" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "organization_id" INTEGER NOT NULL,
    "parent_id" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_by_id" INTEGER,
    "updated_by_id" INTEGER,

    CONSTRAINT "namespaces_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."qr_codes" (
    "id" SERIAL NOT NULL,
    "code" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "type" "core"."QRType" NOT NULL,
    "organization_id" INTEGER NOT NULL,
    "namespace_id" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_by_id" INTEGER,
    "updated_by_id" INTEGER,

    CONSTRAINT "qr_codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."requests" (
    "id" SERIAL NOT NULL,
    "organization_id" INTEGER NOT NULL,
    "namespace_id" INTEGER,
    "qrcode_id" INTEGER NOT NULL,
    "description" TEXT,
    "status" "core"."RequestStatus" NOT NULL DEFAULT 'new',
    "source" "core"."RequestSource" NOT NULL,
    "assigned_to" INTEGER,
    "assigned_at" TIMESTAMP(3),
    "completed_note" TEXT,
    "complete_service_note" TEXT,
    "completed_at" TIMESTAMP(3),
    "completed_by" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_by_id" INTEGER,
    "updated_by_id" INTEGER,

    CONSTRAINT "requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "core"."feedback" (
    "id" SERIAL NOT NULL,
    "request_id" INTEGER NOT NULL,
    "rating" SMALLINT NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "feedback_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "auth"."users"("username");

-- CreateIndex
CREATE INDEX "organizations_city_id_idx" ON "core"."organizations"("city_id");

-- CreateIndex
CREATE INDEX "organizations_name_idx" ON "core"."organizations"("name");

-- CreateIndex
CREATE INDEX "namespaces_organization_id_parent_id_idx" ON "core"."namespaces"("organization_id", "parent_id");

-- CreateIndex
CREATE INDEX "namespaces_name_idx" ON "core"."namespaces"("name");

-- CreateIndex
CREATE UNIQUE INDEX "namespaces_organization_id_parent_id_name_key" ON "core"."namespaces"("organization_id", "parent_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "qr_codes_code_key" ON "core"."qr_codes"("code");

-- CreateIndex
CREATE INDEX "qr_codes_code_idx" ON "core"."qr_codes"("code");

-- CreateIndex
CREATE INDEX "qr_codes_name_idx" ON "core"."qr_codes"("name");

-- CreateIndex
CREATE INDEX "qr_codes_organization_id_idx" ON "core"."qr_codes"("organization_id");

-- CreateIndex
CREATE INDEX "qr_codes_namespace_id_idx" ON "core"."qr_codes"("namespace_id");

-- CreateIndex
CREATE INDEX "qr_codes_type_idx" ON "core"."qr_codes"("type");

-- CreateIndex
CREATE INDEX "qr_codes_created_at_idx" ON "core"."qr_codes"("created_at");

-- CreateIndex
CREATE INDEX "qr_codes_created_by_id_idx" ON "core"."qr_codes"("created_by_id");

-- CreateIndex
CREATE INDEX "qr_codes_updated_at_idx" ON "core"."qr_codes"("updated_at");

-- CreateIndex
CREATE INDEX "qr_codes_updated_by_id_idx" ON "core"."qr_codes"("updated_by_id");

-- CreateIndex
CREATE UNIQUE INDEX "qr_codes_namespace_id_name_key" ON "core"."qr_codes"("namespace_id", "name");

-- CreateIndex
CREATE INDEX "requests_qrcode_id_namespace_id_status_created_at_idx" ON "core"."requests"("qrcode_id", "namespace_id", "status", "created_at");

-- CreateIndex
CREATE INDEX "requests_organization_id_idx" ON "core"."requests"("organization_id");

-- CreateIndex
CREATE INDEX "requests_namespace_id_idx" ON "core"."requests"("namespace_id");

-- CreateIndex
CREATE INDEX "requests_qrcode_id_idx" ON "core"."requests"("qrcode_id");

-- CreateIndex
CREATE INDEX "requests_status_idx" ON "core"."requests"("status");

-- CreateIndex
CREATE INDEX "requests_source_idx" ON "core"."requests"("source");

-- CreateIndex
CREATE INDEX "requests_assigned_to_idx" ON "core"."requests"("assigned_to");

-- CreateIndex
CREATE INDEX "requests_assigned_at_idx" ON "core"."requests"("assigned_at");

-- CreateIndex
CREATE INDEX "requests_completed_by_idx" ON "core"."requests"("completed_by");

-- CreateIndex
CREATE INDEX "requests_completed_at_idx" ON "core"."requests"("completed_at");

-- CreateIndex
CREATE INDEX "requests_created_at_idx" ON "core"."requests"("created_at");

-- CreateIndex
CREATE INDEX "requests_created_by_id_idx" ON "core"."requests"("created_by_id");

-- CreateIndex
CREATE UNIQUE INDEX "feedback_request_id_key" ON "core"."feedback"("request_id");

-- CreateIndex
CREATE INDEX "feedback_request_id_idx" ON "core"."feedback"("request_id");

-- AddForeignKey
ALTER TABLE "auth"."users" ADD CONSTRAINT "users_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "auth"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "auth"."users" ADD CONSTRAINT "users_updated_by_id_fkey" FOREIGN KEY ("updated_by_id") REFERENCES "auth"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."cities" ADD CONSTRAINT "cities_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "auth"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."cities" ADD CONSTRAINT "cities_updated_by_id_fkey" FOREIGN KEY ("updated_by_id") REFERENCES "auth"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."organizations" ADD CONSTRAINT "organizations_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "core"."cities"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."organizations" ADD CONSTRAINT "organizations_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "auth"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."organizations" ADD CONSTRAINT "organizations_updated_by_id_fkey" FOREIGN KEY ("updated_by_id") REFERENCES "auth"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."namespaces" ADD CONSTRAINT "namespaces_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "core"."organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."namespaces" ADD CONSTRAINT "namespaces_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "core"."namespaces"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."namespaces" ADD CONSTRAINT "namespaces_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "auth"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."namespaces" ADD CONSTRAINT "namespaces_updated_by_id_fkey" FOREIGN KEY ("updated_by_id") REFERENCES "auth"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."qr_codes" ADD CONSTRAINT "qr_codes_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "core"."organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."qr_codes" ADD CONSTRAINT "qr_codes_namespace_id_fkey" FOREIGN KEY ("namespace_id") REFERENCES "core"."namespaces"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."qr_codes" ADD CONSTRAINT "qr_codes_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "auth"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."qr_codes" ADD CONSTRAINT "qr_codes_updated_by_id_fkey" FOREIGN KEY ("updated_by_id") REFERENCES "auth"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."requests" ADD CONSTRAINT "requests_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "core"."organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."requests" ADD CONSTRAINT "requests_namespace_id_fkey" FOREIGN KEY ("namespace_id") REFERENCES "core"."namespaces"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."requests" ADD CONSTRAINT "requests_qrcode_id_fkey" FOREIGN KEY ("qrcode_id") REFERENCES "core"."qr_codes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."requests" ADD CONSTRAINT "requests_assigned_to_fkey" FOREIGN KEY ("assigned_to") REFERENCES "auth"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."requests" ADD CONSTRAINT "requests_completed_by_fkey" FOREIGN KEY ("completed_by") REFERENCES "auth"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."requests" ADD CONSTRAINT "requests_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "auth"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."requests" ADD CONSTRAINT "requests_updated_by_id_fkey" FOREIGN KEY ("updated_by_id") REFERENCES "auth"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "core"."feedback" ADD CONSTRAINT "feedback_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "core"."requests"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
