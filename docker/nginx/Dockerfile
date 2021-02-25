FROM nginx:1.19.7-alpine

RUN mkdir log
COPY public public/
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf

CMD [ "/usr/sbin/nginx" ]
