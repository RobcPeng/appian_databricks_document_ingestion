resource "databricks_schema" "bronze" {
    catalog_name = databricks_catalog.catalog.name
    name         = "00_bronze"
    comment      = "Raw data layer"
  
    properties = {
        layer = "bronze"
    }
    
}

resource "databricks_schema" "silver" {
    catalog_name = databricks_catalog.catalog.name
    name         = "01_silver"
    comment      = "Raw data layer"
  
    properties = {
        layer = "silver"
    }
    
}


resource "databricks_schema" "gold" {
    catalog_name = databricks_catalog.catalog.name
    name         = "02_gold"
    comment      = "Raw data layer"
  
    properties = {
        layer = "gold"
    }
    
}