resource "aws_security_group" "eks_srcurity_group_node" {
  name        = "${var.cluster_name}-eks-node"
  description = "security group for eks nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.cluster_name}-eks-node"
    Project = var.cluster_name
  }
}

resource "aws_security_group_rule" "eks_ingress_node_cluster_rule" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = var.source_security_group_id
  security_group_id        = aws_security_group.eks_srcurity_group_node.id
  description              = "allow traffic from eks cluster"
}

resource "aws_security_group_rule" "eks_ingress_node_ssh_rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_srcurity_group_node.id
  description       = "allow ssh access to worker nodes"
}

## launch_template
resource "aws_launch_template" "eks_launch_template" {
  name          = "${var.cluster_name}-eks-node"
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp3"
    }
  }

  network_interfaces {
    security_groups = [aws_security_group.eks_srcurity_group_node.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "${var.cluster_name}-node"
      Project = var.cluster_name
    }
  }
}
