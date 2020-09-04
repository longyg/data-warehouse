#!/bin/bash

##################################
#
#  Configure proxy for Ubuntu
#
##################################

# provide proxy address if any
# http://<ip>:<port>/
PROXY_HOST=$1
NO_PROXY_HOST="localhost,127.0.0.0/8"

echo "##################################################"
echo "Configuring proxy..."
echo "##################################################"
cat <<EOF >/etc/apt/apt.conf
Acquire::http::Proxy "$PROXY_HOST";
EOF
if [ `grep -c "export http_proxy=" /etc/profile` -eq 1 ];then
	echo "Proxy is already configured in /etc/profile"
else
	echo "export http_proxy=$PROXY_HOST" >> /etc/profile
	echo "export https_proxy=$PROXY_HOST" >> /etc/profile
	echo "export no_proxy=$NO_PROXY_HOST" >> /etc/profile
	source /etc/profile
fi
echo "Proxy is configured successfully"
echo ""
echo ""