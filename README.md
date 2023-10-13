# How to Use

This repository houses a Terraform-driven proof-of-concept for deploying resources necessary to run an Azure Database
for PostgreSQL Flexible Server instance that is only reachable via a private endpoint. An accompanying jump box is made
available via an Azure Container Instance (ACI), which is only accessible via the Azure Portal.

To use this, you will need to deploy and following the instructions listed below.

## Prerequisites

You first need to ensure that your local Terraform CLI is ready to go. To do this, run the following commands:

We'll use the Azure CLI Credentials:

```bash
az login
```

Now, we need to ensure that we're pointing to the right subscription:

```bash
az account set --subscription <subscription-id>
```

Now, you're ready to proceed to the Terraform CLI commands below.

## Deployment

To deploy the Terraform, you will first need to create an Azure Storage Account to house the Terraform state. The
configuration is as follows:

> Note: If my infrastructure is still up and running, you may running into naming conflicts for the Postgres instance;
> if so, make sure to change the `pgfs-` to something unique in `postgres.tf`.

* Resource Group: `rg-pgprivendpt-tfstate`
* Storage Account Name: `stpgprivendpttfstate`
* Container Name: `terraform-state`
* Blob Name: `terraform.tfstate`

Once the storage account is created, run the following command (from the 
`infrastructure/terraform` directory) to initialize the Terraform state:

```bash
terraform init
```

You will receive feedback that the initialization was successful. Next, run the following command to deploy the
infrastructure:

```bash
terraform apply
```

You will be prompted to confirm the deployment. Enter `yes` to proceed. Once the deployment is complete, you will see
the following output:

```bash
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

pgfs-admin-password = <sensitive>
```

Finally, to retrieve the password for the `postgres` user, run the following command:

```bash
terraform output pgfs-admin-password
```

## Connecting to the Jump Box

Once you've confirmed that the infrastructure is deployed and ready, you're now ready to connect to the jump box. To do
so, navigate to the Azure Portal and locate the `acg-pgprivendpt-jumpbox` ACG instance. Click `Containers` and then
click the `Connect` tab. You will then see an option to start a bash shell. Click the `Connect` button to start the
session.

You then need to install the PostgreSQL client. To do so, run the following commands:

```bash
sudo apt-get update
sudo apt-get install postgresql-client
```

Once the client is installed, you can connect to the PostgreSQL Flexible Server instance using the following command:

```bash
psql -h pgfs-pgprivendpt.postgres.database.azure.com -U psqladmin -d postgres
```

When prompted, enter the password retrieved from the Terraform output. You should then be connected to the PostgreSQL instance!
To further prove that the PostgreSQL instance is only accessible via the private endpoint, try to connect to the server
using the public endpoint outside of the VNet. To do so, run the same command as above, but from outside the jump box
(e.g. your local machine). You should see the following error:

```bash
psql: error: could not translate host name "pgfs-pgprivendpt.postgres.database.azure.com" to address: Name or service not known
```
