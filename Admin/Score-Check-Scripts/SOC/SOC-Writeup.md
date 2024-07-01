# SOC Score Check scripts


## Agent Test

One of the tests that we made for the SOC score checks was to see if any of the agents were disconnected. The way we are doing this is by using the agent_control command that built into Wazuh install. With this you can list all of the agents and there status. This means you can grep to see if there are any disconnected agents. If there are any results of the grep that means there is a disconnected agent somewhere and we fail the check, else there is no disconnected agents and we pass the check.

## API Test

This test will check if the Wazuh api is still set to the default password. The way we are doing this is by trying to curl the API with the default login credentials. If we get a invalid response, meaning we did not login, that means we pass the check because we have changed the login information making our machine more secure. If we do not get the invalid token that means we changed the password and we pass the check.

## Dashboard Test

This test is essentially the same check as above but we are doing the same process with the Wazuh dashboard. Also we check if we login with the credentials that mean the check failed and if it does not connect we pass.