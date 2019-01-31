FROM registry.2le.net/2le/2le:base-php7-apache
COPY ./docker/php/php.ini /usr/local/etc/php/
COPY ./docker/apache/default.conf /etc/apache2/sites-available/000-default.conf
COPY . /var/www/html/
WORKDIR /var/www/html
RUN composer install
RUN npm install
RUN bin/console assets:install
RUN ./node_modules/.bin/encore production
RUN rm -rf /var/www/html/var/cache/*; chmod -R 777 /var/www/html/var
EXPOSE 80
CMD ["sh", "-c","make migrate;apache2-foreground"]
