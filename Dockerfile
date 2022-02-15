FROM ruby:3.0.2

RUN apt-get update -qq && \
  apt-get install -y build-essential \
  libpq-dev \
  sudo \
  nginx && \
  gem install bundler:2.2.22

WORKDIR /app
COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle install
COPY . .

RUN mkdir -p tmp/sockets \
  # && mkdir tmp/pids \
  && groupadd nginx \
  && useradd -g nginx nginx

COPY nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
CMD ["entrypoint.sh"]

# EXPOSE 3000

# CMD ["rails", "server", "-b", "0.0.0.0"]

# FROM ruby:3.0.2

# SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
#   && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
#   && apt-get update -qq \
#   && apt-get install -y nodejs yarn --no-install-recommends \
#   && apt-get clean \
#   && nginx \
#   && rm -rf /var/lib/apt/lists/*

# WORKDIR /app
# COPY Gemfile ./
# COPY Gemfile.lock ./
# RUN bundle install
# COPY . .

# RUN mkdir -p tmp/sockets \
#   && mkdir tmp/pids \
#   && groupadd nginx \
#   && useradd -g nginx nginx

# COPY nginx/nginx.conf /etc/nginx/nginx.conf

# EXPOSE 80

# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# CMD ["entrypoint.sh"]

# # EXPOSE 3000

# # CMD ["rails", "server", "-b", "0.0.0.0"]