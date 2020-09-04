#------------------------------------------------------------------------------
# NOMAD CLIENT - Launch Configuration User Data
#------------------------------------------------------------------------------
data "template_file" "nomad_client_user_data" {
  template = file("${path.module}/templates/nomad_client.sh")
  vars = {
    nomad_version  = var.nomad_version
    region         = var.region
    consul_address = var.consul_address
  }
}

#------------------------------------------------------------------------------
# NOMAD CLIENT - Launch Configuration
#------------------------------------------------------------------------------
resource "aws_launch_configuration" "nomad_client_lc" {
  depends_on = [
    aws_autoscaling_attachment.nomad_asg_attachment,
    aws_security_group.instances_security_group,
  ]
  name                        = "${var.names_prefix}_nomad_client_lc"
  image_id                    = var.client_ami_id
  instance_type               = var.client_instance_type
  iam_instance_profile        = aws_iam_instance_profile.ecr_role_instance_profile.name
  security_groups             = [aws_security_group.instances_security_group.id]
  associate_public_ip_address = false
  enable_monitoring           = true
  key_name                    = var.ssh_key_name
  user_data                   = data.template_file.nomad_client_user_data.rendered
}

#------------------------------------------------------------------------------
# NOMAD CLIENT - Auto Scaling Group
#------------------------------------------------------------------------------
resource "aws_autoscaling_group" "nomad_client_asg" {
  depends_on           = [aws_launch_configuration.nomad_client_lc]
  name                 = "${var.names_prefix}_nomad_client_asg"
  launch_configuration = aws_launch_configuration.nomad_client_lc.name
  vpc_zone_identifier  = var.subnets_ids
  min_size             = var.client_asg_min_size
  desired_capacity     = var.client_asg_desired_capacity
  max_size             = var.client_asg_max_size
  tags = [
    {
      key                 = "Name"
      value               = "${var.names_prefix}_nomad_client_asg"
      propagate_at_launch = true
    },
  ]
}

