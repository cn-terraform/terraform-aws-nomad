# Nomad Terraform Module for AWS #

This Terraform module deploys Nomad Servers and Nodes in AWS.

[![CircleCI](https://circleci.com/gh/cn-terraform/terraform-aws-nomad/tree/master.svg?style=svg)](https://circleci.com/gh/cn-terraform/terraform-aws-nomad/tree/master)
[![](https://img.shields.io/github/license/cn-terraform/terraform-aws-nomad)](https://github.com/cn-terraform/terraform-aws-nomad)
[![](https://img.shields.io/github/issues/cn-terraform/terraform-aws-nomade)](https://github.com/cn-terraform/terraform-aws-nomad)
[![](https://img.shields.io/github/issues-closed/cn-terraform/terraform-aws-nomad)](https://github.com/cn-terraform/terraform-aws-nomad)
[![](https://img.shields.io/github/languages/code-size/cn-terraform/terraform-aws-nomad)](https://github.com/cn-terraform/terraform-aws-nomad)
[![](https://img.shields.io/github/repo-size/cn-terraform/terraform-aws-nomad)](https://github.com/cn-terraform/terraform-aws-nomad)

## Usage

Check valid versions on:
* Github Releases: <https://github.com/cn-terraform/terraform-aws-nomad/releases>
* Terraform Module Registry: <https://registry.terraform.io/modules/cn-terraform/nomad>

        module "nomad" {
            source  = "cn-terraform/nomad/aws"
            version = "2.0.2"

            names_preffix = ${terraform.workspace}

            profile         = var.profile
            region          = var.region
            vpc_id          = var.vpc_id
            subnets_ids     = var.subnets_ids
            route53_zone_id = var.private_hosted_zone_id
            domain_name     = var.domain_name
            ssh_key_name    = var.ssh_key_name

            cidrs_to_open_ports_on_security_groups = [ "XXX.XXX.XXX.XXX/XX" ]

            consul_version = "0.9.2"
            nomad_version  = "0.6.0"
            consul_address = "consul.${var.domain_name}"

            server_ami_id               = var.aws_linux_ami_id
            server_instance_type        = "t2.medium"
            server_asg_min_size         = 3
            server_asg_desired_capacity = 3
            server_asg_max_size         = 3

            client_ami_id               = var.aws_linux_ami_id
            client_instance_type        = "m4.xlarge"
            client_asg_min_size         = 1
            client_asg_desired_capacity = 3
            client_asg_max_size         = 25
    	}

## Output values
