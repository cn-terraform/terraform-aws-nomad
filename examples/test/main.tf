module "base-network" {
  source                                      = "cn-terraform/networking/aws"
  name_prefix                                 = "test-networking"
  vpc_cidr_block                              = "192.168.0.0/16"
  availability_zones                          = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  public_subnets_cidrs_per_availability_zone  = ["192.168.0.0/19", "192.168.32.0/19", "192.168.64.0/19", "192.168.96.0/19"]
  private_subnets_cidrs_per_availability_zone = ["192.168.128.0/19", "192.168.160.0/19", "192.168.192.0/19", "192.168.224.0/19"]
}

module "nomad" {
  source      = "../../"
  name_prefix = "nomad"
  region      = "us-east-1"
  vpc_id      = module.base-network.vpc_id
  subnets_ids = module.base-network.private_subnets_ids
}

variable "route53_zone_id" {
  description = "Route53 Zone ID to fetch"
}

variable "domain_name" {
  description = "Domain Name"
}

variable "ssh_key_name" {
  description = "SSH Key Name"
}

#------------------------------------------------------------------------------
# SECURITY GROUP
#------------------------------------------------------------------------------
variable "cidrs_to_open_ports_on_security_groups" {
  description = "List of CIDRs to open ports on instances security group"
  type        = list(any)
}

variable "ports_to_open_on_elb_security_group" {
  description = "Ports to Open on ELB Security Group"
  type        = list(any)
  default     = ["22", "80", "443"]
}

variable "tcp_ports_to_open_on_instances_security_group" {
  description = "TCP Ports to Open on Instances Security Group"
  type        = list(any)
  default     = ["22", "4646", "4647", "4648", "8300", "8301", "8302", "8500", "8600"]
}

variable "udp_ports_to_open_on_instances_security_group" {
  description = "UDP Ports to Open on Instances Security Group"
  type        = list(any)
  default     = ["4648", "8301", "8302", "8600"]
}

#------------------------------------------------------------------------------
# VERSIONS
#------------------------------------------------------------------------------
variable "consul_version" {
  description = "Consul Version"
  default     = "v1.11.4"
}

variable "nomad_version" {
  description = "Nomad Version"
  default     = "v1.2.6"
}

variable "consul_address" {
  description = "Consul Address"
}

#------------------------------------------------------------------------------
# SERVER SETTINGS
#------------------------------------------------------------------------------
variable "server_ami_id" {
  description = "AMI ID to use on servers"
  type        = string
}

variable "server_instance_type" {
  description = "AWS Instance type to use on servers"
  type        = string
}

variable "server_asg_min_size" {
  description = "Min Number of Instances of PAAS Server to Create"
}

variable "server_asg_desired_capacity" {
  description = "Desired Number of Instances of PAAS Server to Create"
}

variable "server_asg_max_size" {
  description = "Max Number of Instances of PAAS Server to Create"
}

#------------------------------------------------------------------------------
# NOMAD CLIENT SETTINGS
#------------------------------------------------------------------------------
variable "client_ami_id" {
  description = "AMI ID to use on Clients"
  type        = string
}

variable "client_instance_type" {
  description = "AWS Instance type to use on clients"
  type        = string
}

variable "client_asg_min_size" {
  description = "Min Number of Instances of Nomad Client to Create"
}

variable "client_asg_desired_capacity" {
  description = "Desired Number of Instances of Nomad Client to Create"
}

variable "client_asg_max_size" {
  description = "Max Number of Instances of Nomad Client to Create"
}
