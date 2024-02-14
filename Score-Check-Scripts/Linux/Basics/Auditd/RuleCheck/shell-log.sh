#!/bin/bash

auditout=$(auditctl -l)

if (( $(echo $auditout | grep -i "/bin/csh"| wc -l ) == 0 )); then
    echo "You should consider auditing the use of shell processes such as csh"
    exit 1
elif (( $(echo $auditout | grep -i "/bin/ash"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of shell processes such as ash"
    exit 1
elif (( $(echo $auditout | grep -i "/bin/fish"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of shell processes such as fish"
    exit 1
elif (( $(echo $auditout | grep -i "/bin/tcsh"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of shell processes such as tcsh"
    exit 1
elif (( $(echo $auditout | grep -i "/bin/tclsh"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of shell processes such as tclsh"
    exit 1
elif (( $(echo $auditout | grep -i "/bin/xonsh"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of shell processes such as xonsh"
    exit 1
elif (( $(echo $auditout | grep -i "/usr/local/bin/xonsh"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of shell processes such as /usr/local/bin/xonsh"
    exit 1
elif (( $(echo $auditout | grep -i "/bin/open"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of shell processes such as open"
    exit 1
elif (( $(echo $auditout | grep -i "/bin/rbash"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of shell processes such as rbash"
    exit 1
elif (( $(echo $auditout | grep -i "/bin/bash"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of shell processes such as bash"
    exit 1
elif (( $(echo $auditout | grep -i "/bin/sh"| wc -l ) == 0  )); then 
    echo "You should consider auditing the use of shell processes such as sh"
    exit 1
fi
exit 0
