variable "key_name" {}

variable "web_ami" {}
variable "web_instance_type" {}

variable "public_subnets" {}
variable "azs" {}

variable "sg_elb" {}
variable "sg_web" {}

variable "asg_min" {}
variable "asg_max" {}
variable "asg_desired" {}

variable "db_endpoint" {}
variable "db_instance" {}
variable "db_user" {}
variable "db_password" {}
