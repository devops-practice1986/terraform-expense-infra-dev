module "mysql_sg" {
  source       = "../../terraform-aws-security-group-3"
  vpc_id       = local.vpc_id
  sg_name      = "mysql-sg"
  project_name = var.project_name
  environment  = var.environment
  sg_tags      = var.mysql_sg_tags
}

module "backend_sg" {
  source       = "../../terraform-aws-security-group-3"
  vpc_id       = local.vpc_id
  sg_name      = "backend-sg"
  project_name = var.project_name
  environment  = var.environment
  sg_tags      = var.backend_sg_tags
}

module "frontend_sg" {
  source       = "../../terraform-aws-security-group-3"
  vpc_id       = local.vpc_id
  sg_name      = "frontend-sg"
  project_name = var.project_name
  environment  = var.environment
  sg_tags      = var.frontend_sg_tags
}
# Security group for bastian to connect private ips

module "bastian_sg" {
  source       = "../../terraform-aws-security-group-3"
  vpc_id       = local.vpc_id
  sg_name      = "bastian-sg"
  project_name = var.project_name
  environment  = var.environment
  sg_tags      = var.bastian_sg_tags
}

module "ansible_sg" {
  source       = "../../terraform-aws-security-group-3"
  vpc_id       = local.vpc_id
  sg_name      = "ansible-sg"
  project_name = var.project_name
  environment  = var.environment
  sg_tags      = var.ansible_sg_tags
}

# Mysql allowing connections on 3306 from the instances attached to backend SG

resource "aws_security_group_rule" "mysql_backend" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.backend_sg.id
  security_group_id        = module.mysql_sg.id

}

resource "aws_security_group_rule" "backend_frontend" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.frontend_sg.id
  security_group_id        = module.backend_sg.id

}
resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend_sg.id

}

# rule for bastian to connect mysql
resource "aws_security_group_rule" "mysql_bastian" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastian_sg.id
  security_group_id        = module.mysql_sg.id
}

resource "aws_security_group_rule" "backend_bastian" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastian_sg.id
  security_group_id        = module.backend_sg.id
}

resource "aws_security_group_rule" "frontend_bastian" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastian_sg.id
  security_group_id        = module.frontend_sg.id
}

resource "aws_security_group_rule" "public_bastian" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastian_sg.id
}

# Rules for ansible

resource "aws_security_group_rule" "mysql_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id        = module.mysql_sg.id
}

resource "aws_security_group_rule" "backend_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id        = module.backend_sg.id
}

resource "aws_security_group_rule" "frontend_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id        = module.frontend_sg.id
}
resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ansible_sg.id
}
