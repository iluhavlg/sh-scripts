#!/bin/bash
ALL_NODES_LIST=servers.txt
cat << EOF > $ALL_NODES_LIST
10.10.13.20
10.10.13.21
10.10.13.22
10.10.13.23
10.10.13.30
EOF
# Генерим ssh ключ если его нет
cat /dev/zero | ssh-keygen -q -N ""
# Цикл по всем серверам
for ip in `cat $ALL_NODES_LIST`; do
    ssh-copy-id -i ~/.ssh/id_rsa.pub $ip
done
