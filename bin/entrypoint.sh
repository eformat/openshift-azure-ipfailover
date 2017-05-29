#!/bin/bash

OPENSHIFT_HA_NOTIFY_SCRIPT=${OPENSHIFT_HA_NOTIFY_SCRIPT:-/usr/local/bin/notify_azure.sh}

envsubst < /root/.azure/azure.conf.tpl        >/root/.azure/azure.conf
envsubst < /root/.azure/accessTokens.json.tpl >/root/.azure/accessTokens.json
envsubst < /root/.azure/azureProfile.json.tpl >/root/.azure/azureProfile.json

exec /var/lib/ipfailover/keepalived/monitor.sh $@
