# DevOps Assessment – Hotel Booking Platform

## Overview

This repository contains the infrastructure and database automation for a Hotel Booking Platform. The project demonstrates Infrastructure as Code (IaC), PostgreSQL database management, backup & restore automation, and CI validation using Terraform.

---

# Project Structure

```text
devops-assessment/
├── .github/
│   └── workflows/
│       └── terraform.yml
│
├── database/
│   ├── docker-compose.yml
│   └── init/
│       ├── 001_create_tables.sql
│       ├── 002_seed_data.sql
│       ├── 003_indexes.sql
│       └── 004_booking_events.sql
│
├── infra/
│   ├── envs/
│   │   ├── dev/
│   │   │   ├── backend.tf
│   │   │   ├── provider.tf
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   ├── random.tf
│   │   │   └── terraform.tfvars
│   │   │
│   │   └── prod/
│   │       ├── backend.tf
│   │       ├── provider.tf
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       ├── outputs.tf
│   │       ├── random.tf
│   │       └── terraform.tfvars
│   │
│   └── modules/
│       ├── network/
│       ├── alb/
│       ├── ecs/
│       └── rds/
│
├── scripts/
│   ├── backup.sh
│   ├── restore.sh
│   └── backups/
│
└── README.md
```

---

# Technologies Used

- Terraform
- AWS
- Amazon VPC
- ECS Fargate
- Application Load Balancer
- Amazon RDS PostgreSQL
- Docker
- PostgreSQL 16
- GitHub Actions
- Bash
- Linux

---

# Terraform Infrastructure

The infrastructure is built using reusable Terraform modules.

## Modules

- Network (VPC, Public & Private Subnets)
- Application Load Balancer
- ECS Cluster & Service
- Amazon RDS PostgreSQL

## Environments

```
infra/envs/dev
infra/envs/prod
```

Each environment contains:

- provider.tf
- backend.tf
- main.tf
- variables.tf
- outputs.tf
- terraform.tfvars

---

# Terraform Backend

## Local Development

For local development, the S3 backend in `backend.tf` is commented out.

This allows Terraform to use the default **local backend**, making it possible to test and validate the configuration without creating an S3 bucket or configuring remote state.

Run locally:

```bash
cd infra/envs/dev

terraform fmt -recursive
terraform init
terraform validate
terraform plan -refresh=false
```

---

## Remote Backend (AWS)

For production or shared environments, uncomment the S3 backend configuration in:

```
infra/envs/dev/backend.tf
infra/envs/prod/backend.tf
```

Example:

```hcl
terraform {
  backend "s3" {
    bucket = "terraform-state-bucket"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
  }
}
```

After enabling the backend:

```bash
terraform init -reconfigure
```

---

# Database

The PostgreSQL database is initialized automatically using Docker Compose.

## Tables

### hotel_bookings

Stores hotel booking information.

### booking_events

Stores booking lifecycle events.

---

# Features

- UUID Primary Keys
- Foreign Keys
- JSONB Payload
- Composite Index
- Seed Data
- Booking Event History

---

# Running PostgreSQL

Move into the database directory.

```bash
cd database
```

Start PostgreSQL.

```bash
docker compose up -d
```

Verify the container.

```bash
docker ps
```

Connect to PostgreSQL.

```bash
docker exec -it hotel-postgres psql -U postgres -d hoteldb
```

---

# Verify Database

List tables.

```sql
\dt
```

Expected

```
hotel_bookings
booking_events
```

Verify booking records.

```sql
SELECT COUNT(*) FROM hotel_bookings;
```

Expected

```
100
```

Verify booking events.

```sql
SELECT COUNT(*) FROM booking_events;
```

Expected

```
75
```

---

# Sample Query

```sql
SELECT
    org_id,
    status,
    COUNT(*) AS total_bookings,
    SUM(amount) AS total_amount
FROM hotel_bookings
WHERE city='delhi'
AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id,status
ORDER BY total_bookings DESC;
```

---

# Database Backup

Move into the scripts directory.

```bash
cd scripts
```

Run backup.

```bash
./backup.sh
```

Example output:

```
Backup completed successfully.

backups/hoteldb_YYYYMMDD_HHMMSS.sql
```

---

# Database Restore

Create a new database.

```sql
CREATE DATABASE hoteldb_restore;
```

Restore the backup.

```bash
./restore.sh backups/hoteldb_YYYYMMDD_HHMMSS.sql hoteldb_restore
```

Verify the restored database.

```sql
\c hoteldb_restore

SELECT COUNT(*) FROM hotel_bookings;

SELECT COUNT(*) FROM booking_events;
```

---

# GitHub Actions

The repository includes a GitHub Actions workflow for Terraform validation.

Workflow location:

```
.github/workflows/terraform.yml
```

The workflow performs:

- Terraform Format Check
- Terraform Init
- Terraform Validate

GitHub Actions initializes Terraform using:

```bash
terraform init -backend=false
```

This disables the S3 backend during CI execution, allowing Terraform validation without requiring remote state or an AWS S3 bucket.

> **Note**
>
> `terraform plan` is intentionally not executed in GitHub Actions because it requires valid AWS credentials. It should be run locally or in an environment where AWS credentials are configured.

---

# Local Terraform Validation

```bash
cd infra/envs/dev

terraform fmt -recursive

terraform init

terraform validate

terraform plan -refresh=false
```

---

# Testing Checklist

## Database

- ✅ Docker Compose starts PostgreSQL
- ✅ Tables created automatically
- ✅ Seed data inserted
- ✅ Composite index created
- ✅ Backup script executed successfully
- ✅ Restore script executed successfully
- ✅ Restored database verified

## Terraform

### Local

- ✅ terraform fmt
- ✅ terraform init
- ✅ terraform validate
- ✅ terraform plan -refresh=false

### GitHub Actions

- ✅ terraform fmt
- ✅ terraform init -backend=false
- ✅ terraform validate

---

# Assumptions

- Docker Desktop is installed.
- Terraform 1.9+ is installed.
- PostgreSQL client utilities (`psql` and `pg_dump`) are installed.
- AWS credentials are configured if running `terraform plan` against AWS resources.
- The S3 backend is commented out for local development and enabled only when using remote state.

---

# Author

**Rohit Vishwakarma**

DevOps Engineer

## Skills

- AWS
- Terraform
- Docker
- Kubernetes
- Jenkins
- GitHub Actions
- Linux
- PostgreSQL
- Bash Scripting