#!/usr/bin/dumb-init /bin/sh

#Fluentd.conf template
echo "<source>" > /fluentd/etc/fluent.conf
echo "  @type tail" >> /fluentd/etc/fluent.conf
echo "  path ${LOG_PATH}" >> /fluentd/etc/fluent.conf
echo "  pos_file ${POS_FILE}" >> /fluentd/etc/fluent.conf
echo "  tag ${TAG}" >> /fluentd/etc/fluent.conf
echo "  refresh_interval ${REFRESH_INTERVAL}" >> /fluentd/etc/fluent.conf
echo "  <parse>" >> /fluentd/etc/fluent.conf
echo "    @type json" >> /fluentd/etc/fluent.conf
echo "  </parse>" >> /fluentd/etc/fluent.conf
echo "</source>" >> /fluentd/etc/fluent.conf
echo "<match ${TAG}>" >> /fluentd/etc/fluent.conf
echo "  @type kinesis_firehose" >> /fluentd/etc/fluent.conf
echo "  region ${REGION}" >> /fluentd/etc/fluent.conf
echo "  delivery_stream_name ${DELIVERY_STREAM_NAME}" >> /fluentd/etc/fluent.conf
echo "  flush_interval ${FLUSH_INTERVAL}" >> /fluentd/etc/fluent.conf
echo "  chunk_limit_size ${CHUNK_LIMIT_SIZE}" >> /fluentd/etc/fluent.conf
echo "  flush_thread_interval ${FLUSH_THREAD_INTERVAL}" >> /fluentd/etc/fluent.conf
echo "  flush_thread_burst_interval ${FLUSH_THREAD_INTERVAL_BURST_INTERVAL}" >> /fluentd/etc/fluent.conf
echo "  flush_thread_count ${FLUSH_THREAD_COUNT}" >> /fluentd/etc/fluent.conf
echo "  <instance_profile_credentials>" >> /fluentd/etc/fluent.conf
echo "    ip_address 169.254.170.2${AWS_CONTAINER_CREDENTIALS_RELATIVE_URI}" >> /fluentd/etc/fluent.conf
echo "    port 80" >> /fluentd/etc/fluent.conf
echo "  </instance_profile_credentials>" >> /fluentd/etc/fluent.conf
echo "</match>" >> /fluentd/etc/fluent.conf
echo "<system>" >> /fluentd/etc/fluent.conf
echo "  log_level trace" >> /fluentd/etc/fluent.conf
echo "</system>" >> /fluentd/etc/fluent.conf

uid=${FLUENT_UID:-1000}

# check if a old fluent user exists and delete it
cat /etc/passwd | grep fluent
if [ $? -eq 0 ]; then
    deluser fluent
fi

# (re)add the fluent user with $FLUENT_UID
adduser -D -g '' -u ${uid} -h /home/fluent fluent

# chown home and data folder
chown -R fluent /home/fluent
chown -R fluent /fluentd

exec su-exec fluent "$@"


