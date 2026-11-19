# ---------- 1. Trust GitHub as an identity provider ----------
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  # thumbprint_list is optional in current provider versions; AWS validates
  # GitHub's certificate itself. If validate demands it, tell me.
}

# ---------- 2. Trust policy: WHO may assume the role ----------
# aws_iam_policy_document writes IAM JSON for you, in HCL, with validation.
data "aws_iam_policy_document" "github_plan_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    # Condition 1: the token was issued for AWS STS
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Condition 2: the token came from YOUR repo, for a pull request
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_owner}@${var.github_owner_id}/${var.github_repo}@${var.github_repo_id}:pull_request"]
    }
  }
}

# ---------- 3. The role ----------
resource "aws_iam_role" "github_plan" {
  name               = "github-actions-terraform-plan"
  assume_role_policy = data.aws_iam_policy_document.github_plan_trust.json
}

# ---------- 4. Permissions: WHAT the role may do ----------
# Read everything (plan needs to compare real AWS to your code)
resource "aws_iam_role_policy_attachment" "github_plan_readonly" {
  role       = aws_iam_role.github_plan.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Plan takes the state lock, which means writing and deleting the .tflock file
data "aws_iam_policy_document" "github_plan_state_lock" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.tf_state.arn}/envs/dev/terraform.tfstate.tflock"]
  }
}

resource "aws_iam_role_policy" "github_plan_state_lock" {
  name   = "terraform-state-lock"
  role   = aws_iam_role.github_plan.id
  policy = data.aws_iam_policy_document.github_plan_state_lock.json
}