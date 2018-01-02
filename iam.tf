# ---------------------------------------------------------------------------------------------------------------------
# AWS IAM Roles and Policies
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Roles and policies for Nomad servers
# ---------------------------------------------------------------------------------------------------------------------

## Create IAM role
  resource "aws_iam_role" "ec2_describe_role" {
    name               = "${var.names_preffix}_ec2_describe_role"
    assume_role_policy = "${file("${path.module}/iam_files/iam_role_ec2_describe.json")}"
  }

## Create IAM policy
  resource "aws_iam_policy" "ec2_describe_policy" {
    name        = "${var.names_preffix}_ec2_describe_policy"
    description = "Allows EC2 Instances to Describe Other EC2 Instances"
    policy      = "${file("${path.module}/iam_files/iam_policy_ec2_describe.json")}"
  }

## Attach the policy to the role
  resource "aws_iam_policy_attachment" "ec2_describe_attach_policy" {
    name       = "${var.names_preffix}_ec2_describe_attach"
    roles      = [ "${aws_iam_role.ec2_describe_role.name}" ]
    policy_arn = "${aws_iam_policy.ec2_describe_policy.arn}"
  }

## Create the instance profile
  resource "aws_iam_instance_profile" "ec2_describe_instance_profile" {
    name  = "${var.names_preffix}_ec2_describe_instance_profile"
    role  = "${aws_iam_role.ec2_describe_role.name}"
  }

# ---------------------------------------------------------------------------------------------------------------------
# Roles and policies for Nomad clients
# ---------------------------------------------------------------------------------------------------------------------

## Create IAM role
  resource "aws_iam_role" "push_to_ecr_role" {
    name               = "${var.names_preffix}_push_to_ecr_role"
    assume_role_policy = "${file("${path.module}/iam_files/iam_role_ec2_describe.json")}"
  }

## Create IAM policy to allow the push of docker images to ECR
  resource "aws_iam_policy" "push_to_ecr_policy" {
    name        = "${var.names_preffix}_push_to_ecr_policy"
    description = "Allow EC2 instances to push docker images to ECR registry"
    policy      = "${file("${path.module}/iam_files/iam_policy_push_to_ecr.json")}"
  }

## Attach the policy to the role  
  resource "aws_iam_policy_attachment" "push_to_ecr_attach_policy" {
    name       = "${var.names_preffix}_push_to_ecr_attach"
    roles      = [ "${aws_iam_role.push_to_ecr_role.name}" ]
    policy_arn =  "${aws_iam_policy.push_to_ecr_policy.arn}"
  }

## Create an instance profile
  resource "aws_iam_instance_profile" "ecr_role_instance_profile" {
    name = "${var.names_preffix}_push_to_ecr_instance_profile"
    role = "${aws_iam_role.push_to_ecr_role.name}"
  }