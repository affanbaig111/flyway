#!/bin/bash
set -e

ENV_FILE=".env"

# Check if .env file exists
if [ ! -f "$ENV_FILE" ]; then
  echo "Missing .env file in current directory."
  exit 1
fi

# Extract only needed variables
CONTAINER_NAME=$(grep '^CONTAINER_NAME=' "$ENV_FILE" | cut -d '=' -f2-)
DB_USER=$(grep '^DB_USER=' "$ENV_FILE" | cut -d '=' -f2-)
DB_PASSWORD=$(grep '^DB_PASSWORD=' "$ENV_FILE" | cut -d '=' -f2-)
DATABASES=$(grep '^DATABASES=' "$ENV_FILE" | cut -d '=' -f2-)

# Validate extracted values
if [[ -z "$CONTAINER_NAME" || -z "$DB_USER" || -z "$DB_PASSWORD" || -z "$DATABASES" ]]; then
  echo "Missing required environment variables. Check your .env file."
  exit 1
fi

IFS=',' read -ra DB_ARRAY <<< "$DATABASES"

for DB in "${DB_ARRAY[@]}"; do
    echo "Truncating tables in database: $DB"

    docker exec -e PGPASSWORD=$DB_PASSWORD "$CONTAINER_NAME" bash -c "
        TABLES=\$(psql -U $DB_USER -d $DB -Atc \"SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename != 'flyway_schema_history';\")

        if [ -z \"\$TABLES\" ]; then
            echo \"No tables found in \$DB\"
        else
            TABLE_LIST=\$(echo \"\$TABLES\" | paste -sd ',' -)
            echo \"Executing: TRUNCATE TABLE \$TABLE_LIST RESTART IDENTITY CASCADE;\"
            psql -U $DB_USER -d $DB -c \"TRUNCATE TABLE \$TABLE_LIST RESTART IDENTITY CASCADE;\"
        fi
    "
done
