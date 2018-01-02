# ---------------------------------------------------------------------------------------------------------------------
# PAAS SERVER - Launch Configuration User Data
# ---------------------------------------------------------------------------------------------------------------------
  data "template_file" "server_user_data" {
    template = "${file("${path.module}/templates/server.sh")}"
    vars {
      consul_version  = "${var.consul_version}"
      region          = "${var.region}"
      desired_servers = "${var.server_asg_desired_capacity}"
      domain          = "${var.domain_name}" 
      asg_name        = "${var.names_preffix}_server_asg"
      nomad_version   = "${var.nomad_version}"
    }
  }

# ---------------------------------------------------------------------------------------------------------------------
# PAAS SERVER - Launch Configuration
# ---------------------------------------------------------------------------------------------------------------------
  resource "aws_launch_configuration" "server_lc" {
    depends_on                  = [ "aws_security_group.instances_security_group", "aws_iam_instance_profile.ec2_describe_instance_profile" ]
    name                        = "${var.names_preffix}_server_lc"
    image_id                    = "${var.server_ami_id}"
    instance_type               = "${var.server_instance_type}"
    iam_instance_profile        = "${aws_iam_instance_profile.ec2_describe_instance_profile.name}"
    security_groups             = [ "${aws_security_group.instances_security_group.id}" ]
    associate_public_ip_address = false
    enable_monitoring           = true
    key_name                    = "${var.ssh_key_name}"
    user_data                   = "${data.template_file.server_user_data.rendered}"
  }

# ---------------------------------------------------------------------------------------------------------------------
# PAAS SERVER - Auto Scaling Group
# ---------------------------------------------------------------------------------------------------------------------
  resource "aws_autoscaling_group" "server_asg" {
    depends_on            = [ "aws_launch_configuration.server_lc" ]
    name                  = "${var.names_preffix}_server_asg"
    launch_configuration  = "${aws_launch_configuration.server_lc.name}"
    vpc_zone_identifier   = [ "${var.subnets_ids}" ]
    min_size              = "${var.server_asg_min_size}"
    desired_capacity      = "${var.server_asg_desired_capacity}"
    max_size              = "${var.server_asg_max_size}"
    tags = [
      {
        key                 = "Name"
        value               = "${var.names_preffix}_server_asg"
        propagate_at_launch = true
      },
    ]
  }

# ---------------------------------------------------------------------------------------------------------------------
# PAAS SERVER - Auto Scaling Group Attachment to ELB
# ---------------------------------------------------------------------------------------------------------------------
## Consul
  resource "aws_autoscaling_attachment" "consul_asg_attachment" {
    autoscaling_group_name = "${aws_autoscaling_group.server_asg.id}"
    elb                    = "${aws_elb.consul_elb.id}"
  }
## Nomad
  resource "aws_autoscaling_attachment" "nomad_asg_attachment" {
    autoscaling_group_name = "${aws_autoscaling_group.server_asg.id}"
    elb                    = "${aws_elb.nomad_elb.id}"
  }