# Learning Terraform 
Use terraform to provision AWS infrastructure

The link on the headings wil take you to the branch or tag for the lab.

For official terraform information goto https://www.terraform.io/docs/

In particular the [Get Started Guide](https://learn.hashicorp.com/terraform/getting-started/build) is a good place to start.

# [LAB-01](../../tree/LAB-01) - Set up terraform in Virtualbox
## Install Terraform
* Install Virtualbox 
* Install Vagrant
* Have a look at the Vagrant file
    * The provisioner sets up terraform in Ubuntu
* Run vagrant
```
vagrant up
```
* ssh to terraform box
```
vagrant ssh terraform
terraform
```
You should see the terraform usage page :)

## Setup AWS keys
### Create AWS Access keys
* Log into the AWS console.
* Click on your username in the top menu bar
* Select `My Security Credentials`
* On the `AWS IAM Credentials` tab
* Click the `Create Access Key` button
* Copy the `Access Key Id` and the `Secret access key` (You will need to show it first)
  * Alternatively download the .csv file
* Please keep these safe and do not share with anyone
### Create an SSH Keypair
* Use the AWS console to create a new keypair (if you don't have one already)
* Download the .pem and remember the key pair name

### Setup secrets file
Create a file called `secrets.auto.tfvars` in this folder
(note use this name exactly, it has been excuded from git in the .gitignore file)

Add the following lines to it (ensure you surround the values with quotes)
```
# secrets.auto.tfvars
aws_access_key_id = "your access key id"
aws_secret_access_key = "your secret access key"
key_pair_name = "your key pair name"
```

## Run Terraform 
In this section you will run terraform initialisation, plan, apply and destroy.

Have a look at the `main.tf` file.

Please change the `Name` and `Creator` tags

Now run the following noting the output from each terraform command.
``` bash
# Make sure you are in the src directory
cd src
terraform init
terraform plan
terraform apply #type yes when prompted
```
Check the EC2 instances in the AWS console your instance should be created in the defauklt VPC.

When you are done please destroy the instance
``` bash
terraform destroy # type yes 
```

---
Free to use under [MIT Licence](./LICENCE)

Copyright (c) Mike Scott 2020
