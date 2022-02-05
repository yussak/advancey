FROM node:16.13.1-alpine

ENV HOST 0.0.0.0

WORKDIR /portfolio_app

RUN apk update && \
  apk upgrade && \
  npm install -g npm

EXPOSE 8080