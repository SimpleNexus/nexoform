variable "region" {
  type        = "string"
  description = "AWS region to create assets in.  Should be one of [us-east-1, us-west-2, etc]"
}

variable "environment" {
  type = "string"
  description = "Env"
}
