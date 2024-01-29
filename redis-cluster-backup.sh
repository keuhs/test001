#!/bin/sh

readonly cluster_topology=$(redis-cli -h onstove-dev-megapi.6ysgjy.clustercfg.apne1.cache.amazonaws.com cluster nodes)
readonly slaves=$(echo "${cluster_topology}" | grep slave | cut -d' ' -f2,4 | tr ' ' ',')

#readonly backup_dir="/opt/redis-backup"
readonly backup_dir="/mnt/d/workspaces/test"
mkdir -p ${backup_dir}

for slave in ${slaves}; do
    master_id=$(echo "${slave}" | cut -d',' -f2)
    slave_ip=$(echo "${slave}" | cut -d':' -f1)
    slots=$(echo "${cluster_topology}" | grep "${master_id}" | grep "master" | cut -d' ' -f9)

    if [ -z "$slave_ip" ] || [ -z "$slots" ]; then
        echo "Can not find redis slave or slots in topology:\n${cluster_topology}\n"
        exit 1
    fi

    # Get last dump.rdb
    redis-cli --rdb dump.rdb -h ${slave_ip}

    # Check rdb file for consistency
    rdb_check=$(redis-check-rdb dump.rdb)
    echo ${rdb_check} | grep "Checksum OK" | grep "RDB looks OK!"

    # If rdb is consistent, compress it and move to backup directory. Fail otherwise.
    if [ $? -eq 0 ]; then
        backup_file=dump-${slots}-$(date '+%Y-%m-%d-%H%M').rdb.gz
        gzip dump.rdb
        mv dump.rdb.gz ${backup_dir}/${backup_file}
    else
        failed_dump=dump-failed-${slots}-$(date '+%Y-%m-%d-%H%M').rdb
        echo "RDB check failed!"
        mv dump.rdb ${backup_dir}/${failed_dump}
    fi
done

# Cleanup backups older than 5 days
find ${backup_dir} -mindepth 1 -mtime +5 -delete
