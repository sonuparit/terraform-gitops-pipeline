# =============================================================================
# INPUT VARIABLES
# =============================================================================

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "retail-store"
}

variable "terraform_version" {
  description = "Name of the project"
  type        = string
  default     = "1.14.7"
}

variable "aws_provider_version" {
  description = "AWS module version"
  type        = string
  default     = "6.36.0"
}

variable "aws_module_version" {
  description = "AWS module version"
  type        = string
  default     = "21.15.1"
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-south-1"
}

variable "helm_version" {
  description = "Hem version to install"
  type        = string
  default     = "3.1.1"
}

variable "kubectl_version" {
  description = "Hem version to install"
  type        = string
  default     = "1.19.0"
}

variable "time_version" {
  description = "Hem version to install"
  type        = string
  default     = "0.13.1"
}

variable "random_version" {
  description = "Hem version to install"
  type        = string
  default     = "3.8.1"
}

variable "vpc_module_version" {
  description = "Version to use for VPC"
  type        = string
  default     = "6.6.0"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "retail-store"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.35.0"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "argocd_namespace" {
  description = "Namespace to install ArgoCD"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "9.4.9"
}

variable "enable_single_nat_gateway" {
  description = "Use single NAT gateway to reduce costs (not recommended for production)"
  type        = bool
  default     = true
}

variable "enable_monitoring" {
  description = "Enable monitoring stack (Prometheus, Grafana)"
  type        = bool
  default     = false
}

variable "manage_by" {
  description = "Manager of Project"
  type        = string
  default     = "terraform"
}

variable "created_by" {
  description = "Creator of project"
  type        = string
  default     = "Sonu Parit"
}