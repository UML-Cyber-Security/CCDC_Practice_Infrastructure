#!/bin/bash
# Script sets up Nginx logging to Graylog 
# Should work for all Linux system (NOT TESTED FOR RHEL)
# Logging set up as syslog input (:5140)

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

echo -e "\n-----------------------------------------"
echo -e "\n-----------------------------------------\nSetting up Nginx Logging through rsyslog port: 5140...\n"

if [[ -e "/etc/nginx/nginx.conf" ]]; then
  read -p "Enter GRAYLOG manager machine IP (e.g., 192.168.1.123): " manager_ip
else
  echo "ERROR: No /etc/nginx/nginx.conf file found..."
  exit 1
fi

if grep -q "# Logging Settings" /etc/nginx/nginx.conf; then
  # Insert the log configuration below "# Logging Settings"
  sed -i "/# Logging Settings/a \\
        log_format graylog_json escape=json '{ \"nginx_timestamp\": \"\$time_iso8601\", \\
        \"remote_addr\": \"\$remote_addr\", \\
        \"connection\": \"\$connection\", \\
        \"connection_requests\": \$connection_requests, \\
        \"pipe\": \"\$pipe\", \\
        \"body_bytes_sent\": \$body_bytes_sent, \\
        \"request_length\": \$request_length, \\
        \"request_time\": \$request_time, \\
        \"response_status\": \$status, \\
        \"request\": \"\$request\", \\
        \"request_method\": \"\$request_method\", \\
        \"host\": \"\$host\", \\
        \"upstream_cache_status\": \"\$upstream_cache_status\", \\
        \"upstream_addr\": \"\$upstream_addr\", \\
        \"http_x_forwarded_for\": \"\$http_x_forwarded_for\", \\
        \"http_referrer\": \"\$http_referer\", \\
        \"http_user_agent\": \"\$http_user_agent\", \\
        \"http_version\": \"\$server_protocol\", \\
        \"remote_user\": \"\$remote_user\", \\
        \"http_x_forwarded_proto\": \"\$http_x_forwarded_proto\", \\
        \"upstream_response_time\": \"\$upstream_response_time\", \\
        \"nginx_access\": true }'; \\
        access_log syslog:server=${manager_ip}:5140 graylog_json; \\
        access_log /var/log/nginx/access.log; \\
        error_log /var/log/nginx/error.log;" /etc/nginx/nginx.conf
else
  echo "ERROR: # Logging Settings section not found in /etc/nginx/nginx.conf. Please add the logging manually."
  exit 1
fi

systemctl restart nginx

echo -e "\n-----------------------------------------\nConfiguration most likely added successfully\n"