FROM ubuntu

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -q -y install php5 libapache2-mod-php5 php5-mcrypt php5-mysql php5-json php5-curl php5-cli git curl

ENV PHP_VERSION="system"

RUN php5enmod mcrypt
RUN a2enmod rewrite
RUN mkdir -p /app
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY . /app/
WORKDIR /app
RUN rm /etc/apache2/sites-available/000-default.conf \
    && touch /etc/apache2/sites-available/000-default.conf \
    && echo '      <VirtualHost *:80>\n          DocumentRoot /app\n          <Directory /app>\n              Options -Indexes +FollowSymLinks +MultiViews\n              AllowOverride All\n              Require all granted\n          </Directory>\n          ErrorLog ${APACHE_LOG_DIR}/error.log\n          LogLevel warn\n          CustomLog ${APACHE_LOG_DIR}/access.log combined\n      </VirtualHost>' > /etc/apache2/sites-available/000-default.conf
# RUN composer install --prefer-source --no-interaction --no-dev
RUN chown -R www-data:www-data /app

EXPOSE 80
