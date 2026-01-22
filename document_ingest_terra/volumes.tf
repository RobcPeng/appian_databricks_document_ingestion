resource "databricks_volume" "loading_zone" {
  catalog_name = databricks_catalog.catalog.name
  schema_name  = databricks_schema.bronze.name
  name         = "loading_zone"
  volume_type  = "MANAGED"
  comment      = "Volume for raw data ingestion"
}