resource "aws_security_group" "allow-all" {
    name = "${var.vpc_name}-allow-all"
    description = "Allow all inbound traffic"
    vpc_id = var.vpc_id

    dynamic "ingress" {
        for_each = var.service_ports
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    dynamic "ingress" {
        for_each = toset(local.ports_in)
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    dynamic "egress" {
        for_each = toset(local.ports_out)
        content {
            from_port = egress.value
            to_port = egress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks =["0.0.0.0/0"]
    }
    tags = {
        name = "${var.vpc_name}-allow-all"
        environment = var.environment
    }
}