#!/bin/sh

# MySQL 초기 설정 스크립트
# 이 스크립트는 .env 파일에서 설정한 환경 변수를 사용하여 MySQL 초기 설정을 수행합니다.
# touch /var/run/mysqld/mysqld.sock

# .env 파일에서 환경 변수 읽기
cat << EOF > config.sql
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $MARIADB_DB_NAME;
CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PWD';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MARIADB_ROOT_PWD';
GRANT ALL PRIVILEGES ON $MARIADB_DB_NAME.* TO '$MARIADB_USER'@'%' WITH GRANT OPTION;
CREATE USER IF NOT EXISTS '$MARIADB_USER'@'localhost' IDENTIFIED BY '$MARIADB_PWD';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MARIADB_ROOT_PWD';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PWD';
GRANT ALL PRIVILEGES ON $MARIADB_DB_NAME.* TO '$MARIADB_USER'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON $MARIADB_DB_NAME.* TO '$MARIADB_USER'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# MySQL 초기 설정 적용
mysqld --bootstrap < config.sql

# 파일 및 디렉토리 소유자 변경
chown -R mysql:mysql /run/mysqld /var/lib/mysql

touch $MARIADB_HEALTH

# MySQL 시작
mysqld --user=mysql --datadir=/var/lib/mysql