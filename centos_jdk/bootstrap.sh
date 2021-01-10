#!/bin/bash
set -e
source /etc/profile
source /etc/locale.conf
export LANG=zh_CN.utf8

# execute command line
if [ -n "$1" ] ;then
	cmd="$*"
	$cmd
fi
