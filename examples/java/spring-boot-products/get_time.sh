#!/bin/bash
set -e
set -x
# [ "$TRACE" ] && set -x
#set -euxo pipefail

CONTAINER=KM_SpringBoot_Demo

until $(curl --output /tmp/output.txt --silent --fail http://localhost:8080/); do
   sleep 0.000001
done

end=$(date +%s%N)
start=$(date +%s%N -d $(ls --full-time start_time | awk -e '{print $7}'))
dur=$(expr $end - $start)
echo "Response time $(expr $dur / 1000000000).$(printf "%.03d" $(expr $dur % 1000000000 / 1000000)) secs"
cat  /tmp/output.txt
echo ""
