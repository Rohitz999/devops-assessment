#!/bin/bash

set -e

DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-hoteldb_restore}
DB_USER=${DB_USER:-postgres}
DB_PASSWORD=${DB_PASSWORD:-Password@123}

if [ $# -eq 0 ]; then
    echo "Usage: ./restore.sh <backup-file.sql>"
    exit 1
fi

BACKUP_FILE=$1

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Backup file not found: $BACKUP_FILE"
    exit 1
fi

export PGPASSWORD="$DB_PASSWORD"

echo "========================================="
echo "Restoring PostgreSQL Database..."
echo "Database : $DB_NAME"
echo "Backup   : $BACKUP_FILE"
echo "========================================="

psql \
    -h "$DB_HOST" \
    -p "$DB_PORT" \
    -U "$DB_USER" \
    -d "$DB_NAME" \
    -f "$BACKUP_FILE"

unset PGPASSWORD

echo ""
echo "Database restored successfully."
