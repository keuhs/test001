#!/bin/bash                                                                                                                                                                │
                                                                                                                                                                           │
# Specify the Redis command to execute                                                                                                                                     │
REDIS_CMD="CLIENT LIST"                                                                                                                                                    │
                                                                                                                                                                           │
# Specify the path to the file containing the Redis hostnames                                                                                                              │
REDIS_HOSTS_FILE="redis_hosts.txt"                                                                                                                                         │
                                                                                                                                                                           │
if [ $# -ne 1 ]; then                                                                                                                                                      │
    echo "Usage: ./check_redis_hosts.sh [HOSTS_FILE]"                                                                                                                      │
    exit $E_WRONGARGS                                                                                                                                                      │
fi                                                                                                                                                                         │
                                                                                                                                                                           │
if [ -f "$1" ]; then                                                                                                                                                       │
    REDIS_HOSTS_FILE=$1                                                                                                                                                    │
else                                                                                                                                                                       │
    echo "check_redis_hosts.sh: cannot stat '$1': No such file or directory"                                                                                               │
    exit $E_NOFILE                                                                                                                                                         │
fi                                                                                                                                                                         │
                                                                                                                                                                           │
# Loop through each Redis hostname in the file                                                                                                                             │
while read -r REDIS_HOST;                                                                                                                                                  │
do                                                                                                                                                                         │
    # Connect to the Redis host and execute the command                                                                                                                    │
    echo $REDIS_HOST                                                                                                                                                       │
    redis-cli -h $REDIS_HOST $REDIS_CMD | awk '{ print $2 }' | sed 's/.....//' | sed 's/......$//' | sort | uniq -c;                                                       │
done < "$REDIS_HOSTS_FILE"                                                                                                                                                 │
                                                                                                                                                                           │
exit 0
