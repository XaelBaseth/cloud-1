FROM wordpress:php8.4-apache

RUN apt-get update && apt-get install -y \
    default-mysql-client curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory-limit.ini \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Add HTTPS configuration for WordPress
RUN echo "<?php" > /usr/local/etc/php/conf.d/wordpress-https.php && \
    echo "if (isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) && \$_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {" >> /usr/local/etc/php/conf.d/wordpress-https.php && \
    echo "    \$_SERVER['HTTPS'] = 'on';" >> /usr/local/etc/php/conf.d/wordpress-https.php && \
    echo "}" >> /usr/local/etc/php/conf.d/wordpress-https.php

WORKDIR /var/www/html

RUN wp core download --allow-root || true

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN chown -R www-data:www-data /var/www/html

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
