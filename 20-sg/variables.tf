variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project     = "expense"
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "mysql_sg_tags" {
  default = {
    Component = "mysql"

  }
}

variable "backend_sg_tags" {
  default = {
    Component = "backend"

  }
}
variable "frontend_sg_tags" {
  default = {
    Component = "frontend"

  }
}

variable "bastian_sg_tags"{
default = {
    Component = "bastian"
}
}
variable "ansible_sg_tags"{
    default ={
        Component= "ansible"
    }
}
