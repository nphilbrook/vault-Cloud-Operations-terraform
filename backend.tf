terraform {
  cloud {
    organization = "philbrook"

    workspaces {
      project = "SB Vault Lab"
      name    = "vault-Cloud-Operations-terraform"
    }
  }
}
