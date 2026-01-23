resource "databricks_service_principal" "service_principal_application_id" {
  display_name = "appian_document_service_principal"
}

resource "databricks_service_principal_secret" "service_principal_secret_secret" {
  service_principal_id = databricks_service_principal.service_principal_application_id.id
}

resource "databricks_grants" "catalog_use" {
  catalog = databricks_catalog.catalog.name

  grant {
    principal  = databricks_service_principal.service_principal_application_id.application_id
    privileges = ["USE_CATALOG"]
  }
}

resource "databricks_grants" "schema_bronze_use" {
  schema = "${databricks_catalog.catalog.name}.${databricks_schema.bronze.name}"

  grant {
    principal  = databricks_service_principal.service_principal_application_id.application_id
    privileges = ["USE_SCHEMA"]
  }
}

resource "databricks_grants" "volume_bronze" {
  volume = "${databricks_catalog.catalog.name}.${databricks_schema.bronze.name}.landing_zone"

  grant {
    principal  = databricks_service_principal.service_principal_application_id.application_id
    privileges = ["READ_VOLUME", "WRITE_VOLUME"]
  }
}

# Output the service principal details
output "service_principal_application_id" {
  value       = databricks_service_principal.service_principal_application_id.application_id
  description = "Application ID for the document uploader service principal"
}

output "service_principal_secret" {
  value       = databricks_service_principal_secret.service_principal_secret_secret.secret
  description = "Secret for the service principal (save this securely)"
  sensitive   = true
}