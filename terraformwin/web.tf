provider "aws" {
  region = "eu-west-1"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

# Security group for ELB
resource "aws_security_group" "sg_elb" {
    name = "sg_elb"
    description = "Allow traffic to ELB on 80 from everywhere"
    vpc_id = "${var.vpc_id}"

    # HTTP from everywhere
    ingress { from_port = "80" to_port = "80" protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
    # Goes Anywhere with any protocol
    egress { from_port = "0" to_port = "0" protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }

    tags { Name = "SG ELB"}
}

# Security group for nginx fronts
resource "aws_security_group" "sg_web" {
    name = "sg_web"
    description = "Allow traffic to web instances from ELB on 80"
    vpc_id = "${var.vpc_id}"

    # Allowing HTTP from ELB security group
    ingress { from_port = "80" to_port = "80" security_groups = [ "${aws_security_group.sg_elb.id}" ] protocol = "tcp" }

    # Goes Anywhere with any protocol
    egress { from_port = "0" to_port = "0" protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }

    tags { Name = "SG Web"}
}

resource "aws_elb" "myelb" {
    name = "myelb"
    subnets = ["${split(",",var.public_subnets)}"]
    security_groups = ["${aws_security_group.sg_elb.id}"]
    cross_zone_load_balancing = "true"
    listener {
        instance_port = "80"
        instance_protocol = "http"
        lb_port = "80"
        lb_protocol = "http"
    }
    health_check {
        healthy_threshold = "2"
        unhealthy_threshold = "2"
        timeout = "2"
        target = "HTTP:80/"
        interval = "5"
    }
    tags {
        Name = "${myelb}"
    }
}

resource "template_file" "user_data" {
    template = "${file("win_user_data.tpl")}"
    vars {
         db_endpoint = "${var.db_endpoint}"
         db_instance = "${var.db_instance}"
         db_user = "${var.db_user}"
         db_password = "${var.db_password}"
    }
}

resource "aws_launch_configuration" "web" {
    image_id = "${var.web_ami}"
    name_prefix = "web"
    instance_type = "${var.web_instance_type}"
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.sg_web.id}"]
    user_data="${template_file.user_data.rendered}"
}

resource "aws_autoscaling_group" "web_asg" {
    name = "${concat("web-",aws_launch_configuration.web.name)}"
    launch_configuration = "${aws_launch_configuration.web.id}"
    availability_zones = ["${split(",",var.azs)}"]
    vpc_zone_identifier = ["${split(",",var.public_subnets)}"]
    load_balancers = ["${aws_elb.myelb.name}"]

    tag { key = "Name" value = "Web" propagate_at_launch = "true" }

    min_size = "${var.asg_min}"
    max_size = "${var.asg_max}"
    desired_capacity = "${var.asg_desired}"
}

output "elb" { value = "${aws_elb.myelb.dns_name}" }
