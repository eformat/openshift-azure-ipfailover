#!/bin/bash -x

. /var/lib/ipfailover/keepalived/lib/failover-functions.sh
. /opt/rh/rh-python35/enable

INSTANCE_ID=`hostname`
VRRP_STATE=${3:-BACKUP}
AZURE_RESOURCE_GROUP=${AZURE_RESOURCE_GROUP:-Openshift}
AZURE_LOCATION=${AZURE_LOCATION:-westeurope}
AZURE_SUBNET=${AZURE_SUBNET:-snbvaz012snose_ota_conn}
AZURE_VNET_NAME=${AZURE_VNET_NAME:-snbvaz012vn001}


for VIRTUAL_IP in $(expand_ip_ranges "${OPENSHIFT_HA_VIRTUAL_IPS}"); do
  if [ "$VRRP_STATE" == "MASTER" ]; then
    CURRENT_INSTANCE_ID=`az vm list -g OpenShift --show-details --query="[?contains(privateIps,'${VIRTUAL_IP}')].name" -o tsv`
    if [ "${CURRENT_INSTANCE_ID}" != "${INSTANCE_ID}" ]; then

        if [ -n "${CURRENT_INSTANCE_ID}" ]; then
            CURRENT_NIC_NAME=`az vm show -g OpenShift -n $CURRENT_INSTANCE_ID --show-details --query 'networkProfile.networkInterfaces[0].id' -o tsv |sed 's/.*\///'`
	    az network nic ip-config delete \
	       --resource-group $AZURE_RESOURCE_GROUP \
	       --nic-name $CURRENT_NIC_NAME \
	       --name OpenShiftIpFailoverRouter
        fi

        NIC_NAME=`az vm show -g OpenShift -n $INSTANCE_ID --show-details --query 'networkProfile.networkInterfaces[0].id' -o tsv |sed 's/.*\///'`
	az network nic ip-config create \
	   --resource-group $AZURE_RESOURCE_GROUP \
	   --nic-name $NIC_NAME \
	   --private-ip-address $VIRTUAL_IP \
	   --name OpenShiftIpFailoverRouter

    fi
  fi
done

