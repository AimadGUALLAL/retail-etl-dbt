# 🛍️ Retail ELT Pipeline

> **Event-driven data platform for retail analytics on Google Cloud Platform**

## 🏗️ Architecture
```
┌─────────────────────────────────────────────────────────────────────────┐
│                          DATA INGESTION LAYER                           │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  📁 CSV Files (invoices, countries)                                     │
│           │                                                             │
│           ▼                                                             │
│  ☁️  Cloud Storage Bucket                                               │
│  └─ Lifecycle: 30 days retention                                        │
│           │                                                             │
│           │ (Storage Notification: OBJECT_FINALIZE)                     │
│           ▼                                                             │
│  📢 Pub/Sub Topic                                                       │
│                                                                         │
└───────────────────────────┬─────────────────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────────────────┐
│                       ORCHESTRATION LAYER                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ⚡ Eventarc Trigger                                                     │
│           │                                                             │
│           ▼                                                             │
│  🔄 Cloud Workflows                                                     │
│  ├─ Decode Pub/Sub message                                             │
│  ├─ Validate file type (.csv)                                          │
│  ├─ Route by pattern (invoice/country)                                 │
│  ├─ Load to BigQuery (WRITE_APPEND)                                    │
│  └─ Trigger dbt API                                                    │
│           │                                                             │
│           ▼                                                             │
│  🐳 Cloud Run (dbt Service)                                             │
│                                                                         │
└───────────────────────────┬─────────────────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────────────────┐
│                       DATA WAREHOUSE LAYER                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  📊 BigQuery Dataset                                                    │
│                                                                         │
│  ┌───────────────────────────────────────┐                            │
│  │ RAW LAYER (STRING columns)            │                            │
│  ├───────────────────────────────────────┤                            │
│  │ • raw_invoice                          │                            │
│  │ • raw_country                          │                            │
│  └───────────────────────────────────────┘                            │
│           │ (dbt transformations)                                       │
│           ▼                                                             │
│  ┌───────────────────────────────────────┐                            │
│  │ STAGING LAYER (Typed & Cleaned)       │                            │
│  ├───────────────────────────────────────┤                            │
│  │ • stg_invoice (CAST, PARSE_DATE)      │                            │
│  │ • stg_country (Validated)             │                            │
│  └───────────────────────────────────────┘                            │
│           │                                                             │
│           ▼                                                             │
│  ┌───────────────────────────────────────┐                            │
│  │ MARTS LAYER (Business Logic)          │                            │
│  ├───────────────────────────────────────┤                            │
│  │ • fct_sales (Star schema)             │                            │
│  │ • dim_customer, dim_product           │                            │
│  └───────────────────────────────────────┘                            │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## 🔄 Data Flow
```
1. Upload CSV → GCS Bucket
2. GCS → Pub/Sub Topic (automatic notification)
3. Pub/Sub → Cloud Workflows (Eventarc trigger)
4. Workflows → BigQuery (load raw data)
5. Workflows → Cloud Run (trigger dbt API)
6. Cloud Run → dbt transformations → BigQuery (analytics tables)
```

## 🚀 CI/CD Pipeline
```
1. Git Push → GitHub
2. GitHub → Cloud Build (trigger)
3. Cloud Build → Docker Build → Container Registry
4. Cloud Build → Deploy to Cloud Run
```

## 🛠️ Tech Stack

- **Infrastructure**: Terraform
- **Storage**: Cloud Storage, BigQuery
- **Orchestration**: Cloud Workflows, Eventarc, Pub/Sub
- **Transformation**: dbt
- **Compute**: Cloud Run
- **CI/CD**: Cloud Build


```

## 🚀 Quick Start
```bash
# 1. Set up GCP
export PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# 2. Deploy infrastructure
cd infra
terraform init
terraform apply

# 3. Upload data
gsutil cp data/invoice_sample.csv gs://your-bucket/

# 4. Monitor
gcloud workflows executions list data-ingestion-workflow --location=europe-west1
```

## ✨ Key Features

- **Event-driven**: Automatic processing on file upload
- **Scalable**: Serverless architecture
- **Tested**: dbt tests for data quality
- **IaC**: Fully reproducible with Terraform
- **Secure**: IAM best practices, OIDC auth

## 📊 Usage
```bash
# Query raw data
bq query 'SELECT * FROM retail_dataset.raw_invoice LIMIT 10'

# Query transformed data
bq query 'SELECT * FROM retail_dataset.fct_sales LIMIT 10'

# Run dbt manually
cd dbt && dbt run && dbt test
```

---

**Built with GCP | Powered by dbt | Managed by Terraform**
