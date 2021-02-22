#!/bin/sh

## -----------------------------------------------
SCAN_DIR=/
LOG="/var/log/clamdscan_result.log"
LOG_LATEST="/var/log/clamdscan_result.log.latest"
FROM=ClamAV@`hostname`
TO=root
## -----------------------------------------------



#-----------------------------
# virus database update

freshclam --quiet


#-----------------------------
# update clamd

yum -y update clamd > /dev/null 2>&1
yum -y update clamav-db > /dev/null 2>&1

#-----------------------------
# restart clamd (release memory)

systemctl restart clamd@scan > /dev/null

#-----------------------------
# scan

/usr/bin/clamdscan -c /etc/clamd.d/scan.conf --infected  --log=$LOG $SCAN_DIR > $LOG_LATEST

#-----------------------------
# send email if virus is found

cat $LOG_LATEST | grep 'FOUND' > /dev/null
if [ "$?" -eq 0 ]
then
  {
    echo "From: $FROM"
    echo "To: $TO"
    echo "Subject: [SERVER] Virus Found in `hostname`"
    echo
    echo "Virus Found in `hostname`"
    echo
    cat $LOG
  } | /usr/sbin/sendmail -f $FROM $TO

fi
