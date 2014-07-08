#!/bin/sh
TEMPLATE=/config.json.j2
CONFIGFILE=/usr/local/lib/node_modules/hipache/config/config_dev.json
sed -i "s|{{ SERVER_ACCESSLOG }}|${SERVER_ACCESSLOG}|g" $TEMPLATE
sed -i "s|{{ SERVER_WORKERS }}|${SERVER_WORKERS}|g" $TEMPLATE
sed -i "s|{{ SERVER_MAXSOCKETS }}|${SERVER_MAXSOCKETS}|g" $TEMPLATE
sed -i "s|{{ SERVER_DEADBACKENDTTL }}|${SERVER_DEADBACKENDTTL}|g" $TEMPLATE
sed -i "s|{{ SERVER_TCPTIMEOUT }}|${SERVER_TCPTIMEOUT}|g" $TEMPLATE
sed -i "s|{{ SERVER_RETRYONERROR }}|${SERVER_RETRYONERROR}|g" $TEMPLATE
sed -i "s|{{ SERVER_DEADBACKENDON500 }}|${SERVER_DEADBACKENDON500}|g" $TEMPLATE
sed -i "s|{{ SERVER_HTTPKEEPALIVE }}|${SERVER_HTTPKEEPALIVE}|g" $TEMPLATE
sed -i "s|{{ SERVER_LRUCACHE_SIZE }}|${SERVER_LRUCACHE_SIZE}|g" $TEMPLATE
sed -i "s|{{ SERVER_LRUCACHE_TTL }}|${SERVER_LRUCACHE_TTL}|g" $TEMPLATE
sed -i "s|{{ SERVER_PORT }}|${SERVER_PORT}|g" $TEMPLATE
sed -i "s|{{ SERVER_ADDRESS }}|${SERVER_ADDRESS}|g" $TEMPLATE
if [ ! -z "$REDIS_PORT_6379_TCP_ADDR" ]; then
	echo "Detected link to a redis container. Using as driver"
	if [ ! -z "$REDIS_ENV_REDIS_PASS" ]; then
		sed -i "s|{{ DRIVER }}|redis://:${REDIS_ENV_REDIS_PASS}@${REDIS_PORT_6379_TCP_ADDR}:${REDIS_PORT_6379_TCP_PORT:-6379}/${REDIS_DB:-0}|g" $TEMPLATE
	else
		sed -i "s|{{ DRIVER }}|redis://${REDIS_PORT_6379_TCP_ADDR}:${REDIS_PORT_6379_TCP_PORT:-6379}/${REDIS_DB:-0}|g" $TEMPLATE
	fi
else
	sed -i "s|{{ DRIVER }}|${DRIVER}|g" $TEMPLATE
fi
cp $TEMPLATE $CONFIGFILE

echo "Using configuration file:"
cat $CONFIGFILE
exec supervisord -n