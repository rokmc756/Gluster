
net_range="192.168.2"
root_pass="changeme"
sshpass -p "$root_pass" ssh -o StrictHostKeyChecking=no root@$net_range.$1 $2

