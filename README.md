# devops-terragrunt
A repo used to accompany devops-lecture-frontend and devops-lecture-backend and provision the infrastructure with Terragrunt and Terraform

## Requirements

- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- Install [Terraform](https://learn.hashicorp.com/terraform/getting-started/install)
- Install [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)

First you will need to login with your Azure account:

```az login```

Next you will need to create the remote state, before we can create the infrastructure. 

Create a resource group with the storage account and a container for our remote state. Provide the environment variables `REMOTE_STATE_RESOURCE_GROUP`, `REMOTE_STATE_STORAGE_ACCOUNT` and `REMOTE_STATE_STORAGE_CONTAINER` or update the values directly in the remote state block of the terragrunt configuration in the `live/terragrunt.hcl` file.

### Creating the infrastructure

To create the project infrastructure for the whole project run:

```
  terragrunt plan-all
  terragrunt apply-all
```

and then you will get a prompt that will ask if you want to apply the changes, review your changes and enter `y` if you want to apply them.

If you get an error that says that some of the resources are already taken, you can use a different suffix and set it in `live\env.hcl`.

To destroy everything you created you can run the following command:

```terragrunt destroy-all```

If you want to run terragrunt commands only on a part of the infrastructure, like the resource group module you would need to change your working directory to that folder.

If your current working directory is the root folder of the project:

```
  cd live/dev/west-europe/resource_group 
  terragrunt plan-all
```

or

```terragrunt plan-all --terragrunt-working-dir live/dev/west-europe/resource_group```

The same applies to `apply-all` and `destroy-all` commands.

If some of the resources have dependencies that are located in parent folders you will be prompted to include them.


# CI/CD Pipeline

The purpose of this pipeline is to validate and deploy the infrastructure needed for the project. 

## Required environment variables

The pipeline requires the following environment variables:

- `ARM_CLIENT_ID` - The client (object) ID of the service principal
- `ARM_CLIENT_SECRET` - The password of the service principal
- `ARM_TENANT_ID` - The tenant id of the Azure Active Directory
- `ARM_SUBSCRIPTION_ID` - The subscription ID
- `REMOTE_STATE_LOCATION` - The location of the of the resources
- `REMOTE_STATE_RESOURCE_GROUP` - The name of the resource group where the remote state will be created
- `REMOTE_STATE_STORAGE_ACCOUNT` - The name of the storage account that will contain the remote state
- `REMOTE_STATE_STORAGE_CONTAINER` - The name of the container that will contain the remote state
- `TERRAGRUNT_DOWNLOAD_SHA` - SHA of terragrunt, used to verify terragrunt
- `TERRAGRUNT_VERSION` - The version of terragrunt used

## Required service principal

To run the pipeline we will need a service principal with the `Contributor` role.

### Creating a service principal using Azure CLI

Firstly, make sure you are logged in the appropriate account:

```
az login 
```

Using your subsctiption id, run:

```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"
```

This command will output the following values: "appId", "displayName", "name", "password", "tenant". 
appId is the client_id.
password is the client_secret.
tenant is the tenant_id.


### Creating a Service Principal using the Azure Portal

1. Create an Application in Azure Active Directory, which will act as a Service Principal.

Go to the Azure Active Directory overview in Azure Portal. Click the New registration button at the top to add a new Application. Supported Account Types value should be set to "Accounts in this organizational directory only (single tenant)".
At the top of the newly created Azure Active Directory application you'll need to take note of the "Application (client) ID" and the "Directory (tenant) ID", which you can use for the values of client_id and tenant_id respectively.

2. Generating a Client Secret for the Azure Active Directory Application.

Select Certificates & secrets. Click the New client secret button, then enter a Description and select an Expiry Date, and then press Add. Client secret will be visible on screen. Copy it and use it as the client_secret value that you will need.

3. Grant the Application access to manage resources in your Azure Subscription.

Navigate to the Subscriptions within the Azure Portal, then select the Subscription you wish to use, then click Access Control, and finally click Add, then click Add role assignment. Specify a Role Contributor will grant Read/Write on all resources in the Subscription for your service principal, then search and select the name of the Service Principal to assign it this role.

## Pipeline Stages

The CI/CD pipeline is divided into 3 stages: `Init`, `Plan` and `Apply`. 

In the `Init` stage we are creating the needed Azure resources for our terraform remote state. The purpose of the remote state is to keep track of changes and to have the ability to lock the state from concurrent changes. This stage will create for us a resource group and a storage account with a storage container. If any of the resources already exists, creation will be skipped.

In the `Plan` stage we are first validating that the terragrunt/terraform configuration is valid, after that we create the Plan for the changes. The plan will be displayed in the pipeline log and published as artifact.

The last stage is the `Apply` stage. To run this stage you will need to manually approve it. After approval this stage will apply/deploy our changes to our infrastructure.
