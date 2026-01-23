from pyspark import pipelines as dp
from pyspark.sql.functions import col


@dp.table(name="appian_raw_documents_ingest", comment="Binary documents with metadata")
def appian_raw_document_ingest():
    return (
        spark.readStream.format("cloudFiles")
        .option("cloudFiles.format", "binaryFile")
        .option("pathGlobFilter", "*{pdf,docx,xlsx,png,jpg}")
        .option("cloudFiles.schemaLocation", "/Volumes/dev_appian_poc/00_bronze/checkpoints/raw_ingest_schema")
        .load("/Volumes/dev_appian_poc/00_bronze/landing_zone/file_uploads/")
    )
