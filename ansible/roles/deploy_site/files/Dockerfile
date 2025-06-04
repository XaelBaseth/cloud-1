FROM wordpress:php8.1-apache

RUN apt-get update && apt-get install -y default-mysql-client curl\
	&& rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory-limit.ini
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Copy your entrypoint script
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
