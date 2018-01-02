  data "aws_subnet" "subnets" {
    count = "${length(var.subnets_ids)}"
    id    = "${element(var.subnets_ids, count.index)}"
  }

  data "aws_route53_zone" "hosted_zone" {
    zone_id = "${var.route53_zone_id}"
    vpc_id  = "${var.vpc_id}"
  }