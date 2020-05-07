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
``` bash
vagrant up
```
* ssh to terraform box
``` bash
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
``` terraform
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
Check the EC2 instances in the AWS console your instance should be created in the default VPC.

When you are done please destroy the instance
``` bash
terraform destroy # type yes 
```

# [LAB-02](../../tree/LAB-02) - Add security group to connect to instance
## Add security group to terraform
Note the changes to [`main.tf`](./main.tf):
* A new `aws_security_group` resource has been added with ssh access enabled from a whitelist
* the security group is referenced in the ec2 instance
* the dns and public ip of the instance are output

Add an IP whitelist to the secrets file and add your IP to that:
``` terraform
# secrets.auto.tfvars
aws_access_key_id = "your access key id"
aws_secret_access_key = "your secret access key"
key_pair_name = "your key pair name"

whitelist_ips = ["your.ip/32"]
```

Run terraform to create the new infrastructure
``` bash
# Make sure you are in the src directory
cd src
# Run init if not done already
terraform init
# Plan and apply the plan
terraform plan -out=plan.tfplan
terraform apply plan.tfplan
```
Note the output `public_dns` entry and ssh to your new instance
``` bash
ssh -i <path-to-sshkey> ec2-user@<public_dns_entry>
# if you see the login prompt e.g: [ec2-user@ip-... ~], it all worked
# to get back to your vagrant session:
exit 
```
Now try adding a role tag to the instance
``` terraform
resource "aws_instance" "tomcat" {
  ...
  tags = {
      ...
      Role = "webserver"
  }
}
```
Then run `terraform apply` again

Notice that it only changes the instance to add the tag.  This is desired state configuration in  action.

When you are done please tidy up aftery yourself
``` bash
terraform destroy
```
You can always recreate everything in a couple of minutes :)


---
Free to use under [MIT Licence](./LICENCE)

Copyright (c) Mike Scott 2020
