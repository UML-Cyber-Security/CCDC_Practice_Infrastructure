## Introduction
The hope of this document is to provide two very possible vulnerability that SOC can encounter using Wazuh.
A description and mitigation will be provided for each.
Apart from vulnerabilities, it will showcase two very possible Inject.
Predicting possible inject is good practice to keep ahead (possibly) of the competition.

# Wazuh Common Vulnerability And Injects

## Introduction
The hope of this document is to provide two very possible vulnerability that SOC can encounter using Wazuh.
A description and mitigation will be provided for each.
Apart from vulnerabilities, it will showcase two very possible Inject.
Predicting possible inject is good practice to keep ahead (possibly) of the competition.

##  Securing Wazuh API Vulnerability

### Description
Having a fairly new infrastructure it is given that there are rough edges to be found.
At first, we focus on Dashboard creation and agent deployments.
The Dashboard, is usually protected by limiting its acces such as changing default password to its user.
One thing not often considered is the Rich and Robust API that Wazuh provides.
The API can perform to a even greater extend all of the dashboard capabilities.
It is of paramount importance to secure this API.


### Mitigation
One way to fix it is via password changing
#### steps
  1) cd path/wazuh-docker/single-node
  2) docker run --rm -ti wazuh/wazuh-indexer:4.6.0 bash /usr/share/wazuh-indexer/plugins/opensearch-security/tools/hash.sh
  3) input password: SuperSecurePassword!
  4) copy hash: $2y$12$1VK45Hem7D.FTnB7tiaiH.Jd0hy0XD34Hjehrac/3kntZBr.pOP4a
  5) cd path/wazuh-docker/single-node/config/wazuh_indexer
  6) vim internal_users.yml
  7) replace username hash
  8) cd .. and vim docker-compose.yml
  9) replace password with the password for the desired username
  10) docker-compose up -d
  11) docker exec -it single-node-wazuh.indexer-1 bash
  12) copy the following variables:
    export INSTALLATION_DIR=/usr/share/wazuh-indexer
    CACERT=$INSTALLATION_DIR/certs/root-ca.pem
    KEY=$INSTALLATION_DIR/certs/admin-key.pem
    CERT=$INSTALLATION_DIR/certs/admin.pem
    export JAVA_HOME=/usr/share/wazuh-indexer/jdk
  13) run bash /usr/share/wazuh-indexer/plugins/opensearch-security/tools/securityadmin.sh -cd /usr/share/wazuh-indexer/opensearch-security/ -nhnv -cacert  $CACERT -cert $CERT -key $KEY -p 9200 -icl

If is too many step  it can automatically be done with a python script or an ansible playbook.
Here is an unstested python script:
```python
# Copyright Joan Montas
# All rights reserved.
# License under GNU General Public License v3.0

import subprocess
import json
import yaml
from ruamel.yaml import YAML
import json

# Mind the order
yaml = YAML()

DOCKERID = "wazuh/wazuh-indexer:4.6.0"

# 1) Documents/wazuh-docker/single-node
USERANDNEWPASSWORD = {"admin":["mysecurePass"], 
                       "kibanaserver":["MyOtherSecurePass"]}

path = "/home/user/wazuh-docker/single-node"


def getHash(dockerId, password):
    # 2) docker run --rm -ti wazuh/wazuh-indexer:4.6.0 bash /usr/share/wazuh-indexer/plugins/opensearch-security/tools/hash.sh
    # 3) input password: SuperSecurePassword!

    output = subprocess.check_output(f"docker run --rm -ti {dockerId} bash /usr/share/wazuh-indexer/plugins/opensearch-security/tools/hash.sh -p {password}", shell=True)
    outputPrime = output.decode()
    outputPrime = outputPrime.split('\r\n')
    hashValue = outputPrime[-2]
    return hashValue

# 4) copy hash: $2y$12$1VK45Hem7D.FTnB7tiaiH.Jd0hy0XD34Hjehrac/3kntZBr.pOP4a
# 5) cd wazuh-docker/single-node/config/wazuh_indexer
indexerPath = path + "/config/wazuh_indexer"


indexerInternalUser = indexerPath + "internal_users.yml"
for userId_ in USERANDNEWPASSWORD.keys():
    userPass_ = USERANDNEWPASSWORD[userId_][0]
    newHash_ = getHash(DOCKERID, userPass_)
    USERANDNEWPASSWORD[userId_].append(newHash_)

# 6) vim internal_users.yml
with open(indexerInternalUser, 'r') as yaml_file:
    yaml_content = yaml.load(yaml_file)

# convert to json
json_content = [{"key": key, "value": value} for key, value in yaml_content.items()]


# 7) replace admin hash or which ever user being modified
for i in range(1, len(json_content)):
    userId_ = json_content[i]["key"]
    if not userId_ in USERANDNEWPASSWORD.keys():
        continue
    json_content[i]["value"]["hash"] = USERANDNEWPASSWORD[userId_][1]

# Convert the list to JSON
#json_content = json.dumps(json_content, indent=2)
yaml_content = {item["key"]: item["value"] for item in json_content}

# Write YAML to file
with open(indexerInternalUser, 'w') as yaml_file:
    yaml.dump(yaml_content, yaml_file)

# 8) go back and vim docker-compose.yml
dockerComposePath = path + "docker-compose.yml"
with open(dockerComposePath, 'r') as yaml_file:
    yaml_content = yaml.load(yaml_file)

# convert to json
json_content = [{"key": key, "value": value} for key, value in yaml_content.items()]

# TODO(JoanMontas) error check if it even exist
managerEnvironment = json_content[1]["value"]["wazuh.manager"]["environment"]
for i in range(0, len(managerEnvironment)):
    splittedId = managerEnvironment[i].split("=")
    # TODO(JoanMontas) check if out of range
    if splittedId[0] != "INDEXER_USERNAME" and splittedId[0] != "DASHBOARD_USERNAME" and splittedId[0] != "API_USERNAME":
        continue
    if splittedId[1] not in USERANDNEWPASSWORD.keys():
        continue
    if i+1 >= len(managerEnvironment):
        continue
    splittedPass = managerEnvironment[i+1].split("=")
    # TODO(JoanMontas) check for error
    if (splittedPass[0] != "INDEXER_PASSWORD" and splittedPass[0] != "DASHBOARD_PASSWORD" and splittedPass[0] != "API_PASSWORD"):
        # TODO(JoanMontas) write error message that the file is not well formatted
        continue
    managerEnvironment[i+1] = splittedPass[0] + "=" + USERANDNEWPASSWORD[splittedId[1]][1]
json_content[1]["value"]["wazuh.manager"]["environment"] = managerEnvironment
            
dashboardEnvironment = json_content[1]["value"]["wazuh.dashboard"]["environment"]
for i in range(0, len(dashboardEnvironment)):
    splittedId = dashboardEnvironment[i].split("=")
    # TODO(JoanMontas) check if out of range
    if splittedId[0] != "INDEXER_USERNAME" and splittedId[0] != "DASHBOARD_USERNAME" and splittedId[0] != "API_USERNAME":
        continue
    if splittedId[1] not in USERANDNEWPASSWORD.keys():
        continue
    if i+1 >= len(dashboardEnvironment):
        continue
    splittedPass = dashboardEnvironment[i+1].split("=")
    # TODO(JoanMontas) check for error
    if (splittedPass[0] != "INDEXER_PASSWORD" and splittedPass[0] != "DASHBOARD_PASSWORD" and splittedPass[0] != "API_PASSWORD"):
        # TODO(JoanMontas) write error message that the file is not well formatted
        continue
    dashboardEnvironment[i+1] = splittedPass[0] + "=" + USERANDNEWPASSWORD[splittedId[1]][1]
json_content[1]["value"]["wazuh.dashboard"]["environment"] = dashboardEnvironment

yaml_content = {item["key"]: item["value"] for item in json_content}
# Write YAML to file
with open(dockerComposePath, 'w') as yaml_file:
    yaml.dump(yaml_content, yaml_file)
```


## Securing Wazuh Configuration Vulnerability II

### Description
Wazuh Configuration Files are vital for its function.
Both agents and Server (and all its components) orchestrate their processes around them.
Special care must be taken to insure its integrity.
One possible scenario would deleting the local vulnerabilty database (cve.db) at
```bash
    foo@bar:/var/ossec/queue/vulnerabilities$
```
Then preventing the gathering of vulnerability by increasing the "update_interval" of the Vulnerability sources. This can be foundd in ossec.conf at
```bash
    foo@bar:/var/ossec/etc/$
```

### Mitigation
#### File Integrity Monitoring
Due to the sensitive nature of this file, close attention must be placed to them.
1. Minimize access to those file. Setup rule to who can edit or access
2. Save backup
3. Dashboard to notify Wazuh Manager status (restart with timestamp)
4. Setup some sort of file integrity and notify changes via Dashboard or other form of messaging