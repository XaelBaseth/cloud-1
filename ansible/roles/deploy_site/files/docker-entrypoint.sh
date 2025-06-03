#!/bin/bash
set -e

# Wait for DB
echo "Waiting for DB to be ready..."
until mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
  sleep 2
done

# Install WordPress if needed
if ! wp core is-installed --path=/var/www/html --allow-root; then
  echo "Installing WordPress..."
  wp core install \
    --url="https://${WORDPRESS_DOMAIN}" \
    --title="Cloud1 Project" \
    --admin_user=bob \
    --admin_password="${WORDPRESS_ADMIN_PASSWORD:-admin123}" \
    --admin_email="admin@${WORDPRESS_DOMAIN}" \
    --skip-email \
    --allow-root

  echo "Activating theme..."
  wp theme activate twentytwentyfour --path=/var/www/html --allow-root
fi

# Start the original entrypoint (don't background it!)
exec docker-entrypoint.sh apache2-foreground
