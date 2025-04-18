FROM node:20-alpine as build
RUN npm install -g flowise

FROM nginx:alpine
COPY --from=build /usr/local/bin/flowise /usr/local/bin/flowise
COPY --from=build /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY .htpasswd /etc/nginx/.htpasswd

EXPOSE 80
CMD ["sh", "-c", "flowise start & nginx -g 'daemon off;'"]