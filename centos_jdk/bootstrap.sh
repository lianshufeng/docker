#!/bin/bash
set -e
source /etc/profile
source /etc/locale.conf
export LANG=zh_CN.utf8

# execute command line
if [ -n "$1" ] ;then
	cmd="$1 $2 $3 $4 $5 $7 $8 $9"
	$cmd
fi
