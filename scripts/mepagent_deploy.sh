#!/bin/bash

echo "MEP_IP should set be the host ip!"

set +o history
# initial variables
set +x
source scripts/mep_vars.sh
set -x

cp -r mepagent-conf /tmp/
chown eguser:eggroup mepagent-conf/app_conf.yaml 	
chmod 600 mepagent-conf/app_conf.yaml
chown -R eguser:eggroup /tmp/mepagent-conf/
chmod -R 700 /tmp/mepagent-conf/

# deploy mepagent
docker run -itd --name mepagent \
                -e MEP_IP=10.151.154.36 \
                -e MEP_APIGW_PORT=8443 \
                -e MEP_AUTH_ROUTE=mepauth \
                -e ENABLE_WAIT=true \
                -e "CA_CERT=/usr/mep/ssl/ca.crt" \
                -e "CA_CERT_DOMAIN_NAME=${DOMAIN_NAME}" \
                -v ${CACRT_PATH}:/usr/mep/ssl/ca.crt:ro \
                -v app_instance_info.yaml:/usr/mep/conf/app_instance_info.yaml:ro \
                -v mepagent-conf/app_conf.yaml:/usr/mep/conf/app_conf.yaml:ro \
                -v ${MEPAGENT_CONF_PATH}:/usr/mep/mepagent.properties \
                edgegallery/mep-agent:latest
set -o history
