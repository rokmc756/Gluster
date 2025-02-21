
# lsblk
# iscsi_lun_id=36001405164eaab4e01742179e97855a3
iscsi_lun_id=$1

for sub_lun_ids in `lsblk | grep -A7 $iscsi_lun_id | sed 1d | awk '{print $1}' | sed -e 's/^[├─|└─]//g' | sed -e 's/^─//g'`
do

        dmsetup -v remove $sub_lun_ids

done

dmsetup -v remove $iscsi_lun_id

