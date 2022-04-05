provider "aws" { profile = "default" }

resource "aws_vpc" "Main" {                
   cidr_block       = "10.0.0.0/16"     
   instance_tenancy = "default"
   tags = {
      Name = "Main"
     }
 }
 
 resource "aws_internet_gateway" "IGW" {    
    vpc_id =  aws_vpc.Main.id 
    tags = {
       Name = "IGW"
      }
 }
 
 resource "aws_subnet" "publicsubnets" {    
   vpc_id =  aws_vpc.Main.id
   cidr_block = "10.0.1.0/24"

   availability_zone = "us-east-1a"
   tags = {
      Name = "publicsubnets"
     }
 }
                   
 resource "aws_subnet" "privatesubnets" {
   vpc_id =  aws_vpc.Main.id
   cidr_block = "10.0.2.0/24"
   availability_zone = "us-east-1b"
   tags = {
      Name = "privatesubnets"
     }
 }
 
 resource "aws_route_table" "PublicRT" {    
    vpc_id =  aws_vpc.Main.id
    tags = {
       Name = "PublicRT"
      }
         route {
    cidr_block = "0.0.0.0/0"               
    gateway_id = aws_internet_gateway.IGW.id
    }
 }
 
 resource "aws_route_table" "PrivateRT" {    
   vpc_id = aws_vpc.Main.id
   tags = { 
      Name = "PrivateRT"
    }
        route {
   cidr_block = "0.0.0.0/0"             
   nat_gateway_id = aws_nat_gateway.NATgw.id
   }
 }
 
 resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id = aws_subnet.publicsubnets.id
    route_table_id = aws_route_table.PublicRT.id
 }
 
 resource "aws_route_table_association" "PrivateRTassociation" {
    subnet_id = aws_subnet.privatesubnets.id
    route_table_id = aws_route_table.PrivateRT.id
 }
 resource "aws_eip" "nateIP" {
   vpc   = true
 }
 
 resource "aws_nat_gateway" "NATgw" {
   allocation_id = aws_eip.nateIP.id
   subnet_id = aws_subnet.publicsubnets.id
   tags = {
      Name = "NATgw"
     }
 }
