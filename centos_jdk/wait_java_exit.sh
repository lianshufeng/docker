#!/bin/bash
items=(${$(pgrep java)//\n/})
for pid in ${items[@]}
do
	tail --pid=$pid -f /dev/null
done