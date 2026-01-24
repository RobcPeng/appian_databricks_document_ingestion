from pyspark import pipelines as dp
from pyspark.sql.functions import col


@dp.table(
    name="document_text_contents",
    comment="document extraction",
    table_properties={"quality": "gold", "layer": "gold"},
)
def document_text_contents():
    return spark.sql(
        """
  WITH CTE AS (SELECT 
      path,
      transform(CAST(parsed_document:document:elements as ARRAY<VARIANT>), x -> CASE 
            WHEN x:content IS NOT NULL AND x:content::string != '' AND x:content::string != 'null'
            THEN x:content::string 
            ELSE NULL 
          END) as text
      FROM dev_appian_poc.`01_silver`.parsed_documents)
  SELECT
    row_number() OVER (ORDER BY c.path) as row_num,
    c.path,
    c.text,
    concat_ws(" ",c.text) as full_text
  FROM cte c
  """
    )