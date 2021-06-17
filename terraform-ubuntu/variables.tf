# Generate access key and secret key on AWS and make sure not to share them.
# Don't upload this file into git or any other publicly visible place
variable "access_key" {
  default=""
}
variable "secret_key" {
  default=""
}

# Specify the name of the S3 bucket you created on AWS
variable "s3_bucket" {
  default=""
}

# Customize to your preferred region of the cloud but also fine to leave as is
variable "region" {
  default="eu-west-1"
}
variable "availability_zone" {
  default="eu-west-1a"
}

# Specify your preferred instance type
# https://aws.amazon.com/marketplace/pp/prodview-dahq4vu72kpj6
# Smallest instance with a GPU: "p2.xlarge" costs 0,97 Euros an hour in Ireland (01.06.2021)
variable "instance_type" {
  default="t2.nano"
}

# Generate a key pair on AWS console and download the private one to the .ssh folder
# For example on windows this folder is found under: "C:\Users\<YOUR_USERNAME>\.ssh"
variable "key_pair_name" {
  default=""
  description = "The name of the SSH key to install onto the instances."
}

# You can either leave this ip open to the entire internet which is not very safe
# Or you can look up your public IP on sites like https://www.whatismyip.com/
variable "my_ip" {
  default="0.0.0.0/0"
}

# Deep Learning AMI v47 "ami-088b96e9fa1e46f67"
variable "deep-learning-ami" {
  default="122"
}

# the folder name mirroring the folder name in the S3 bucket
variable "source_dir" {
  default="..\\artifacts"
}