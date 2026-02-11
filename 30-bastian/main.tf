module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami    = data.aws_ami.matt.id

  name                   = local.resource_name
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.bastian_sg_id]
  subnet_id              = local.public_subnet_id

 tags = merge(
    var.common_tags,
    var.bastian_tags,
    {
        Name = local.resource_name
    }

 )
 }
