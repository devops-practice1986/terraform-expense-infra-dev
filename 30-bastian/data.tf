data "aws_ssm_parameter" "bastian_sg_id" {
  # /expense/dev/bastian_sg_id
  name = "/${var.project_name}/${var.environment}/bastian_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  # /expense/dev/public_subnet_ids
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}

# for AMI 
data "aws_ami" "matt" {

  most_recent = true
  owners      = ["973714476881"]


  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
   }
}
