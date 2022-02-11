# FROM node:16.13.1-alpine

# ENV HOST 0.0.0.0

# WORKDIR /portfolio_app

# RUN apk update && \
#   apk upgrade && \
#   npm install -g npm

# EXPOSE 8080

# FROM node:16.13.1-alpine
FROM node:16.13.1

WORKDIR /app

ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

ADD package.json /app/package.json
ADD package-lock.json /app/package-lock.json

RUN apt-get update -y && \
  apt-get upgrade -y && \
  npm install npm@8.1.2 && \
  npm install ejs@3.0.1 &&\
  npm install nuxt@2.15.8 &&\
  npm install create-nuxt-app@4.0.0 &&\
  npm install defu@3.1.0

ADD . /app

RUN npm run build

# EXPOSE 3000
EXPOSE 8080

CMD ["npm", "run", "start"]
