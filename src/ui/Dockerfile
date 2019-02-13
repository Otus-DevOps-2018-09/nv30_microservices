FROM alpine:3.8

ENV BUNDLER_VERSION 1.17.2
ENV APP_HOME /app
ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

WORKDIR $APP_HOME
ADD . $APP_HOME

RUN apk update \
    && apk add --no-cache ruby ruby-bundler ruby-dev ruby-json build-base \
    && gem install bundler:"$BUNDLER_VERSION" --no-ri --no-rdoc \
    && cd $APP_HOME \
    && bundle install \
    && apk del build-base

CMD ["puma"]
