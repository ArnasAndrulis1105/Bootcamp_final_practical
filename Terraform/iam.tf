variable "eks_admin_role_name" {
  description = "Name of the IAM role for EKS admin access"
  type        = string
  default     = "eks-admin"
}

variable "eks_read_only_role_name" {
  description = "Name of the IAM role for EKS read-only access"
  type        = string
  default     = "eks-read-only"
}

resource "aws_iam_role" "eks_admin" {
  name = "eks-admin"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_admin" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.eks_admin.name
}

resource "aws_iam_role" "eks_read_only" {
  name = "eks-read-only"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSReadOnlyAccess"
  role       = aws_iam_role.eks_read_only.name
}