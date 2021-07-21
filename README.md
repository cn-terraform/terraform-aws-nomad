# Nomad Terraform Module for AWS #

This Terraform module deploys Nomad Servers and Nodes in AWS.

[![](https://github.com/cn-terraform/terraform-aws-nomad/workflows/terraform/badge.svg)](https://github.com/cn-terraform/terraform-aws-nomad/actions?query=workflow%3Aterraform)
[![](https://img.shields.io/github/license/cn-terraform/terraform-aws-nomad)](https://github.com/cn-terraform/terraform-aws-nomad)
[![](https://img.shields.io/github/issues/cn-terraform/terraform-aws-nomad)](https://github.com/cn-terraform/terraform-aws-nomad)
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

            names_prefix = ${terraform.workspace}

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

## Install pre commit hooks.

Pleas run this command right after cloning the repository.

        pre-commit install

For that you may need to install the folowwing tools:
* [Pre-commit](https://pre-commit.com/) 
* [Terraform Docs](https://terraform-docs.io/)

In order to run all checks at any point run the following command:

        pre-commit run --all-files

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.consul_asg_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.nomad_asg_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.nomad_client_asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_group.server_asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_elb.consul_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb) | resource |
| [aws_elb.nomad_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb) | resource |
| [aws_iam_instance_profile.ec2_describe_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_instance_profile.ecr_role_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.ec2_describe_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.push_to_ecr_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.ec2_describe_attach_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.push_to_ecr_attach_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.ec2_describe_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.push_to_ecr_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_launch_configuration.nomad_client_lc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_launch_configuration.server_lc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_route53_record.consul_elb_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.nomad_elb_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.elb_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.instances_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.elb_security_group_allow_egress_traffic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_security_group_allow_ingress_open_ports_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elb_security_group_allow_ingress_open_ports_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.instances_security_group_allow_egress_traffic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.instances_security_group_allow_ingress_open_tcp_ports](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.instances_security_group_allow_ingress_open_udp_ports](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.instances_security_group_allow_ingress_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.instances_security_group_allow_ingress_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_route53_zone.hosted_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnet.subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [template_file.nomad_client_user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.server_user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidrs_to_open_ports_on_security_groups"></a> [cidrs\_to\_open\_ports\_on\_security\_groups](#input\_cidrs\_to\_open\_ports\_on\_security\_groups) | List of CIDRs to open ports on instances security group | `list(any)` | n/a | yes |
| <a name="input_client_ami_id"></a> [client\_ami\_id](#input\_client\_ami\_id) | AMI ID to use on Clients | `string` | n/a | yes |
| <a name="input_client_asg_desired_capacity"></a> [client\_asg\_desired\_capacity](#input\_client\_asg\_desired\_capacity) | Desired Number of Instances of Nomad Client to Create | `any` | n/a | yes |
| <a name="input_client_asg_max_size"></a> [client\_asg\_max\_size](#input\_client\_asg\_max\_size) | Max Number of Instances of Nomad Client to Create | `any` | n/a | yes |
| <a name="input_client_asg_min_size"></a> [client\_asg\_min\_size](#input\_client\_asg\_min\_size) | Min Number of Instances of Nomad Client to Create | `any` | n/a | yes |
| <a name="input_client_instance_type"></a> [client\_instance\_type](#input\_client\_instance\_type) | AWS Instance type to use on clients | `string` | n/a | yes |
| <a name="input_consul_address"></a> [consul\_address](#input\_consul\_address) | Consul Address | `any` | n/a | yes |
| <a name="input_consul_version"></a> [consul\_version](#input\_consul\_version) | Consul Version | `string` | `"0.9.2"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain Name | `any` | n/a | yes |
| <a name="input_names_prefix"></a> [names\_prefix](#input\_names\_prefix) | prefix for Resources Names | `any` | n/a | yes |
| <a name="input_nomad_version"></a> [nomad\_version](#input\_nomad\_version) | Nomad Version | `string` | `"0.6.0"` | no |
| <a name="input_ports_to_open_on_elb_security_group"></a> [ports\_to\_open\_on\_elb\_security\_group](#input\_ports\_to\_open\_on\_elb\_security\_group) | Ports to Open on ELB Security Group | `list(any)` | <pre>[<br>  "22",<br>  "80",<br>  "443"<br>]</pre> | no |
| <a name="input_profile"></a> [profile](#input\_profile) | AWS API key credentials to use | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region the infrastructure is hosted in | `any` | n/a | yes |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 Zone ID to fetch | `any` | n/a | yes |
| <a name="input_server_ami_id"></a> [server\_ami\_id](#input\_server\_ami\_id) | AMI ID to use on servers | `string` | n/a | yes |
| <a name="input_server_asg_desired_capacity"></a> [server\_asg\_desired\_capacity](#input\_server\_asg\_desired\_capacity) | Desired Number of Instances of PAAS Server to Create | `any` | n/a | yes |
| <a name="input_server_asg_max_size"></a> [server\_asg\_max\_size](#input\_server\_asg\_max\_size) | Max Number of Instances of PAAS Server to Create | `any` | n/a | yes |
| <a name="input_server_asg_min_size"></a> [server\_asg\_min\_size](#input\_server\_asg\_min\_size) | Min Number of Instances of PAAS Server to Create | `any` | n/a | yes |
| <a name="input_server_instance_type"></a> [server\_instance\_type](#input\_server\_instance\_type) | AWS Instance type to use on servers | `string` | n/a | yes |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | SSH Key Name | `any` | n/a | yes |
| <a name="input_subnets_ids"></a> [subnets\_ids](#input\_subnets\_ids) | Private Subnets | `list(any)` | n/a | yes |
| <a name="input_tcp_ports_to_open_on_instances_security_group"></a> [tcp\_ports\_to\_open\_on\_instances\_security\_group](#input\_tcp\_ports\_to\_open\_on\_instances\_security\_group) | TCP Ports to Open on Instances Security Group | `list(any)` | <pre>[<br>  "22",<br>  "4646",<br>  "4647",<br>  "4648",<br>  "8300",<br>  "8301",<br>  "8302",<br>  "8500",<br>  "8600"<br>]</pre> | no |
| <a name="input_udp_ports_to_open_on_instances_security_group"></a> [udp\_ports\_to\_open\_on\_instances\_security\_group](#input\_udp\_ports\_to\_open\_on\_instances\_security\_group) | UDP Ports to Open on Instances Security Group | `list(any)` | <pre>[<br>  "4648",<br>  "8301",<br>  "8302",<br>  "8600"<br>]</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
