# Stage 1: Build stage
FROM node:20-alpine AS build

USER root

# Skip downloading Chrome for Puppeteer (saves build time)
ENV PUPPETEER_SKIP_DOWNLOAD=true

# Install latest Flowise globally (specific version can be set: flowise@1.0.0)
RUN npm install -g flowise

# Stage 2: Runtime stage
FROM node:20-alpine

# Install runtime dependencies
RUN apk add --no-cache chromium git python3 py3-pip make g++ build-base cairo-dev pango-dev curl

# Set the environment variable for Puppeteer to find Chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# ✅ Add these lines for password protection:
**ENV FLOWISE_USERNAME=admin2511
**ENV FLOWISE_PASSWORD=20d115ee6376f1018bb7c5cfafaf0671

# Copy Flowise from the build stage
COPY --from=build /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=build /usr/local/bin /usr/local/bin

ENTRYPOINT ["flowise", "start"]
