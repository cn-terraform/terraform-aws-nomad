#------------------------------------------------------------------------------
# ELASTIC LOAD BALANCER - CONSUL
#------------------------------------------------------------------------------
## ELB
resource "aws_elb" "consul_elb" {
  name                      = "${var.names_preffix}-consul-elb"
  security_groups           = [aws_security_group.elb_security_group.id]
  subnets                   = data.aws_subnet.subnets.*.id
  internal                  = true
  cross_zone_load_balancing = true
  tags = {
    Name = "${var.names_preffix}_consul_elb"
  }
  listener {
    instance_port     = "8500"
    instance_protocol = "tcp"
    lb_port           = "80"
    lb_protocol       = "tcp"
  }
}

## Add DNS Record
resource "aws_route53_record" "consul_elb_dns" {
  depends_on = [aws_elb.consul_elb]
  zone_id    = data.aws_route53_zone.hosted_zone.zone_id
  name       = "consul.${var.domain_name}"
  type       = "A"
  alias {
    name                   = aws_elb.consul_elb.dns_name
    zone_id                = aws_elb.consul_elb.zone_id
    evaluate_target_health = true
  }
}

#------------------------------------------------------------------------------
# ELASTIC LOAD BALANCER - NOMAD
#------------------------------------------------------------------------------
## ELB
resource "aws_elb" "nomad_elb" {
  name                      = "${var.names_preffix}-nomad-elb"
  security_groups           = [aws_security_group.elb_security_group.id]
  subnets                   = data.aws_subnet.subnets.*.id
  internal                  = true
  cross_zone_load_balancing = true
  tags = {
    Name = "${var.names_preffix}_nomad_elb"
  }
  listener {
    instance_port     = "4646"
    instance_protocol = "tcp"
    lb_port           = "80"
    lb_protocol       = "tcp"
  }
}

## Add DNS Record
resource "aws_route53_record" "nomad_elb_dns" {
  depends_on = [aws_elb.nomad_elb]
  zone_id    = data.aws_route53_zone.hosted_zone.zone_id
  name       = "nomad.${var.domain_name}"
  type       = "A"
  alias {
    name                   = aws_elb.nomad_elb.dns_name
    zone_id                = aws_elb.nomad_elb.zone_id
    evaluate_target_health = true
  }
}

