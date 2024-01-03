# Restart the ssh service
service ssh restart

# Start the cronjob
/usr/sbin/cron -f

# Command to keep the container alive.
tail -f /dev/null
