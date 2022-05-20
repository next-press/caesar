FROM wordpress:latest

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar

RUN mv wp-cli.phar /usr/local/bin/wp

RUN yes | pecl install xdebug

COPY xdebug.ini /usr/local/etc/php/conf.d

COPY htaccess-single /usr/src/wordpress/.htaccess-single

COPY htaccess-subdir /usr/src/wordpress/.htaccess-subdir

COPY htaccess-subdomain /usr/src/wordpress/.htaccess-subdomain
