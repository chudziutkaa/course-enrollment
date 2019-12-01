FROM ruby:2.6.5
ENV RAILS_ENV development

RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN gem install bundler:2.0.2
RUN bundle install
COPY . /app
