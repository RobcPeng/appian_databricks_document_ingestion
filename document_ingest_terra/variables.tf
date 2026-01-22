variable "databricks_profile" {
    description = "Authentication Profile"
    type = string
    sensitive = true
}

variable "databricks_host" {
    type = string
    sensitive = true
}

variable "environment" {
    description = "dev, stage, prod"
    type = string
    sensitive = true
} 

variable "project_name" {
    type = string
}


variable "external_storage_location" {
    type = string
    sensitive = true
}