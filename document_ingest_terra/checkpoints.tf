resource "databricks_volume" "checkpoints" {
  catalog_name = databricks_catalog.catalog.name
  schema_name  = databricks_schema.bronze.name
  name         = "checkpoints"
  volume_type  = "MANAGED"
  comment      = "Volume for checkpoints"
}