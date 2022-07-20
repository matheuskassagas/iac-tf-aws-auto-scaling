locals {
  subnet_ids = { for k, v in aws_subnet.this : v.tags.Name => v.id }
  
  common_tags = {
    Project   = "Curso AWS com Terraform"
    Service   = "Static Website"
    CreatedAt = "2022-07-07"
    Module    = "App-AutoScaling"
  }
}