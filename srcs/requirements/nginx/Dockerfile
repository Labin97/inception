FROM alpine:3.18

# 필요한 패키지 설치
RUN apk update && \
    apk upgrade && \
    apk add nginx openssl dumb-init

# SSL 인증서 생성
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/cert.key -out /etc/nginx/cert.crt \
    -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/CN=yim"

# Nginx 설정 파일 복사
COPY conf/nginx.conf /etc/nginx/nginx.conf

# 포트 노출
EXPOSE 443

# 컨테이너 실행 시 스크립트 실행
ENTRYPOINT [ "dumb-init", "--" ]
CMD [ "nginx", "-g", "daemon off;" ]
