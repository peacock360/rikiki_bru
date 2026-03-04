# Stage 1: Build
FROM node:22-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

ARG TELEGRAM_API_ID
ARG TELEGRAM_API_HASH
ARG BASE_URL=https://web.telegram.org/a/

ENV TELEGRAM_API_ID=$TELEGRAM_API_ID
ENV TELEGRAM_API_HASH=$TELEGRAM_API_HASH
ENV BASE_URL=$BASE_URL
ENV NODE_ENV=production

RUN npm run build:production

# Stage 2: Serve with Nginx
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
