#!/bin/bash
jps=$(pgrep java)
items=(${jps//\n/})
for pid in ${items[@]}
do
 tail --pid=$pid -f /dev/null
done