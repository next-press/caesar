FROM wordpress:latest

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar

RUN mv wp-cli.phar /usr/local/bin/wp

RUN yes | pecl install xdebug

COPY xdebug.ini /usr/local/etc/php/conf.d

COPY .htaccess-single /var/www/html/.htaccess-single

COPY .htaccess-subdir /var/www/html/.htaccess-subdir

COPY .htaccess-subdomain /var/www/html/.htaccess-subdomain
