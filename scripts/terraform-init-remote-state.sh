# ---------------------------------------------------------------------------------------------------------------------
# THIS SCRIPT WILL CREATE A RESOURCE GROUP, STORAGE ACCOUNT AND CONTAINER TO STORE TERRAFORM REMOTE STATE
#
# Required environment variables:
# ARM_CLIENT_ID                  - The client (object) ID of the service principal
# ARM_CLIENT_SECRET              - The password of the service principal
# ARM_TENANT_ID                  - The tenant id of the Azure Active Directory
# REMOTE_STATE_LOCATION          - The location of the of the resources
# REMOTE_STATE_RESOURCE_GROUP    - The name of the resource group where the remote state will be created
# REMOTE_STATE_STORAGE_ACCOUNT   - The name of the storage account that will contain the remote state
# REMOTE_STATE_STORAGE_CONTAINER - The name of the container that will contain the remote state
# ---------------------------------------------------------------------------------------------------------------------

#!/usr/bin/env bash
set -euo pipefail

# Login into Azure using a service principal
az login --service-principal --username $ARM_CLIENT_ID --password $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

# Set default values for resource group and location so we don't have to repeat them
az configure --defaults location=$REMOTE_STATE_LOCATION
az configure --defaults group=$REMOTE_STATE_RESOURCE_GROUP

# Create a resource group for our remote state if it doesn't exist
if [ $(az group exists --name $REMOTE_STATE_RESOURCE_GROUP) = false ]; then
  echo "Creating resource group for remote state..."
  az group create -n $REMOTE_STATE_RESOURCE_GROUP
else
  echo "Resource group already exists."
fi

STORAGE_ACCOUNT_NAME=$(az storage account list --query "[].name" -o tsv) 

# Create a storage account for our remote state if it doesn't exist
if [[ $STORAGE_ACCOUNT_NAME != $REMOTE_STATE_STORAGE_ACCOUNT ]]; then
  echo "Creating storage account for remote state..."
  az storage account create -n $REMOTE_STATE_STORAGE_ACCOUNT --sku Standard_LRS
else
  echo "Storage account already exists."
fi

STORAGE_ACCOUNT_KEY=$(az storage account keys list -n $REMOTE_STATE_STORAGE_ACCOUNT --query "[0].value" -o tsv)  
STORAGE_CONTAINER_NAME=$(az storage container list --account-key $STORAGE_ACCOUNT_KEY --account-name $REMOTE_STATE_STORAGE_ACCOUNT --query "[].name" -o tsv)

# Create a storage container if it doesn't exist
if [[ $STORAGE_CONTAINER_NAME != $REMOTE_STATE_STORAGE_CONTAINER ]]; then
  echo "Creating storage container for remote state..."
  az storage container create -n $REMOTE_STATE_STORAGE_CONTAINER --account-name $REMOTE_STATE_STORAGE_ACCOUNT --account-key $STORAGE_ACCOUNT_KEY
else
  echo "Storage container already exists."
fi