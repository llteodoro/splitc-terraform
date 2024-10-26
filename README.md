# Terraform AWS IAM Groups Module
This Terraform module helps you create and manage AWS IAM groups, users, and permissions. You can use this module to define groups, assign users, and manage permissions through both AWS Managed Policies and inline policies.

## Features
- Create IAM groups and users.
- Assign users to specific groups.
- Attach multiple AWS Managed Policies to each group.
- Define custom inline policies for each group.

### Usage

Example

```
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
```
## How to Import Existing Users or Groups
If you have existing IAM users or groups, you can import them to manage with Terraform.

Import Existing User:

```
terraform import module.iam_groups.aws_iam_user.user["alice"] alice
```

Import Existing Group:

```
terraform import module.iam_groups.aws_iam_group.group["cs"] cs
```

## Requirements         

| Name  | Version |
| ------------- | ------------- |
| terraform  | >= 0.12 |
| aws	 | >= 3.0 |

## Providers

| Name  | Version |
| ------------- | ------------- |
| aws	 | >= 3.0 |

## Inputs

| Name  | Description             | Type        | Default | Required |
| ---- | ------------------------ | ----------- | ------- | -------- |
| `group_names`	 | List of IAM group names. | list(string) | N/A    | yes      |
| `group_users`	 | Mapping of group names to lists of user names. | 	map(list(string)) | `{}`    | yes      |
| `managed_polices`	 | Map of group names to list of managed policy ARNs. | 	map(list(string)) | `{}`    | no      |
| `inlines_polices`	 | Map of group names to custom inline policy definitions. | map(map(any)) | `{}`    | no      |

## Outputs

| Name  | Description  |
| ------------- | ------------- |
| group_arns	 | List of ARNs for the created IAM groups.|
| user_names | List of IAM user names that were created or managed.|
| group_policies	 | 	Managed and inline policies associated with the groups.|

# Example of Applying the Module
### 1 .Create `main.tf` with your configuration:
```
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
```

### 2. Run Terraform Commands:
```
terraform init
terraform plan
terraform apply
```

## Provider Configuration
Make sure to have your AWS provider configured:

```
provider "aws" {
  region  = "us-west-2"
  profile = "default"
}
```
## Notes
- Ensure that your AWS credentials are properly set up and have the necessary permissions to create IAM resources.
- Be cautious when managing IAM resources, as incorrect permissions can impact your infrastructure security.
