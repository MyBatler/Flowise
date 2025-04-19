# שלב 1: בנה את אפליקציית Flowise כמו תמיד
FROM node:20-alpine as build
RUN apk add --update libc6-compat python3 make g++ build-base cairo-dev pango-dev chromium curl
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV NODE_OPTIONS=--max-old-space-size=8192
RUN npm install -g pnpm
WORKDIR /usr/src
COPY . .
RUN pnpm install
RUN pnpm build

# שלב 2: בנה את סביבת ההרצה עם NGINX
FROM nginx:alpine

# העתק את Flowise מהבנייה
COPY --from=build /usr/src /app

# העתק את קבצי ההגדרה של NGINX וה־.htpasswd
COPY nginx.conf /etc/nginx/nginx.conf
COPY .htpasswd /etc/nginx/.htpasswd

# חשוף את הפורט
EXPOSE 80

# הפעל את Flowise ואת NGINX ביחד
CMD ["/bin/sh", "-c", "cd /app && pnpm start & nginx -g 'daemon off;'"]
