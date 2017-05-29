FROM registry.access.redhat.com/openshift3/ose-keepalived-ipfailover:latest
MAINTAINER Samuel Terburg <sterburg@redhat.com>
ENTRYPOINT /usr/local/bin/entrypoint.sh

COPY bin/    /usr/local/bin/
COPY .azure/ /root/.azure/

ENV AZURE_CONFIG_DIR=/root/.azure \
    AZURE_NON_INTERACTIVE_MODE=true \
    AZURE_INSTALLATION_ID="" \
    AZURE_RESOURCE_GROUP=Openshift \
    AZURE_LOCATION=westeurope \
    AZURE_SUBNET="" \
    AZURE_VNET_NAME="" \
    AZURE_AAD_TENANT_ID="" \
    AZURE_AAD_CLIENT_ID="" \
    AZURE_AAD_CLIENT_SECRET="" \
    AZURE_SUBSCRIPTION_ID="" \
    AZURE_SUBSCRIPTION_NAME="" \
    OPENSHIFT_HA_NOTIFY_SCRIPT=/usr/local/bin/notify_azure.sh
    

### Install Azure CLI ###
RUN yum -y \
        --enablerepo=rhel-server-rhscl-7-rpms \
        install gcc \
                libffi-devel \
                rh-python35  \
                openssl-devel && \
    yum clean all && \
    source /opt/rh/rh-python35/enable && \
    pip install --upgrade azure-cli && \
    pip install --upgrade --force-reinstall azure-nspkg azure-mgmt-nspkg
#    curl -L https://aka.ms/InstallAzureCli | bash
