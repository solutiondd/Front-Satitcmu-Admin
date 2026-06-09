FROM node:24-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npm run build

FROM nginx:alpine

RUN mkdir -p /usr/share/nginx/html/dashboard

COPY --from=build /app/dist/ /usr/share/nginx/html/dashboard/

EXPOSE 80
