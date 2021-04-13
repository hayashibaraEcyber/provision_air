#!/bin/sh
#       pkg_update.sh
#       packageの更新を行うスクリプト(C_AIR_CMS-503)
#
#       first written on: 2021/03/15    system@e-cyber.co.jp
#       last updated on:  2021/03/15    system@e-cyber.co.jp
#
PATH=/usr/bin:/bin

logger "[Info] yum update Start"

# if today is Wednesday:3 then yum update
if [ $(date "+%w") -eq 3 ]; then
  yum -y update
else
  logger "[Info] Today is not the taget date"
fi

logger "[Info] yum update Finish"
# EOF
