FROM nexus.dev.autoweb.com/base/fluentd:1.0

RUN apk add --update --virtual .build-deps \
        sudo build-base ruby-dev \
 && sudo gem install \
        fluent-plugin-kinesis \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /var/cache/apk/* \
           /home/fluent/.gem/ruby/2.3.0/cache/*.gem

COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

ENV POS_FILE=/fluentd/log/access.log.pos 

ENV TAG=clicks.logs

ENV REFRESH_INTERVAL=1s

ENV REGION=us-west-2

ENV DELIVERY_STREAM_NAME=test

ENV FLUSH_INTERVAL=1

ENV CHUNK_LIMIT_SIZE=1m

ENV FLUSH_THREAD_INTERVAL=0.1

ENV FLUSH_THREAD_INTERVAL_BURST_INTERVAL=0.01

ENV FLUSH_THREAD_COUNT=15

ENV LOG_PATH=/fluentd/log/*.log 

ENV ROTATE_WAIT=120

ENV LIMIT_RECENTLY_MODIFIED=120




