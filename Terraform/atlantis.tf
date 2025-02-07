provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  }
}

variable "github_user" {
  description = "GitHub username for Atlantis configuration"
  type        = string
}

variable "github_token" {
  description = "GitHub personal access token for Atlantis"
  type        = string
  sensitive   = true
}

variable "github_repo" {
  description = "GitHub repository name for Atlantis to monitor"
  type        = string
}


resource "helm_release" "atlantis" {
  name             = "atlantis"
  repository       = "https://runatlantis.github.io/helm-charts"
  chart            = "atlantis"
  namespace        = "atlantis"
  create_namespace = true

  set {
    name  = "github.user"
    value = var.github_user
  }
  set {
    name  = "github.token"
    value = var.github_token
  }
  set {
    name  = "orgWhitelist"
    value = "github.com/${var.github_user}"
  }
  set {
    name  = "repoWhitelist"
    value = "github.com/${var.github_user}/${var.github_repo}"
  }

  provider = kubernetes.eks
}