terraform {
  backend "s3" {
    bucket         = "heet-s3-bucket" 
    key            = "spring-boot-project/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "launchpad-table" 
  }
}