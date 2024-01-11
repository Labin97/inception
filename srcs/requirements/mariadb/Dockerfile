FROM alpine:3.18

RUN apk update && \
	apk upgrade && \
	apk add mariadb && \
	apk add mariadb-client && \
	apk add dumb-init

# 데이터 디렉토리와 실행 디렉토리 생성
RUN mariadb-install-db --datadir=/var/lib/mysql --auth-root-authentication-method=normal
RUN mkdir -p /run/mysqld /var/lib/mysql

# MariaDB 설정 파일 및 실행 스크립트 복사
COPY conf/my.cnf /etc/my.cnf
COPY tools/mariadb.sh /usr/local/bin/mariadb.sh

# 스크립트 실행 권한 부여
RUN chmod +x /usr/local/bin/mariadb.sh

# 포트 노출
EXPOSE 3306

# 컨테이너 실행 시 스크립트 실행
ENTRYPOINT [ "/usr/bin/dumb-init", "--", "/usr/local/bin/mariadb.sh"]