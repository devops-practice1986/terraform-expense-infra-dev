locals {
   resource_name = "${var.project_name}-${var.environment}-bastian"
   bastian_sg_id = data.aws_ssm_parameter.bastian_sg_id.value
   # here stringlist to list converion by split
   public_subnet_id = split(",",data.aws_ssm_parameter.public_subnet_ids.value)[0] # for 1st public_subnet
}