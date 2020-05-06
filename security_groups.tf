#------------------------------------------------------------------------------
# SECURITY GROUPS - Open a list of Ports to allow connections to Nomad and Consul Instances
#------------------------------------------------------------------------------

## Security Group
resource "aws_security_group" "instances_security_group" {
  name        = "instances_security_group"
  description = "Open ports on instances"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.names_preffix}_instances_security_group"
  }
}

## Allow trafic from within the security group
resource "aws_security_group_rule" "instances_security_group_allow_ingress_self" {
  depends_on        = [aws_security_group.instances_security_group]
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.instances_security_group.id
}

## Allow traffic from subnets
resource "aws_security_group_rule" "instances_security_group_allow_ingress_subnets" {
  depends_on        = [aws_security_group.instances_security_group]
  count             = length(data.aws_subnet.subnets.*.cidr_block)
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = data.aws_subnet.subnets.*.cidr_block
  security_group_id = aws_security_group.instances_security_group.id
}

## Open TCP Ports on Security Group
resource "aws_security_group_rule" "instances_security_group_allow_ingress_open_tcp_ports" {
  depends_on = [aws_security_group.instances_security_group]
  count      = length(var.tcp_ports_to_open_on_instances_security_group)
  type       = "ingress"
  from_port = element(
    var.tcp_ports_to_open_on_instances_security_group,
    count.index,
  )
  to_port = element(
    var.tcp_ports_to_open_on_instances_security_group,
    count.index,
  )
  protocol          = "tcp"
  cidr_blocks       = var.cidrs_to_open_ports_on_security_groups
  security_group_id = aws_security_group.instances_security_group.id
}

## Open UDP Ports on Security Group
resource "aws_security_group_rule" "instances_security_group_allow_ingress_open_udp_ports" {
  depends_on = [aws_security_group.instances_security_group]
  count      = length(var.udp_ports_to_open_on_instances_security_group)
  type       = "ingress"
  from_port = element(
    var.udp_ports_to_open_on_instances_security_group,
    count.index,
  )
  to_port = element(
    var.udp_ports_to_open_on_instances_security_group,
    count.index,
  )
  protocol          = "udp"
  cidr_blocks       = var.cidrs_to_open_ports_on_security_groups
  security_group_id = aws_security_group.instances_security_group.id
}

## Allow all outbound traffic
resource "aws_security_group_rule" "instances_security_group_allow_egress_traffic" {
  depends_on        = [aws_security_group.instances_security_group]
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instances_security_group.id
}

#------------------------------------------------------------------------------
# SECURITY GROUPS - Open 22, 80 and 443 ports to allow connections on Load Balancers
#------------------------------------------------------------------------------
## Security Group
resource "aws_security_group" "elb_security_group" {
  name        = "elb_security_group"
  description = "Open ports on Load Balanacers"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.names_preffix}_elb_security_group"
  }
}

## Open Ports on Security Group for VPC Connections
resource "aws_security_group_rule" "elb_security_group_allow_ingress_open_ports_vpc" {
  depends_on        = [aws_security_group.elb_security_group]
  count             = length(var.ports_to_open_on_elb_security_group)
  type              = "ingress"
  from_port         = element(var.ports_to_open_on_elb_security_group, count.index)
  to_port           = element(var.ports_to_open_on_elb_security_group, count.index)
  protocol          = "tcp"
  cidr_blocks       = data.aws_subnet.subnets.*.cidr_block
  security_group_id = aws_security_group.elb_security_group.id
}

## Open Ports on Security Group
resource "aws_security_group_rule" "elb_security_group_allow_ingress_open_ports_vpn" {
  depends_on        = [aws_security_group.elb_security_group]
  count             = length(var.ports_to_open_on_elb_security_group)
  type              = "ingress"
  from_port         = element(var.ports_to_open_on_elb_security_group, count.index)
  to_port           = element(var.ports_to_open_on_elb_security_group, count.index)
  protocol          = "tcp"
  cidr_blocks       = var.cidrs_to_open_ports_on_security_groups
  security_group_id = aws_security_group.elb_security_group.id
}

## Allow all outbound traffic
resource "aws_security_group_rule" "elb_security_group_allow_egress_traffic" {
  depends_on        = [aws_security_group.elb_security_group]
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elb_security_group.id
}

