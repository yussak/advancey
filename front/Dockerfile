FROM node:16.13.1-alpine

ENV HOST 0.0.0.0
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

WORKDIR /app

# ECRデプロイのため追加
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

RUN apk update && \
  apk upgrade && \
  npm install -g npm@8.1.2

COPY . /app

# ECRデプロイのため追加
RUN npm run build

EXPOSE 8080

# ECRデプロイのため追加
CMD ["npm", "run", "start"]