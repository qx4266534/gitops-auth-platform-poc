terraform {
  required_version = ">= 1.5.0"

  required_providers {
    openfga = {
      source  = "openfga/openfga"
      version = "~> 0.1"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 17.0"
    }
    harbor = {
      source  = "goharbor/harbor"
      version = "~> 3.10"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-bank-platform"
    key            = "auth-platform/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
