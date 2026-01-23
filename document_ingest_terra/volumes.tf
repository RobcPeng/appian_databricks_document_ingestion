resource "databricks_volume" "landing_zone" {
  catalog_name = databricks_catalog.catalog.name
  schema_name  = databricks_schema.bronze.name
  name         = "landing_zone"
  volume_type  = "MANAGED"
  comment      = "Volume for raw data ingestion"
}