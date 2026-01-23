# from pyspark import pipelines as dp
# from pyspark.sql.functions import col, expr


# @dp.table(name="documents_content_transform", comment="Binary documents with metadata")
# def documents_content_transform():
#     return (
#         spark.readStream.format("delta")
#         .table("dev_appian_poc.00_bronze.appian_raw_documents_ingest")
#         .withColumn("parsed_document", expr("ai_parse_document(content)"))
#         .select(
#             col("parsed_document"),
#             col("path"),
#             col("modificationTime").alias("updatedTime"),
#         )
#     )
