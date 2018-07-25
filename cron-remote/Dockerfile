FROM node:8-alpine as builder
RUN mkdir /app
WORKDIR /app
COPY package.json .
COPY .babelrc .
COPY src ./src/
RUN apk add --no-cache util-linux \
    && yarn install \
    && yarn run build


FROM node:8-alpine
MAINTAINER dishuostecli "dishuostec@gmail.com"
RUN apk add --no-cache tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo Asia/Shanghai > /etc/timezone \
    && mkdir /app

WORKDIR /app
COPY package.json ./
COPY --from=builder /app/dist/* ./dist/
COPY cron ./cron/

USER root
ENV NODE_ENV="production"

RUN yarn install \
    && yarn cache clean

EXPOSE 3000
CMD ["yarn", "start"]
