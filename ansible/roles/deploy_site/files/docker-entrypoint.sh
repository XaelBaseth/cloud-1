cat docker-entrypoint.sh 
#!/bin/sh

echo "[WP config] Configuring WordPress..."

echo "[WP config] Waiting for MariaDB..."

until mysql -h${WORDPRESS_DB_HOST} -u${WORDPRESS_DB_USER} -p${WORDPRESS_DB_PASSWORD} -e "USE ${WORDPRESS_DB_NAME};" >/dev/null 2>&1; do
    sleep 3
done

echo "[WP config] MariaDB accessible."

WP_PATH=/var/www/html

mkdir -p ${WP_PATH}

if [ -f ${WP_PATH}/wp-config.php ]; then
    echo "[WP config] WordPress already configured."
else
    echo "[WP config] Setting up WordPress..."
    wp cli update --yes --allow-root
    wp core download --allow-root --path=${WP_PATH}
    wp config create --dbname=${WORDPRESS_DB_NAME} --dbuser=${WORDPRESS_DB_USER} --dbpass=${WORDPRESS_DB_PASSWORD} --dbhost=${WORDPRESS_DB_HOST} --path=${WP_PATH} --allow-root
    wp core install \
	--url=https://${VIRTUAL_HOST} \
	--title="Cloud1" \
	--admin_user=${WORDPRESS_ADMIN_NAME} \
	--admin_password=${WORDPRESS_ADMIN_PASSWORD} \
	--admin_email=${LETSENCRYPT_EMAIL} \
	--path=${WP_PATH} --allow-root
    wp option update siteurl https://${VIRTUAL_HOST} --path=${WP_PATH} --allow-root
	wp option update home https://${VIRTUAL_HOST} --path=${WP_PATH} --allow-root
	wp user create ${WORDPRESS_DB_USER} ${WORDPRESS_USER_EMAIL} --user_pass=${WORDPRESS_USER_PASSWORD} --role=subscriber --display_name=${WORDPRESS_USER} --path=${WP_PATH} --allow-root
    wp theme install blocksy --path=${WP_PATH} --activate --allow-root
fi

exec "$@"
