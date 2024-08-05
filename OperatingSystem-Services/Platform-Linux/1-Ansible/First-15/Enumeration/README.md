# Enumeration

This directory will contain playbooks used to enumerate and gather information from each of the target machines. We use this to quickly run commands on each of the target systems, and centralize the information in files so we can quickly examine it.

* Linpeas: Privilege Escalation, keep note of simpler things like generous file permissions and s-bit binaries.

## Linpeas
This playbook runs the linpeas enumeration script on each of the target systems, saves the output to a file and transfers it to the machine running the ansible script. It then removes the linpeas script and output from the remote machines.

> [!NOTE]
> The file contains alot of binary and coloring data. You can use the provided parsers to convert them. A future goal is to have the ansible script run these locally for us (or externally, whichever works).
>
> python3 peas2json.py </path/to/executed_peass.out> </path/to/peass.json>
> python3 json2pdf.py </path/to/peass.json> </path/to/peass.pdf>