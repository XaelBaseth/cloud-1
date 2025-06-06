#!/bin/sh

set -e

chown -R www-data:www-data /var/www/html
echo "[WP setup] Waiting for MariaDB..."
until mysql -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" -e "USE $WORDPRESS_DB_NAME;" >/dev/null 2>&1; do
    sleep 3
done
echo "[WP setup] MariaDB is accessible."

WP_PATH=/var/www/html

if wp core is-installed --path="$WP_PATH" --allow-root; then
    echo "[WP setup] WordPress already installed."
else
    echo "[WP setup] Installing WordPress..."

    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --path="$WP_PATH" --allow-root

    wp core install \
        --url="http://${VIRTUAL_HOST}" \
        --title="Cloud1" \
        --admin_user="$WORDPRESS_ADMIN_NAME" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$LETSENCRYPT_EMAIL" \
        --path="$WP_PATH" --allow-root

    wp user create "$WORDPRESS_USER_NAME" "$WORDPRESS_USER_EMAIL" \
        --user_pass="$WORDPRESS_USER_PASSWORD" \
        --role=subscriber \
        --display_name="$WORDPRESS_USER_NAME" \
        --path="$WP_PATH" --allow-root

    wp theme install twentytwentyfour --activate \
        --path="$WP_PATH" --allow-root

    echo "[WP setup] Waiting for HTTPS to become available..."
    until curl -sk https://${VIRTUAL_HOST} >/dev/null 2>&1; do
        sleep 5
    done
fi

echo "[WP setup] Done."
exec "$@"
