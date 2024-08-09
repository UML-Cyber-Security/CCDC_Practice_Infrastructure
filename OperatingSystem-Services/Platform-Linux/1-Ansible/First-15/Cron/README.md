# Cron
This script allows us to create or remote a `cron/at.allow` file which can restrict the users allowed to run cronjobs. This is created as an empty file so no one would be allowed to run cronjobs.

* `allow_state`: This can be set to any valid ansible state. The Default is `touch` which creates the file if it does not exist. You can change this to `absent` to remove the files.