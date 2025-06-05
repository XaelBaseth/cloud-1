#!/bin/sh
echo "[WP config] Configuring WordPress..."
echo "[WP config] Waiting for MariaDB..."
until mysql -h${WORDPRESS_DB_HOST} -u${WORDPRESS_DB_NAME} -p${WORDPRESS_DB_PASSWORD} -e "USE ${WORDPRESS_DB_NAME};" >/dev/null 2>&1; do
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
    wp config create --dbname=${WORDPRESS_DB_NAME} --dbuser=${WORDPRESS_USER_NAME} --dbpass=${WORDPRESS_DB_PASSWORD} --dbhost=${WORDPRESS_DB_HOST} --path=${WP_PATH} --allow-root
    wp core install \
        --url=https://${VIRTUAL_HOST} \
        --title="Cloud1" \
        --admin_user=${WORDPRESS_ADMIN_NAME} \
        --admin_password=${WORDPRESS_ADMIN_PASSWORD} \
        --admin_email=${LETSENCRYPT_EMAIL} \
        --path=${WP_PATH} --allow-root
    wp option update siteurl https://${VIRTUAL_HOST} --path=${WP_PATH} --allow-root
    wp option update home https://${VIRTUAL_HOST} --path=${WP_PATH} --allow-root
    wp user create ${WORDPRESS_USER_NAME} ${WORDPRESS_USER_EMAIL} --user_pass=${WORDPRESS_USER_PASSWORD} --role=subscriber --display_name=${WORDPRESS_USER_NAME} --porcelain --path=${WP_PATH} --allow-root
    wp theme install twentytwentyfour --path=${WP_PATH} --activate --allow-root
fi

# # Always ensure URLs are HTTPS
# wp option update siteurl https://${VIRTUAL_HOST} --path=${WP_PATH} --allow-root
# wp option update home https://${VIRTUAL_HOST} --path=${WP_PATH} --allow-root

# # Enhanced HTTPS configuration for reverse proxy
# if ! grep -q "HTTP_X_FORWARDED_PROTO" ${WP_PATH}/wp-config.php; then
#     echo "[WP config] Patching wp-config.php for HTTPS behind reverse proxy..."
    
#     # Remove the "That's all, stop editing!" line temporarily
#     sed -i "/\/\* That's all, stop editing! Happy publishing\. \*\//d" ${WP_PATH}/wp-config.php
    
#     # Append the HTTPS configuration and restore the "That's all" line at the end
#     cat <<'EOF' >> ${WP_PATH}/wp-config.php

# /* HTTPS behind reverse proxy configuration */
# if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
#     $_SERVER['HTTPS'] = 'on';
#     $_SERVER['SERVER_PORT'] = 443;
# }
# /* Force HTTPS for all WordPress URLs */
# if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
#     define('FORCE_SSL_ADMIN', true);
# }
# /* Fix WordPress behind reverse proxy */
# if (isset($_SERVER['HTTP_X_FORWARDED_HOST'])) {
#     $_SERVER['HTTP_HOST'] = $_SERVER['HTTP_X_FORWARDED_HOST'];
# }

# /* That's all, stop editing! Happy publishing. */
# EOF
# fi

# # Replace any existing HTTP URLs with HTTPS
# wp search-replace "http://${VIRTUAL_HOST}" "https://${VIRTUAL_HOST}" --all-tables --allow-root
# wp search-replace 'http://' 'https://' --all-tables --allow-root

# # Clear any caches
# wp cache flush --allow-root

echo "[WP config] WordPress HTTPS configuration completed."
exec "$@"