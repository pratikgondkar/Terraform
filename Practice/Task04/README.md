# Problem Statement
Continue with the previous task add below modules also.
Security Module
Description: Manages the creation of security groups.
Components:
Public Security Group: For public instances with only SSH port open.
Private Security Group: For private instances with only SSH port open.
Compute Module
Description: Manages the creation of instances.
Components:
Public Instances: Launch instances in the public subnet.
Private Instances: Launch instances in the private subnet.

### Solution :- 
- Update Directory Structure
```
networking-task/
│
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
    ├── networking/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── compute/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf

```

### Create the Security Module
- File: modules/security/main.tf
```
# Public Security Group: Allow SSH access only
resource "aws_security_group" "public_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all IPs for SSH
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Private Security Group: Allow SSH access only
resource "aws_security_group" "private_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

- File: modules/security/variables.tf
```
variable "vpc_id" {
  type = string
}

variable "allowed_ip_cidr" {
  description = "List of CIDR blocks allowed to access private instances"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

```
- File: modules/security/outputs.tf
```
output "public_sg_id" {
  value = aws_security_group.public_sg.id
}

output "private_sg_id" {
  value = aws_security_group.private_sg.id
}

```

### Create the Compute Module
- File: modules/compute/main.tf
```
# Public Instances
resource "aws_instance" "public_instance" {
  count         = var.public_instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  security_groups = [var.public_sg_id]
  associate_public_ip_address = true
}

# Private Instances
resource "aws_instance" "private_instance" {
  count         = var.private_instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  security_groups = [var.private_sg_id]
}

```
- File: modules/compute/variables.tf
```
variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "public_sg_id" {
  type = string
}

variable "private_sg_id" {
  type = string
}

variable "ami_id" {
  description = "AMI ID for the instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "public_instance_count" {
  description = "Number of public instances"
  type        = number
  default     = 1
}

variable "private_instance_count" {
  description = "Number of private instances"
  type        = number
  default     = 1
}

```

- File: modules/compute/outputs.tf
```
output "public_instance_ids" {
  value = aws_instance.public_instance[*].id
}

output "private_instance_ids" {
  value = aws_instance.private_instance[*].id
}

```
### Update the Root Module to Call Security and Compute Modules
- File: main.tf
```
module "networking" {
  source = "./modules/networking"

  vpc_cidr            = var.vpc_cidr
  public_subnets_cidr = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
}

module "security" {
  source = "./modules/security"

  vpc_id          = module.networking.vpc_id
  allowed_ip_cidr = ["0.0.0.0/0"] # Modify based on your needs
}

module "compute" {
  source = "./modules/compute"

  public_subnet_id  = element(module.networking.public_subnet_ids, 0)
  private_subnet_id = element(module.networking.private_subnet_ids, 0)
  public_sg_id      = module.security.public_sg_id
  private_sg_id     = module.security.private_sg_id
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  public_instance_count  = var.public_instance_count
  private_instance_count = var.private_instance_count
}

```

- File: variables.tf
```
variable "ami_id" {
  description = "AMI ID for instances"
  default     = "ami-12345678" # Update with a valid AMI ID
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"
}

variable "public_instance_count" {
  default = 1
}

variable "private_instance_count" {
  default = 1
}

```

-  Initialize and Apply Changes
```
terraform init
terraform apply

```

## Find a Valid AMI ID: You can find a valid AMI ID for the region you're working in using either the AWS Management Console or AWS CLI.
```
aws ec2 describe-images \
  --filters "Name=name,Values=amzn2-ami-hvm-*" \
  --query "Images[*].[ImageId,Name]" \
  --region <your-region> \
  --output text

```
