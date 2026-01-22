terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
    }
  }
}

provider "databricks" {
    profile = var.databricks_profile
}