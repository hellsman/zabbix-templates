#!/usr/bin/env bash
#
# author: Alexey Shulik
# e-mail: me@hellsman.ru
# date: 10.08.2015
#
#


DBUser=$(cat /usr/share/zabbix-agent/scripts/mysql_zabbix.conf | grep DBUser | cut -f2 -d"=")
DBPassword=$(cat /usr/share/zabbix-agent/scripts/mysql_zabbix.conf | grep DBPassword | cut -f2 -d"=")
MYSQLADMIN="/usr/bin/mysqladmin -u$DBUser -p$DBPassword"
MYSQL=/usr/bin/mysql
case "$1" in
    ping) #Проверка доступности и активности mysql-сервера
        ${MYSQLADMIN} ping|grep alive|wc -l
        ;;
    version) #проверка версии MySQL
        ${MYSQL} -V
        ;;
    bytes_received) # Кол-во принятных байт
        ${MYSQLADMIN} extended-status | grep -iw "Bytes_received" | awk '{print $4}'
        ;;
    bytes_sent) # Кол-во отправленных байт
        ${MYSQLADMIN} extended-status | grep -iw "Bytes_sent" | awk '{print $4}'
        ;;
    uptime) # время работы в секундах
		${MYSQLADMIN} stat | cut -f2 -d" "
	    ;;
    threads) #потоки
	    case "$2" in
		    created)
			    ${MYSQLADMIN} extended-status | grep -iw "Threads_created" | awk '{print $4}'
			    ;;
		    cached)
			    ${MYSQLADMIN} extended-status | grep -iw "Threads_cached" | awk '{print $4}'
    			;;
	    	connected)
                ${MYSQLADMIN} extended-status | grep -iw "Threads_connected" | awk '{print $4}'
		    	;;
		    running)
			    ${MYSQLADMIN} extended-status | grep -iw "Threads_running" | awk '{print $4}'
			    ;;
	    esac
	    ;;
    queries)
        case "$2" in
            update) # Кол-во запросов UPDATE
                ${MYSQLADMIN} extended-status | grep -iw "Com_update"| awk '{print $4}'
            ;;
            insert) # Кол-во запросов INSERT
                ${MYSQLADMIN} extended-status | grep -iw "Com_insert"| awk '{print $4}'
            ;;
            select) # Кол-во запросов SELECT
                ${MYSQLADMIN} extended-status | grep -iw "Com_select" | awk '{print $4}'
            ;;
        esac
    ;;
    *)
        echo "No Parameter"
        exit 1
    ;;

esac

exit 0