provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_autoscaling_group" "asg" {
  name_prefix        = "asg-cloud-"
  availability_zones = [var.availability_zone]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1
  health_check_type  = "EC2"

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "template" {
  name_prefix     = "launch-template-"
  instance_type   = var.instance_type
  image_id        = data.aws_ami.ubuntu-ami.id
  user_data       = data.template_cloudinit_config.config.rendered
  key_name        = var.key_pair_name

  vpc_security_group_ids = [ aws_security_group.instance-sg.id ]
  iam_instance_profile { arn = aws_iam_instance_profile.profile.arn }
}

data "aws_ami" "ubuntu-ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_cloudinit_config" "config" {
  base64_encode = true
  gzip = true
  part {
    content_type  = "text/x-shellscript"
    content       = templatefile("instance-install.sh", {
      s3_bucket = var.s3_bucket
      region    = var.region
    })
  }
}

resource "aws_security_group" "instance-sg" {
  name_prefix   = "instance-sg-"

  ingress {
    description = "http"
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.my_ip]
  }
}

resource "aws_iam_instance_profile" "profile" {
  name_prefix   = "iam-profile-"
  role          = aws_iam_role.s3_role.name
}

resource "aws_iam_role_policy_attachment" "instance_policy_attach" {
  role          = aws_iam_role.s3_role.name
  policy_arn    = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role" "s3_role" {
  name_prefix        = "role-"
  path               = "/"
  assume_role_policy = <<ROLE
{
  "Version": "2012-10-17",
  "Statement": [ {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Principal": { "Service": "ec2.amazonaws.com" }, "Sid": "" } ]
}
ROLE
}

resource "aws_iam_policy" "s3_policy" {
  name_prefix           = "s3-policy-"
  policy                = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [ {
    "Effect": "Allow",
    "Action": [ "s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:ListBucket" ],
    "Resource": [ "arn:aws:s3:::${var.s3_bucket}", "arn:aws:s3:::${var.s3_bucket}/*" ]}]
}
POLICY
}
