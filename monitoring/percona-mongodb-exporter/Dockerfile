FROM       alpine:3.8
MAINTAINER Nikita Gorlov
EXPOSE     9216

ENV GOPATH /go
ENV APPPATH $GOPATH/src/github.com/percona/mongodb_exporter
RUN apk add --update -t build-deps go git mercurial libc-dev gcc libgcc
RUN git clone "https://github.com/percona/mongodb_exporter" "$APPPATH"
RUN cd $APPPATH && go get -d && go build -o /bin/mongodb_exporter
RUN apk del --purge build-deps && rm -rf $GOPATH

ENTRYPOINT [ "/bin/mongodb_exporter" ]
