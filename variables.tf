variable "initial_aws_access_key_id" {
  type = string
}

variable "initial_aws_secret_access_key" {
  type      = string
  sensitive = true
}

variable "tf_jwt_path" {
  description = "The path to the JWT auth mount used for HCP Terraform integration with Vault."
  type        = string
  default     = "jwt"
}

