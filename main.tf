resource "vault_aws_secret_backend" "aws" {
  access_key = var.initial_aws_access_key_id
  secret_key = var.initial_aws_secret_access_key
  lifecycle {
    ignore_changes = [
      access_key,
      secret_key
    ]
  }
}

resource "vault_aws_secret_backend_role" "probable_pancake_role" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "probable-pancake-tf"
  credential_type = "assumed_role"
  role_arns       = ["arn:aws:iam::517068637116:role/dyn-ec2-access"]
}

resource "vault_policy" "probable_pancake" {
  name = "aws-probable-pancake"
  # ref app_policies.tf
  policy = data.vault_policy_document.probable_pancake.hcl
}

resource "vault_jwt_auth_backend_role" "probable_pancake" {
  backend        = "jwt"
  role_name      = "hcp-tf-probable-pancake"
  token_policies = ["default", vault_policy.probable_pancake.name]

  bound_audiences = ["vault.workload.identity"]
  bound_claims = {
    sub = "organization:philbrook:project:SB Vault Lab:workspace:aws-probable-pancake:run_phase:*"
  }
  bound_claims_type = "glob"
  user_claim        = "terraform_full_workspace"
  role_type         = "jwt"
}

data "vault_policy_document" "probable_pancake" {
  rule {
    path         = "aws/creds/${vault_aws_secret_backend_role.probable_pancake_role.name}"
    capabilities = ["read"]
    description  = "Read dynamic AWS credentials for the specified role"
  }

  rule {
    path         = "aws/sts/${vault_aws_secret_backend_role.probable_pancake_role.name}"
    capabilities = ["read", "update", "create"]
    description  = "Read dynamic AWS credentials for the specified role with the STS path."
  }
}
