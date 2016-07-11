#!/usr/bin/env bash
# Скрипт инсталяции скриптов и файлов-конфигурации мониторинга MySQL в Zabbix
#
# author: Alexey Shulik
# e-mail: me@hellsman.ru
# date: 10.08.2015



# Запрашиваем данные для подключения к MySQL
echo "Введите IP или имя хоста, где запущен Memcached, н.р. 127.0.0.1:"
read HOST
echo "Введите порт подключения к Memcached, н.р. 11211:"
read PORT

# Создаем папку, где будут располагаться скрпиты
mkdir -p /usr/share/zabbix-agent/scripts/
chown -R zabbix:zabbix /usr/share/zabbix-agent/

# Создаем файл конфигурации скрипта
echo "HOST=$HOST" > /usr/share/zabbix-agent/scripts/memcached.conf
echo "PORT=$PORT" >> /usr/share/zabbix-agent/scripts/memcached.conf

# Создаем конфигурацию для Zabbix Agent
cp conf/memcached.conf `cat /etc/zabbix/zabbix_agentd.conf | grep -v "#" | grep Include| awk -F"/" '{print "/"$2"/"$3"/"$4}'`

# Переносим исполняемый скрпит
cp scripts/memcached.sh /usr/share/zabbix-agent/scripts/
chown -R zabbix:zabbix /usr/share/zabbix-agent/scripts
chmod +x /usr/share/zabbix-agent/scripts/memcached.sh

# Перезапускаем Zabbix Agent
service zabbix-agent restart
echo "Установка закончена"
