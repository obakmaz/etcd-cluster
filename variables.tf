variable "region" {
  default = "us-west1"
}

variable "region_zone" {
  default = "us-west1-c"
}

variable "project_name" {
  default = "ozal-sandbox"
  description = "The ID of the Google Cloud project"
}

variable "machine_type" {
  default = "f1-micro"
}

variable "os_image" {
  default = "centos-7-v20191210"
}

variable "credentials_file_path" {
  description = "Path to the JSON file used to describe your account credentials"
  #default     = "~/.gcloud/Terraform.json"
  default = "~/Documents/gitlab/ozal-sandbox-978b7c893353.json"
}

variable "public_key_path" {
  description = "Path to file containing public key"
  #default     = "~/.ssh/gcloud_id_rsa.pub"
  default     = "~/.ssh/terraform.pub"
  
}

variable "private_key_path" {
  description = "Path to file containing private key"
  #default     = "~/.ssh/gcloud_id_rsa"
  default     = "~/.ssh/terraform"
  
}

