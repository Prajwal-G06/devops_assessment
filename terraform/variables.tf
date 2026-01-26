#--------------- Global variables ---------------#
variable "region" {
  description = "Region for infrastructure deployment."
}

variable "environment" {
  description = "Environment tag."
}

#--------------- Module variables ---------------#

variable "ec2_conf" {
  description = "EC2 related variables"
}
