# What are they
Cron is a command line utility and system process that we can use to schedule recurring jobs.

Each user will have their own crontab that is going to located in the **/var/spool/cron/...** directory. We can create a cron.allow list to whitelist users that will be able to schedule jobs.

The format of the crontab is as follows:

```sh
# Use the hash sign to prefix a comment
# +---------------- minute (0 - 59)
# |  +------------- hour (0 - 23)
# |  |  +---------- day of month (1 - 31)
# |  |  |  +------- month (1 - 12)
# |  |  |  |  +---- day of week (0 - 7) (Sunday=0 or 7)
# |  |  |  |  |
# *  *  *  *  *  command to be executed
#--------------------------------------------------------------------------

# Run my cron job every Monday to Friday hourly from 9:30am
30 9 * * 1,2,3,4,5 cron-data.js
```

Possible values:
>\* : Any value
>\- : Specifies a range of values e.x. 1-12 is between 1-12 units
>, : Can be used to define a comma separated list of accepted values e.x. 1,2,5 1,2 and 5 will be accepted
>L : Used to specify Last e.x. 3L specifies 3 from the last possible value (Used in Day/Week and Month felid)
>/ : Used to define a divisible value, */10 can be every 10 minuets hours ect
>  Others are a bit specific for a short thing

Special Strings 
>@reboot : Run once the system has rebooted
>@hourly : Run every hour

# Ref
**Cron:**
* https://www.hostinger.com/tutorials/cron-job
* https://www.ibm.com/docs/en/db2oc?topic=task-unix-cron-format
* 