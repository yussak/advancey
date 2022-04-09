FROM ruby:3.0.2

RUN apt-get update -qq && \
  apt-get install -y build-essential \
  sudo \
  nginx && \
  gem install bundler:2.2.22

WORKDIR /app
COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle install
COPY . .

RUN mkdir -p tmp/sockets \
  && groupadd nginx \
  && useradd -g nginx nginx

COPY nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
CMD ["entrypoint.sh"]