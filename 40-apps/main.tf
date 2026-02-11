module "mysql" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami    = data.aws_ami.matt.id

  name                   = "${local.resource_name}-mysql"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.common_tags,
    var.mysql_tags,

    {
      Name = "${local.resource_name}-mysql"
    }

  )
}

module "backend" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami    = data.aws_ami.matt.id

  name                   = "${local.resource_name}-backend"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.backend_sg_id]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    var.backend_tags,

    {
      Name = "${local.resource_name}-backend"
    }

  )
}
module "frontend" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami    = data.aws_ami.matt.id

  name                   = "${local.resource_name}-frontend"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.frontend_sg_id]
  subnet_id              = local.public_subnet_id

  tags = merge(
    var.common_tags,
    var.frontend_tags,

    {
      Name = "${local.resource_name}-frontend"
    }

  )
}

module "ansible" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami    = data.aws_ami.matt.id

  name                   = "${local.resource_name}-ansible"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.ansible_sg_id]
  subnet_id              = local.public_subnet_id
  user_data              = file("expense.sh")

  tags = merge(
    var.common_tags,
    var.ansible_tags,

    {
      Name = "${local.resource_name}-ansible"
    }

  )
}



## This code is suitable for module 
# module "records" {
#   source = "terraform-aws-modules/route53/aws"
#   name   = var.zone_names


#   records = {
#     mysql = {
#       name    = "mysql"
#       type    = "A"
#       ttl     = 1
#       records = [module.mysql.private_ip]
#     }
#     backend = {
#       name    = "backend"
#       type    = "A"
#       ttl     = 1
#       records = [module.backend.private_ip]
#     }
#     fronted = {
#       name    = "frontend"
#       type    = "A"
#       ttl     = 1
#       records = [module.frontend.private_ip]
#     }
#     public = {
#       name    = "expense"
#       type    = "A"
#       ttl     = 1
#       records = [module.frontend.public_ip]
#     }

#   }
# }

#########################################################
### we can use Above OR Bellow route53 module for records
#########################################################

# this code is suitable for this module but it is a old module , not register in terraform 
# but it works.
module "route53_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0" # or a specific version

  zone_name = var.zone_names
  records = [
    {
      name    = "mysql"
      type    = "A"
      ttl     = 1
      records = [tostring(module.mysql.private_ip)]
    },
    {
      name    = "backend"
      type    = "A"
      ttl     = 1
      records = [tostring(module.backend.private_ip)]
    },
    {
      name    = "frontend"
      type    = "A"
      ttl     = 1
      records = [tostring(module.frontend.private_ip)]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 1
      records = [tostring(module.frontend.public_ip)]
    }
  ]
}

# connect to ansible
# sudo su -
# cd /var/log
# tail -f cloud-init-output.log

# connect to mysql with bastian
# ssh ec2-user@private-ip
# netstat -lntp (to see ports)

# exit

# as well backend

# exit and as well frontend




