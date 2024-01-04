# Write-up: Blue Team (SIEM)

## Overview
Name: `Joan Montas`

### What We Worked On:
- Installed Wazuh from scratch following a catastrophic failure prior to commencement.
- Configured and set up agents (due to Manager server IP changes).
- Implemented VirusTotal integration.
- Observed and reported vulnerabilities.

### Challenges Faced:
- Changing passwords while the system is bug is not recommended.
- Priority should be given to eliminating vulnerabilities before addressing password setups.
- Creating a checklist/TODO after installing Wazuh from scratch to avoid overlooking default password changes.
- Coordination with the network team before modifying layouts is crucial for synchronized actions.
  - For instance, consider automating the Wazuh-agent to update its manager's password.

### Future Plans:
- Development of a custom dashboard to monitor user accounts per machine and track agent creation for identifying persistent threats.
- Implementation of file integrity checks in the `.bashrc` to mitigate common surface attack vectors.
- Account for open shells and report suspicious activities.
  - Establish team awareness and procedures for timely and appropriate responses.
- Enhanced team communication: Formalize verbal and written communication methods between SOC and other teams for better coordination.
- Active response strategies: Finalize VirusTotal integration or explore free-open-source alternatives.
  - Implement an active response protocol for suspicious processes to save time and act swiftly.
- Exploration of password changing scripts using Docker secret or .env files to obfuscate passwords.

