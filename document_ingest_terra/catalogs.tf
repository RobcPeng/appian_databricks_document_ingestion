resource "databricks_catalog" "catalog" {
    name = "${var.environment}_appian_poc"
    comment ="${var.environment} environment"
    storage_root = var.external_storage_location

    properties = {
        environment = var.environment
        managed_by = "terraform"
    }
}