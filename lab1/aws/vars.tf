variable "access_key" {}
variable "secret_key" {}

variable "aws_properties" {
  type = map(string)
  default = {
    region        = "eu-west-1"
    instance_type = "t2.micro"
  }
}
