﻿#!/bin/sh
#	clear_iptables.sh
#	iptablesの初期化を行うスクリプト
#
#	first written on: 2015/11/10	ina128@inaba-serverdesign.jp
#	last updated on:  2015/11/10	ina128@inaba-serverdesign.jp
#
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -X
iptables -F

# EOF
