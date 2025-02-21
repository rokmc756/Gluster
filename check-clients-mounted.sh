for i in `seq 4 4`
do

    ssh root@192.168.2.17$i "mount -l | grep -E 'nfs|smb|ceph|iscsi|glusterfs'"

done

# for i in `find ./ -name "*2023-03-21*.csv"`; do grep --with-filename -E 'FATAL\:|ERROR\:' $i; done

