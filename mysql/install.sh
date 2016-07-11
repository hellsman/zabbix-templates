#!/usr/bin/env bash
# Скрипт инсталяции скриптов и файлов-конфигурации мониторинга MySQL в Zabbix
#
# author: Alexey Shulik
# e-mail: me@hellsman.ru
# date: 10.08.2015



# Запрашиваем данные для подключения к MySQL
echo "Введите имя пользователя для подлкючения к MySQL, н.р. zabbix:"
read DBUser
echo "Введите пароль пользователя для подключения к MySQL:"
read DBPassword

# Создаем папку, где будут располагаться скрпиты
mkdir -p /usr/share/zabbix-agent/scripts/
chown -R zabbix:zabbix /usr/share/zabbix-agent/

# Создаем файл конфигурации скрипта
echo "DBUser=$DBUser" > /usr/share/zabbix-agent/scripts/mysql_zabbix.conf
echo "DBPassword=$DBPassword" >> /usr/share/zabbix-agent/scripts/mysql_zabbix.conf

# Создаем конфигурацию для Zabbix Agent
cp conf/mysql.conf `cat /etc/zabbix/zabbix_agentd.conf | grep -v "#" | grep Include| awk -F"/" '{print "/"$2"/"$3"/"$4}'`

# Переносим исполняемый скрпит
cp scripts/mysql_zabbix.sh /usr/share/zabbix-agent/scripts/
chown -R zabbix:zabbix /usr/share/zabbix-agent/scripts
chmod +x /usr/share/zabbix-agent/scripts/mysql_zabbix.sh

# Перезапускаем Zabbix Agent
service zabbix-agent restart
echo "Установка закончена"
