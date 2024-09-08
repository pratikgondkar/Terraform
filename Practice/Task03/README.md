# Problem Statement
- Create the following Terraform modules and configure the root module to use them:

- Networking Module

Description: Manages the creation of networking resources.
- Components:
VPC: Virtual Private Cloud.
Public Subnets: 2 subnets.in short and easy language by using tree structure solve this by using terraforn modules
Private Subnets: 2 subnets.
Route Tables: 2 route tables.
give me step by step solution for this

### Solution:- 
- Create Directory Structure
```
networking-task/
│
├── main.tf         # Root module configuration
├── variables.tf    # Variables for the root module
├── outputs.tf      # Outputs for the root module
└── modules/
    └── networking/
        ├── main.tf         # Resources for networking (VPC, subnets, route tables)
        ├── variables.tf    # Variables for networking module
        ├── outputs.tf      # Outputs from networking module

```
### Create the Networking Module
- File: modules/networking/main.tf
```
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

# Public Subnets
resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.public_subnets_cidr, count.index)
  map_public_ip_on_launch = true
}

# Private Subnets
resource "aws_subnet" "private" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.private_subnets_cidr, count.index)
}

# Route Tables for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

# Route Tables for Private Subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

```
- File: modules/networking/variables.tf
```
 variable "vpc_cidr" {
  type = string
}

variable "public_subnets_cidr" {
  type = list(string)
}

variable "private_subnets_cidr" {
  type = list(string)
}

```

- File: modules/networking/outputs.tf
```
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

```

### Create the Root Module
- File: main.tf
```
module "networking" {
  source = "./modules/networking"

  vpc_cidr           = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
}

```
- File: variables.tf
```
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

```
- File: outputs.tf
```
output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}

```
- Initialize and Apply
```
terraform init
terraform apply

```
