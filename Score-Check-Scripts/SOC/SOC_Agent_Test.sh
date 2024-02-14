#!/bin/bash

exit_code=0

# Check the status of every wazuh agent and if there are some that are disconnected, fail the check
status=$(/var/ossec/bin/agent_control -l | grep Disconnected)
    if [[ -n "$status" ]]; then
        echo "Machine is NOT healthy, some agents are not connected."
        exit_code=1
    else
        echo "Machine is secure and healthy, all agents connected"
        exit_code=0
    fi
exit $exit_code
