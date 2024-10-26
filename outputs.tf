output "group_arns" {
  value = [for group in aws_iam_group.group : group.arn]
}

output "user_names" {
  value = [for user in aws_iam_user.user : user.name]
}

output "group_policies" {
  value = {
    managed = [for attachment in aws_iam_group_policy_attachment.managed_policy_attachment : attachment.policy_arn]
    inline  = [for policy in aws_iam_group_policy.inline_policy : policy.name]
  }
}
