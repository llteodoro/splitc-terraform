module "iam_groups" {
  source      = "./modules/iam_group"
  group_names = ["cs", "engineers", "sre", "growth"]
  group_users = {
    cs        = ["alice", "bob"]
    engineers = ["carol", "dave"]
    sre       = ["eve", "frank"]
    growth    = ["grace", "heidi"]
  }
  
  # Políticas gerenciadas - múltiplas ARNs por grupo
  managed_policies = {
    cs        = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess", "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"]
    engineers = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/AWSLambda_FullAccess"]
    sre       = ["arn:aws:iam::aws:policy/CloudWatchFullAccess"]
  }
  
  # Políticas inline personalizadas
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
