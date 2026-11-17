FROM nginx:1.27-alpine

COPY deployment/nginx.conf /etc/nginx/conf.d/default.conf
COPY output/ /usr/share/nginx/html/

EXPOSE 80
