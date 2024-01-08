#!/bin/sh

if [ $# -ne 2 ]; then
	echo "Usage: $0 <client_config_dir> <ca_cert_file>"
	exit 1
fi

config_dir=$1
ca_cert_file=$2

# create a symlinked file of the ca cert named as ${hash}.0... not
# sure why, but this is what the documentation mentions.
ca_cert_hash=$(openssl x509 -noout -hash -in $ca_cert_file)
cd $(dirname $ca_cert_file) && \
	ln -s $(basename $ca_cert_file) $ca_cert_hash.0

# build and run the container now. make sure to mount any directories
# from the host that are required for logging purposes. mount them as
# readonly as a safeguard that they are not unintentionally modified.
cd -
docker build -t syslog-client --build-arg CONFIG_DIR=$config_dir .

docker run -d \
	--name syslog-client \
	-v /var/log:/var/log:ro \
	syslog-client
