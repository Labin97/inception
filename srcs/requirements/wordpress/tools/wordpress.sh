#!/bin/sh

# check if WordPress is installed
if [ ! -f /var/www/html/wp-config.php ]; then
# install WordPress
  /usr/local/bin/wp core download --allow-root --path=/var/www/html --force
  /usr/local/bin/wp config create --allow-root --path=/var/www/html --dbhost=$MARIADB_HOST_NAME:$MARIADB_PORT --dbname=$MARIADB_DB_NAME --dbuser=$MARIADB_USER --dbpass=$MARIADB_PWD --force
  /usr/local/bin/wp core install --allow-root --path=/var/www/html --url=$WP_URL --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --skip-email
  /usr/local/bin/wp user create --path=/var/www/html $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PWD --role=author
fi

touch $WORDPRESS_HEALTH

# start php-fpm
/usr/sbin/php-fpm81 --nodaemonize