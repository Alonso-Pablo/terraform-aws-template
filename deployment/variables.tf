variable "aws_region" {
  type     = string
  nullable = false
}

variable "aws_profile" {
  type     = string
  default  = "default"
}


variable "aws_ecr_repo_url" {
  type     = string
  nullable = false
}
