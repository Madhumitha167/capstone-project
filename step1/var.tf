#vpc cidr

variable "vpc_cidr" {
    description = "CIDR range of vpc"
    type = string
    default = "192.168.1.0/24"
}

#subnet1 cidr

variable "subnet1_cidr" {
    description = "CIDR range of subnet 1"
    type = string
    default = "192.168.1.0/26"
}

#subnet1 availability zone 

variable "subnet1_availability_zone" {
    description = "Availability zone for subnet 1 " 
    type = string
    default ="use1-az1"
}

#instance type 

variable "instance_type" {
    description = "type of instance"
    type = string
    default = "t2.micro"
}

#ami of instances

variable "ami_id" {
    description = "ami id of instance"
    type = string
    default = "ami-053b0d53c279acc90"
}