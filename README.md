Terraform AWS IAM Groups Module
This Terraform module helps you create and manage AWS IAM groups, users, and permissions. You can use this module to define groups, assign users, and manage permissions through both AWS Managed Policies and inline policies.

Features
Create IAM groups and users.
Assign users to specific groups.
Attach multiple AWS Managed Policies to each group.
Define custom inline policies for each group.
Usage
Module Configuration Example
hcl
Copiar código
module "iam_groups" {
  source = "./modules/iam_group"

  group_names = ["cs", "engineers", "sre", "growth"]
  
  group_users = {
    cs        = ["alice", "bob"]
    engineers = ["carol", "dave"]
    sre       = ["eve", "frank"]
    growth    = ["grace", "heidi"]
  }
  
  # Managed Policies - specify multiple ARNs per group
  managed_policies = {
    cs        = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess", "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"]
    engineers = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/AWSLambda_FullAccess"]
    sre       = ["arn:aws:iam::aws:policy/CloudWatchFullAccess"]
  }
  
  # Custom Inline Policies - define JSON for custom permissions
  inline_policies = {
    sre = {
      "Version" : "2012-10-17",
      "Statement" : [{
        "Action" : [
          "ec2:Describe*",
          "cloudwatch:GetMetricStatistics"
        ],
        "Effect"   : "Allow",
        "Resource" : "*"
      }]
    },
    growth = {
      "Version" : "2012-10-17",
      "Statement" : [{
        "Action" : "s3:ListBucket",
        "Effect" : "Allow",
        "Resource" : "arn:aws:s3:::example-bucket"
      }]
    }
  }
}
Variables
Name	Type	Description	Default
group_names	list(string)	List of IAM group names.	N/A
group_users	map(list(string))	Mapping of group names to lists of user names.	N/A
managed_policies	map(list(string))	Map of group names to lists of AWS Managed Policy ARNs.	{}
inline_policies	map(map(any))	Map of group names to custom inline policy definitions.	{}
Outputs
Name	Description
group_arns	List of ARNs for the created IAM groups.
user_names	List of IAM user names that were created or managed.
group_policies	Managed and inline policies associated with the groups.
How to Import Existing Users or Groups
If you have existing IAM users or groups, you can import them to manage with Terraform.

Import Existing User:

bash
Copiar código
terraform import module.iam_groups.aws_iam_user.user["alice"] alice
Import Existing Group:

bash
Copiar código
terraform import module.iam_groups.aws_iam_group.group["cs"] cs
Example of Applying the Module
Create main.tf with your configuration:

hcl
Copiar código
module "iam_groups" {
  source = "./modules/iam_group"

  group_names = ["cs", "engineers", "sre", "growth"]
  
  group_users = {
    cs        = ["alice", "bob"]
    engineers = ["carol", "dave"]
    sre       = ["eve", "frank"]
    growth    = ["grace", "heidi"]
  }
  
  managed_policies = {
    cs        = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
    engineers = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess"]
  }
  
  inline_policies = {
    sre = {
      "Version" : "2012-10-17",
      "Statement" : [{
        "Action" : [
          "ec2:Describe*",
          "cloudwatch:GetMetricStatistics"
        ],
        "Effect"   : "Allow",
        "Resource" : "*"
      }]
    }
  }
}
Run Terraform Commands:

bash
Copiar código
terraform init
terraform plan
terraform apply
Requirements
Terraform version >= 0.12
AWS Provider configuration
Provider Configuration
Make sure to have your AWS provider configured:

hcl
Copiar código
provider "aws" {
  region = "us-west-2"
  profile = "default"
}
Notes
Ensure that your AWS credentials are properly set up and have the necessary permissions to create IAM resources.
Be cautious when managing IAM resources, as incorrect permissions can impact your infrastructure security.
