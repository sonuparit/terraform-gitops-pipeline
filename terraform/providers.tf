# =============================================================================
# TERRAFORM AND PROVIDER VERSIONS
# =============================================================================

terraform {
  required_version = "1.14.6"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
  }
}

# =============================================================================
# PROVIDER CONFIGURATIONS
# =============================================================================

provider "aws" {
  region = var.aws_region
}

provider "helm" {
  kubernetes {
    host                   = module.retail_app_eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.retail_app_eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.retail_app_eks.cluster_name]
    }
  }
}

provider "kubectl" {
  host                   = module.retail_app_eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.retail_app_eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.retail_app_eks.cluster_name]
  }
}
