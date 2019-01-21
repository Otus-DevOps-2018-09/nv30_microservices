FROM alpine:3.8

ENV BUNDLER_VERSION 1.17.2
ENV APP_HOME /app
ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

WORKDIR $APP_HOME
ADD . $APP_HOME

RUN apk update \
    && apk add --no-cache ruby ruby-bundler ruby-dev ruby-json build-base \
    && gem install bundler:"$BUNDLER_VERSION" bigdecimal --no-ri --no-rdoc \
    && cd $APP_HOME \
    && bundle install \
    && apk del build-base

CMD ["puma"]
