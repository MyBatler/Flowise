# שלב 1: בנה את אפליקציית Flowise
FROM node:20-alpine as build
RUN apk add --update libc6-compat python3 make g++ build-base cairo-dev pango-dev chromium curl
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV NODE_OPTIONS=--max-old-space-size=8192
RUN npm install -g pnpm
RUN npm install -g flowise

WORKDIR /usr/src
COPY . .
RUN pnpm install
RUN pnpm build

# שלב 2: סביבת NGINX
FROM nginx:alpine

COPY --from=build /usr/local/bin/flowise /usr/local/bin/flowise
COPY --from=build /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=build /usr/src /app

# קונפיג + הגנה בסיסמה
COPY nginx.conf /etc/nginx/nginx.conf
COPY .htpasswd /etc/nginx/.htpasswd

# הפורט ש־Render מאזין אליו
EXPOSE 80

# ודא שאתה במיקום הנכון לפני הרצה
WORKDIR /app

# הרץ את Flowise ואז NGINX רק כשהוא מוכן
CMD ["sh", "-c", "flowise start & while ! nc -z localhost 3000; do sleep 1; done; nginx -g 'daemon off;'"]
