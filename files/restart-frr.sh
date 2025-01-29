#!/bin/sh
# Delayed start script to tell frr to reload ensuring that it sees thunderbolt links towards other nodes.
# condition: is there any tbt network interface and frr service up
COUNTER=0
while [ ${COUNTER} -lt 5 ]; do
        sleep 1;
        TEST=$(ip a | grep ": eno" | grep "UP" | awk 'BEGIN { ORS=""}; {print $2}')
        if [ ${#TEST} -ge 2 ]; then
                TEST_SVC=$(service frr status | grep "active (running)")
                if [ ${#TEST_SVC} -ge 2 ]; then
                        service frr reload;
                        echo "frr service reload request sent"
                        exit 0;
                fi
        fi
        COUNTER=$((COUNTER+1));
done
echo "Failed to request frr service reload: request NOT sent"
exit 1;
