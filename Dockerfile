FROM ruby:2.3.3-slim

MAINTAINER Q <q@oddesign.expert>


RUN apt-get update && apt-get install -qq -y --no-install-recommends build-essential sudo curl git imagemagick \
# for postgres
    && apt-get install -y libpq-dev \
# for nokogiri
    && apt-get install -y libxml2-dev libxslt1-dev \
# for capybara-webkit
    && apt-get install -y libqt4-webkit libqt4-dev xvfb \
# for a JS runtime
    && curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash - \
    && apt-get install -y nodejs\
# clean up
    && rm -rf /var/lib/apt/lists/*

ENV INSTALL_PATH=/app

RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

COPY Gemfile* ./
RUN bundle install --jobs 20 --retry 5

COPY . ./
