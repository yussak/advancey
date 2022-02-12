FROM node:16.13.1-alpine

ENV HOST 0.0.0.0
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

WORKDIR /app

# ECRデプロイのため追加
ADD package.json /app/package.json
ADD package-lock.json /app/package-lock.json

RUN apk update && \
  apk upgrade && \
  npm install -g npm

ADD . /app

# ECRデプロイのため追加
RUN npm run build

EXPOSE 8080

# ECRデプロイのため追加
CMD ["npm", "run", "start"]