terraform {
  required_version = "~>1.6"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~>4.7.0"
    }
  }
}

