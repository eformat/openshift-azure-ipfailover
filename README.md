# openshift-azure-ipfailover
In an OpenShift Container Platform, Add support for ipfailover for Azure cloud-provider.

# How it works
Using the azure-cli to move an elastic-ip from one VM to the other VM.

# How to use
```
oc -n openshift new-build https://github.com/sterburg/openshift-azure-ipfailover.git

oc adm policy add-scc-to-user privileged -z ipfailover
oc adm ipfailover router-internal-ipfailover \
    --service-account=ipfailover \
    --images=10.204.242.20:5000/default/openshift-azure-ipfailover \
    --latest-images \
    --selector="role=proxy,stage=prod,zone=app" \
    --virtual-ips=10.203.70.9 \
    --notify-script='/usr/local/bin/notify_azure.sh'
oc env dc/router-internal-ipfailover \
    AZURE_INSTALLATION_ID=12345678-1234-1234-1234-1234567890ab \
    AZURE_RESOURCE_GROUP=Openshift \
    AZURE_LOCATION=westeurope \
    AZURE_SUBNET=mysubnet001 \
    AZURE_VNET_NAME=myvnet001 \
    AZURE_AAD_TENANT_ID=1234567890abc-1234-1234-1234567890ab \
    AZURE_AAD_CLIENT_ID=12345678-1234-1234-1234-1234567890ab \
    AZURE_AAD_CLIENT_SECRET=1234567890abcdefghijklmnopqrstuvwxyz1234567= \
    AZURE_SUBSCRIPTION_ID=12345678-1234-1234-1234-1234567890ab \
    AZURE_SUBSCRIPTION_NAME=snbvaz012_OpenShift

#or use a configmap or hostPath mount instead of ENV vars.
#oc -n default   volume dc/ipfailover  --add --mount-path=/root/.azure --type=hostPath --path=/etc/azure
```

