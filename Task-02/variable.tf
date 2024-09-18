variable "cidr_block" {
  type    = string
  default = "10.0.0.0/17"
}

variable "tags" {
  type    = string
  default = "pratik-vpc"
}


# subnet variable 

variable "public_subnet-01_cidr" {
    type = string
    default = "10.0.1.0/24"
}

variable "public_subnet-01_tags" {
  type = string
  default = "public_subnet-01"
}

variable "public_subnet-02_cidr" {
    type = string
    default = "10.0.2.0/24"
}

variable "public_subnet-02_tags" {
  type = string
  default = "public_subnet-02"
}

variable "private_subnet-01_cidr" {
    type = string
    default = "10.0.3.0/24"
}

variable "private_subnet-01_tags" {
  type = string
  default = "private_subnet-01"
}

variable "private_subnet-02_cidr" {
    type = string
    default = "10.0.4.0/24"
}

variable "private_subnet-02_tags" {
  type = string
  default = "private_subnet-02"
}

# IGW
variable "aws_internet_gateway_tags" {
  type = string
  default = "pr-IGW"
}

#Elastic Ip
variable "aws_eip_name" {
  type = string
  default = "ESIP-04"
}

#NAT Gatway
variable "aws_nat_gateway_tags" {
  type = string
  default = "NAT04"
}


#Public Route Table

variable "publicRT_tags" {
  type = string
  default = "publicRT"
}

variable "privateRT_tags" {
  type = string
  default = "privateRT"
} 


# Security group

variable "aws_SG_public" {
  type = string
  default = "public-SG"
}

variable "aws_SG_private" {
  type = string
  default = "private-SG"
}

#instance 

variable "AMI_ID" {
  type    = string
  default = "ami-0522ab6e1ddcc7055"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "rana"
}

variable "instance_name_public" {
  type    = string
  default = "public-instance"
}

variable "instance02_name_private" {
  type    = string
  default = "private-instance-01"
}

variable "instance03_name_private" {
  type    = string
  default = "private-instance-02"
}


# Target Group

variable "tool-name" {
  type = string
  default = "Prometheous"
}

# TG attachement 

variable "port-num" {
  type = string
  default = "9090"
}

# ALB
variable "ALB-Name" {
  type = string
  default = "promethous-ALB"
}

variable "ALB-type" {
  type = string
  default = "application"
}

# S3
variable "bucket-name" {
  type = string
  default = "pratikbucketrana"
}

variable "versioning" {
  type = bool
  default = true
}

variable "tags-name" {
  type = string
  default = "my bucket"
}

variable "tags-env" {
  type = string
  default = "Dev"
}

# DynoTB
variable "name-dyno" {
  type = string
  default = "dynoTB"
}



