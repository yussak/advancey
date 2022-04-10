FROM node:16.13.1

ENV HOST 0.0.0.0
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

WORKDIR /app

COPY package.json ./
COPY package-lock.json ./
RUN npm install -g npm@8.1.2

COPY . .

RUN npm run build

EXPOSE 8080

CMD ["npm", "run", "start"]