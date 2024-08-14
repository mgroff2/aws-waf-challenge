# Variables
# Region and Default Tags for Provider: 
variable "region" {
  description = "The AWS region"
  type        = string
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
}
