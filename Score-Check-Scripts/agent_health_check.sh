#!/bin/bash

exit_code=0

status=$(/var/ossec/bin/agent_control -l | grep Disconnected)
    if [[ -n "$status" ]]; then
        echo "Machine is NOT healthy, some agents are not connected."
        exit_code=1
    else
        echo "Machine is secure and healthy, all agents connected"
        exit_code=0
    fi
exit $exit_code