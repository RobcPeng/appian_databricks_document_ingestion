# Value Considerations

## Scalability - Consumption Based Cost and Auto Scaling!

Serverless compute: Auto-scales based on workload
Concurrent processing: Handles multiple file uploads simultaneously
Storage optimization: Delta Lake format with Z-order optimization

## Security & Governance - Less Surfaces to worry about! PII Automation!

Identity-based access: Service principal authentication
Fine-grained permissions: Unity Catalog access controls
Data lineage: Complete audit trail from raw files to embeddings
Compliance: SOC2, GDPR-ready with proper configuration

## Cost Optimization

Serverless pricing: Pay only for compute used
Intelligent caching: Delta Lake caching for repeated queries
Lifecycle management: Automated data retention policies

# Appian Document Ingestion Platform - [AI Generated Documentation]

A production-ready AI-powered document processing system designed for enterprise content management. This platform leverages Databricks' serverless compute and Unity Catalog to create a scalable, secure, and intelligent document ingestion pipeline with vector search capabilities.

## 🏗️ Architecture

### Data Flow Architecture

```
📁 File Upload → 🥉 Bronze (Raw) → 🥈 Silver (Parsed) → 🥇 Gold (Embeddings)
                      ↓              ↓                ↓
                 Raw Storage     AI Processing    Vector Search
```

### Technology Stack

- **Infrastructure**: Terraform (IaC) + Databricks Unity Catalog
- **Compute**: Databricks Serverless (Delta Live Tables)
- **AI/ML**: Native Databricks AI functions (`ai_parse_document`) + BGE-large-EN embeddings
- **Storage**: AWS S3 with Unity Catalog Volumes
- **Orchestration**: File-triggered workflows with multi-task job dependencies

### Medallion Architecture Layers

| Layer      | Purpose                      | Tables                                                  | Technology              |
| ---------- | ---------------------------- | ------------------------------------------------------- | ----------------------- |
| **Bronze** | Raw file ingestion           | `appian_raw_documents_ingest`                           | CloudFiles auto-loader  |
| **Silver** | AI document parsing          | `parsed_documents`                                      | Databricks AI functions |
| **Gold**   | Text extraction & embeddings | `document_text_contents`<br>`ingestion_text_embeddings` | BGE-large-EN model      |

## 🚀 Quick Start

### Prerequisites

- AWS account with S3 access
- Databricks workspace (Unity Catalog enabled)
- Terraform ≥ 1.1.5
- Databricks CLI

### Installation

**Step 1: Infrastructure Deployment**

```bash
cd document_ingest_terra

# Configure your environment
cat > terraform.tfvars << EOF
databricks_profile = "your-profile"
databricks_host = "https://your-workspace.cloud.databricks.com"
environment = "dev"
project_name = "appian-document-processing"
external_storage_location = "s3://your-bucket/path/"
service_principal_application_id = "your-app-id"
EOF

# Deploy infrastructure
terraform init
terraform apply
```

**Step 2: Application Deployment**

```bash
cd document_ingest_poc

# Deploy pipelines and jobs
databricks bundle deploy --target dev
```

**Step 3: Capture Service Principal Credentials**

```bash
# ⚠️ IMPORTANT: Save these securely
terraform output service_principal_application_id
terraform output service_principal_secret
```

## 📊 Usage Guide

### Document Processing Workflow

1. **Upload Documents**

   ```bash
   # Upload to landing zone
   aws s3 cp documents/ s3://your-bucket/volumes/landing_zone/file_uploads/ --recursive
   ```

   **Supported Formats:** PDF, DOCX, XLSX, PNG, JPG

2. **Automatic Processing** (File arrival triggers)
   - Raw ingestion → AI parsing → Text extraction → Vector embeddings
   - Monitor progress in Databricks Jobs UI

3. **Query Processed Data**

   ```sql
   -- 🥉 Raw documents (Bronze)
   SELECT path, length(content) as file_size, modificationTime
   FROM dev_appian_poc.00_bronze.appian_raw_documents_ingest;

   -- 🥈 AI-parsed content (Silver)
   SELECT path, parsed_document:document:elements[0]:content::string as excerpt
   FROM dev_appian_poc.01_silver.parsed_documents;

   -- 🥇 Searchable text (Gold)
   SELECT doc_id, path, left(full_text, 200) as preview
   FROM dev_appian_poc.02_gold.document_text_contents;

   -- 🔍 Vector embeddings for semantic search
   SELECT doc_id, path, chunk_text, array_size(embedded) as embedding_dim
   FROM dev_appian_poc.02_gold.ingestion_text_embeddings;
   ```

### Security Configuration

```hcl
# Service Principal Permissions (Terraform)
resource "databricks_grants" "catalog_permissions" {
  catalog = databricks_catalog.catalog.name
  grant {
    principal  = databricks_service_principal.sp.application_id
    privileges = ["USE_CATALOG", "CREATE_SCHEMA", "CREATE_TABLE"]
  }
}
```

## 🔧 Operations & Monitoring

### Health Checks

```sql
-- Data freshness check
SELECT
  MAX(modificationTime) as latest_file,
  COUNT(*) as total_files,
  COUNT(DISTINCT path) as unique_files
FROM dev_appian_poc.00_bronze.appian_raw_documents_ingest;

-- Processing pipeline status
SELECT
  COUNT(*) as bronze_count,
  (SELECT COUNT(*) FROM dev_appian_poc.01_silver.parsed_documents) as silver_count,
  (SELECT COUNT(*) FROM dev_appian_poc.02_gold.document_text_contents) as gold_count;
```

### Performance Monitoring

- **Job Execution**: Databricks Jobs UI → `run_document_ingestion`
- **Pipeline Health**: Delta Live Tables → Pipeline metrics
- **Data Quality**: Unity Catalog → Lineage & Data Quality monitors

### Environment Promotion

```bash
# Deploy to staging
databricks bundle deploy --target staging

# Deploy to production
databricks bundle deploy --target prod
```

## 📁 Project Structure

```
📦 appian-document-processing/
├── 🏗️ document_ingest_terra/          # Infrastructure as Code
│   ├── catalogs.tf                    # Unity Catalog setup
│   ├── schemas.tf                     # Database schemas (bronze/silver/gold)
│   ├── volumes.tf                     # Storage volumes
│   ├── service_principal.tf           # Authentication & permissions
│   └── variables.tf                   # Configuration parameters
├── 🔄 document_ingest_poc/            # Application Code
│   ├── src/
│   │   ├── ai_pipelines/              # 🤖 AI processing & embeddings
│   │   ├── document_ingest_poc_etl/   # 🥉 Bronze layer pipeline
│   │   ├── document_transformations_silver/  # 🥈 AI parsing pipeline
│   │   └── document_transformations_gold/    # 🥇 Text extraction pipeline
│   ├── resources/                     # 📋 Pipeline & job definitions
│   ├── tests/                         # 🧪 Test suites
│   └── databricks.yml                # 📝 Bundle configuration
└── 📖 README.md                      # This documentation
```
