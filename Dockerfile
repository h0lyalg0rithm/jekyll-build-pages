ARG RUBY_VERSION=2.7.8
FROM ruby:$RUBY_VERSION-slim

RUN apt-get update \
  && apt-get install -y \
    build-essential \
    git \
    locales \
    nodejs

COPY Gemfile Gemfile

RUN gem install bundler:2.4.10
RUN export DISABLE_WHITELIST=true
RUN NOKOGIRI_USE_SYSTEM_LIBRARIES=true bundle install

RUN \
  echo "en_US UTF-8" > /etc/locale.gen && \
  locale-gen en-US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

