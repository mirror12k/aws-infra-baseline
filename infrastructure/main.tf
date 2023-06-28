provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Name = "account-baseline"
    }
  }
}

# enable guardduty for the account
resource "aws_guardduty_detector" "account_guardduty_detector" {
  enable = true
}

# enable access analyzer for the account
resource "aws_accessanalyzer_analyzer" "account_access_analyzer" {
  analyzer_name = "main"
  type          = "ACCOUNT"
}

# Enable securityhub
resource "aws_securityhub_account" "account_securityhub" {}

# enable securityhub standards
resource "aws_securityhub_standards_subscription" "account_securityhub_aws_foundational_subscription" {
  standards_arn = "arn:aws:securityhub:us-east-1::standards/aws-foundational-security-best-practices/v/1.0.0"
  depends_on    = [aws_securityhub_account.account_securityhub]
}
resource "aws_securityhub_standards_subscription" "account_securityhub_cis_subscription" {
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
  depends_on    = [aws_securityhub_account.account_securityhub]
}
resource "aws_securityhub_standards_subscription" "account_securityhub_pci_subscription" {
  standards_arn = "arn:aws:securityhub:us-east-1::standards/pci-dss/v/3.2.1"
  depends_on    = [aws_securityhub_account.account_securityhub]
}

# a random tfstate bucket to hold any terraform states that we create with infrastructure
resource "random_id" "account_tfstate_bucket_random_id" { byte_length = 24 }
resource "aws_s3_bucket" "account_tfstate_bucket" {
  bucket = "tfstate-${random_id.account_tfstate_bucket_random_id.hex}"
}
# infra user
resource "aws_iam_user" "account_infra_deployer" {
  name = "infra-deployer"
}

# infra access only via MFA
resource "aws_iam_policy" "account_infra_deployer_mfa_policy" {
  name        = "AdministratorMFAAccess"
  path        = "/"
  policy = file("administrator-mfa-access-policy.json")
}
# attach the policy
resource "aws_iam_policy_attachment" "account_infra_deployer_policy_attachment" {
  name       = "AdministratorMFAAccess-attachment"
  users      = [aws_iam_user.account_infra_deployer.name]
  policy_arn = aws_iam_policy.account_infra_deployer_mfa_policy.arn
}
# get the access key for the user
resource "aws_iam_access_key" "account_infra_deployer_access_key" {
  user    = aws_iam_user.account_infra_deployer.name
}


# store the access credentials for the infra user
output "infra_deployer_access_id" {
  value = aws_iam_access_key.account_infra_deployer_access_key.id
  sensitive = true
}
output "infra_deployer_secret_access_key" {
  value = aws_iam_access_key.account_infra_deployer_access_key.secret
  sensitive = true
}


