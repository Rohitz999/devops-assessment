#!/bin/bash

# ==========================================
# PostgreSQL Backup Script
# ==========================================

set -e

# Database Configuration
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-hoteldb}
DB_USER=${DB_USER:-postgres}
DB_PASSWORD=${DB_PASSWORD:-Password@123}

# Backup Directory
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/hoteldb_${TIMESTAMP}.sql"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

export PGPASSWORD="$DB_PASSWORD"

echo "========================================="
echo "Starting PostgreSQL Backup..."
echo "Database : $DB_NAME"
echo "Host     : $DB_HOST"
echo "Backup   : $BACKUP_FILE"
echo "========================================="

pg_dump \
    -h "$DB_HOST" \
    -p "$DB_PORT" \
    -U "$DB_USER" \
    -d "$DB_NAME" \
    -F p \
    -f "$BACKUP_FILE"

unset PGPASSWORD

echo ""
echo "Backup completed successfully."
echo "Backup saved at:"
echo "$BACKUP_FILE"
