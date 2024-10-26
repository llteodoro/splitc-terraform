resource "aws_iam_group" "group" {
  for_each = toset(var.group_names)
  name     = each.value
}

resource "aws_iam_user" "user" {
  for_each = flatten([
    for group_name, users in var.group_users :
    [
      for user in users : {
        group_name = group_name
        user_name  = user
      }
    ]
  ])
  
  name = each.value.user_name

  tags = {
    Role = each.value.group_name
  }
}

resource "aws_iam_group_membership" "group_membership" {
  for_each = var.group_users

  name  = "${each.key}-membership"
  users = [for user in each.value : user]
  group = aws_iam_group.group[each.key].name
}

# Gerenciar várias políticas gerenciadas (AWS Managed Policies)
resource "aws_iam_group_policy_attachment" "managed_policy_attachment" {
  for_each = flatten([
    for group_name, policy_arns in var.managed_policies :
    [
      for policy_arn in policy_arns : {
        group_name = group_name
        policy_arn = policy_arn
      }
    ]
  ])
  
  group      = aws_iam_group.group[each.value.group_name].name
  policy_arn = each.value.policy_arn
}

# Políticas inline para cada grupo
resource "aws_iam_group_policy" "inline_policy" {
  for_each = var.inline_policies

  group    = aws_iam_group.group[each.key].name
  name     = "${each.key}-inline-policy"
  policy   = jsonencode(each.value)
}
