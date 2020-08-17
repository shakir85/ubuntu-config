awk -F':' '/ftponly/{print $4}' /etc/group
# list all members of sudo group
awk -F':' '/sudo/{print $4}' /etc/group
# without awk
getent group GROUP_NAME
