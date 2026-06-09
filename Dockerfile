# build stage
FROM node:lts-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .

ARG VITE_APP_BASE_URL
ARG VITE_IMG_PROFILE_URL

ENV VITE_APP_BASE_URL=$VITE_APP_BASE_URL
ENV VITE_IMG_PROFILE_URL=$VITE_IMG_PROFILE_URL

RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
