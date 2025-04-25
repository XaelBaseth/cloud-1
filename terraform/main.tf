terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
  }
}

module "local" {
  source = "./vagrant"
}
