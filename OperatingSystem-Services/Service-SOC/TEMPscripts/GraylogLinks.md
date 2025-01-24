# Graylog Links Sheet #
WHAT THIS IS:  
Small list of links for helpful Graylog resources/integrations...

### Graylog Proxy + NGINX ###
- Setting up with load balancer/proxy: https://go2docs.graylog.org/5-0/setting_up_graylog/web_interface.htm#nginx

- Nginx extractor + content pack: https://github.com/scriptingislife/graylog-content-pack-nginx-syslog

### Graylog Pan-OS (Palo Alto) Extractor ###
- https://github.com/jamesfed/PANOSGraylogExtractor

- Untested content pack for pan-OS (OLD?) https://github.com/ddbnl/Graylog-PAN-Content-Pack

- Content pack super old (6.x pan ver) https://github.com/reighnman/Graylog_Content_Pack_PaloAltoNetworks

### K8's logging to Graylog ###
This should use either filebeat or fluentbit(this one easier??)

- Untested old sample config of fluentbit: https://github.com/vincent-zurczak/fluentbit-configuration-for-k8s-and-graylog

- Sketchy blog on installing fluentbit for Gray: https://www.xtivia.com/blog/k8s-loggings-graylog-fluent-bit/

- Medium blog on fluentbit and Gray (better..?): https://blog.stackademic.com/centralize-logs-kubernetes-cluster-in-to-graylog-server-with-fluent-bit-log-collector-26c22e1b21f1

### Graylog Prometheus Grafana ###
- Official docs, sending Gray metrics->Prometheus: https://go2docs.graylog.org/current/interacting_with_your_log_data/metrics.html?tocpath=Set%20up%20Graylog%7C_____4

- https://the-pi-guy.com/blog/integrating_graylog_with_popular_monitoring_tools_for_comprehensive_observability/

### AWS with Graylog Integration ###
- Semi confusing guide: https://graylog.org/post/ingesting-cloudtrail-logs-with-the-graylog-aws-plugin/

- Official docs: https://go2docs.graylog.org/current/getting_in_log_data/aws_cloudtrail_input.htm

### Securing HTTPS + TLS ###
- Easy TLS for inputs: https://go2docs.graylog.org/current/getting_in_log_data/secure_inputs_with_tls.htm?tocpath=Get%20in%20Logs%7C_____2

- HTTPS official docs: https://go2docs.graylog.org/current/setting_up_graylog/https.html?tocpath=Set%20up%20Graylog%7CSecure%20Graylog%7C_____2



