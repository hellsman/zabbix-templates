#!/bin/bash
HOST=$(cat /usr/share/zabbix-agent/scripts/memcached.conf | grep HOST | cut -f2 -d"=")
PORT=$(cat /usr/share/zabbix-agent/scripts/memcached.conf | grep PORT | cut -f2 -d"=")
echo -e "stats\nquit" | nc $HOST $PORT | grep "STAT $1 " | awk '{print $3}'
