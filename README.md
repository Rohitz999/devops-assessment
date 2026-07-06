# DevOps Assessment – Hotel Booking Platform

## Overview

This repository contains the infrastructure and database automation for a Hotel Booking Platform. The project demonstrates Infrastructure as Code (IaC), PostgreSQL database management, backup & restore automation, and CI validation using Terraform.

---

## Project Structure

```
devops-assessment/
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
│   │   └── prod/
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
- ECS Fargate
- Application Load Balancer
- Amazon RDS PostgreSQL
- Docker
- PostgreSQL 16
- GitHub Actions
- Bash

---

# Terraform Infrastructure

The Terraform code is modularized into reusable components.

### Modules

- Network (VPC, Public & Private Subnets)
- Application Load Balancer
- ECS Cluster & Service
- RDS PostgreSQL

### Environments

```
infra/envs/dev
infra/envs/prod
```

Each environment has its own:

- provider
- backend
- variables
- outputs
- terraform.tfvars

---

# Database

The PostgreSQL database is initialized automatically using Docker Compose.

## Tables

### hotel_bookings

Stores booking information.

### booking_events

Stores booking lifecycle events.

---

# Features

- Primary Keys
- Foreign Keys
- UUID support
- JSONB payload
- Composite indexes
- Sample seed data

---

# Running Database

Move to database directory

```bash
cd database
```

Start PostgreSQL

```bash
docker compose up -d
```

Verify container

```bash
docker ps
```

Connect to PostgreSQL

```bash
docker exec -it hotel-postgres psql -U postgres -d hoteldb
```

---

# Verify Database

List tables

```sql
\dt
```

Check booking records

```sql
SELECT COUNT(*) FROM hotel_bookings;
```

Expected

```
100
```

Check booking events

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
GROUP BY org_id,status;
```

---

# Backup

Move into scripts directory

```bash
cd scripts
```

Run

```bash
./backup.sh
```

Example Output

```
Backup completed successfully.

backups/hoteldb_YYYYMMDD_HHMMSS.sql
```

---

# Restore

Create a new database

```sql
CREATE DATABASE hoteldb_restore;
```

Restore

```bash
./restore.sh backups/hoteldb_YYYYMMDD_HHMMSS.sql hoteldb_restore
```

Verify

```sql
\c hoteldb_restore

SELECT COUNT(*) FROM hotel_bookings;

SELECT COUNT(*) FROM booking_events;
```

---

# Terraform

Go to environment

```bash
cd infra/envs/dev
```

Initialize

```bash
terraform init
```

Format

```bash
terraform fmt -recursive
```

Validate

```bash
terraform validate
```

Plan

```bash
terraform plan -refresh=false
```

---

# GitHub Actions

The repository includes CI validation for Terraform.

Pipeline performs:

- Terraform Format Check
- Terraform Init
- Terraform Validate
- Terraform Plan

---

# Testing Checklist

## Database

- docker compose up
- Tables created automatically
- Seed data inserted
- Index created
- Backup successful
- Restore successful

## Terraform

- terraform fmt
- terraform init
- terraform validate
- terraform plan -refresh=false

---

# Assumptions

- Docker Desktop is installed.
- Terraform 1.6+ is installed.
- PostgreSQL client utilities (pg_dump and psql) are installed.
- AWS credentials are configured if provisioning infrastructure.

---

# Author

**Rohit Vishwakarma**

DevOps Engineer

Skills:

- AWS
- Terraform
- Docker
- Kubernetes
- Jenkins
- GitHub Actions
- Linux
- PostgreSQL
