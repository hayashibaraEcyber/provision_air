#!/bin/sh
#	set_iptables_vmJuntendoWeb.sh
#	iptables設定スクリプト for 順天堂公式Webサーバ
#
#	first written on: 2021/02/02	system@e-cyber.co.jp
#	last updated on:  2021/02/02	system@e-cyber.co.jp
#
WORKDIR=/root/bin
ETH0=eth0

IP_ECYBER=124.110.63.4
IP_JUNTENDO=202.21.163.142
IP_CMS_SERVER=153.120.134.67
IP_AIR_SERVER=133.242.51.69
IP_SAKURA_MONITOR=27.133.139.32/28

### 初期化
iptables -F
iptables -X

### デフォルトルール、すべて破棄
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

### IP偽装パケット（インタフェースへのプライベートIPアドレスからのアクセス）
### をすべて破棄
iptables -A INPUT -i $ETH0 -s 127.0.0.1 -j DROP
iptables -A INPUT -i $ETH0 -s 172.16.0.0/12 -j DROP
iptables -A INPUT -i $ETH0 -s 192.168.0.0/16 -j DROP
iptables -A INPUT -i $ETH0 -s 10.0.0.0/8 -j DROP

### ループバックインタフェースはすべて許可
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

### セッション確立後のアクセスは許可
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

### 内向きアクセスの許可
## TCP - HTTP, HTTPS を許可
iptables -A INPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT   # HTTP
iptables -A INPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT  # HTTPS

## TCP - SSH、SiteGuard管理画面(TCP/9443)は特定のIPアドレスからのみ許可
iptables -A INPUT -s ${IP_ECYBER} -m state --state NEW \
  -p tcp --dport 22 -j ACCEPT # SSH
iptables -A INPUT -s ${IP_JUNTENDO} -m state --state NEW \
  -p tcp --dport 22 -j ACCEPT # SSH
iptables -A INPUT -s ${IP_CMS_SERVER} -m state --state NEW \
  -p tcp --dport 22 -j ACCEPT # SSH
iptables -A INPUT -s ${IP_AIR_SERVER} -m state --state NEW \
  -p tcp --dport 22 -j ACCEPT # SSH
iptables -A INPUT -s ${IP_SAKURA_MONITOR} -m state --state NEW \
  -p tcp --dport 22 -j ACCEPT # SSH

iptables -A INPUT -s ${IP_ECYBER} -m state --state NEW \
  -p tcp --dport 9443 -j ACCEPT # SiteGuard Admin

## ICMP - pingやpingリクエストの戻りなど一部のみ許可
## 特定のIPアドレスからのみ許可
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
iptables -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
iptables -A INPUT -s ${IP_SAKURA_MONITOR} -p icmp --icmp-type echo-request -j ACCEPT

### 外向きアクセスの許可
## TCP - HTTP, HTTPS, DNS, SSH, FTP, NTP, SMTP, SMTPS, Submission, DNS, Whois, MySQLを許可
iptables -A OUTPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT   # HTTP
iptables -A OUTPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT  # HTTPS
iptables -A OUTPUT -m state --state NEW -p tcp --dport 53 -j ACCEPT   # DNS
iptables -A OUTPUT -m state --state NEW -p tcp --dport 43 -j ACCEPT   # WHOIS
iptables -A OUTPUT -m state --state NEW -p tcp --dport 22 -j ACCEPT   # SSH
iptables -A OUTPUT -m state --state NEW -p tcp --dport 20 -j ACCEPT   # FTP
iptables -A OUTPUT -m state --state NEW -p tcp --dport 21 -j ACCEPT   # FTP
iptables -A OUTPUT -m state --state NEW -p tcp --dport 25 -j ACCEPT   # SMTP
iptables -A OUTPUT -m state --state NEW -p tcp --dport 123 -j ACCEPT  # NTP
iptables -A OUTPUT -m state --state NEW -p tcp --dport 465 -j ACCEPT  # SMTPS
iptables -A OUTPUT -m state --state NEW -p tcp --dport 587 -j ACCEPT  # Submission
iptables -A OUTPUT -m state --state NEW -p tcp --dport 3306 -j ACCEPT # MySQL

## UDP - DNS, Whois, NTPを許可
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT   # DNS
iptables -A OUTPUT -p udp --dport 43 -j ACCEPT   # WHOIS
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT  # NTP

## ICMP - すべてを許可
iptables -A OUTPUT -p icmp -j ACCEPT

# EOF
