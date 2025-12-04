🛍️ Retail ELT Pipeline

Event-driven data platform for retail analytics on Google Cloud Platform

🏗️ Architecture


┌─────────────────────────────────────────────────────────────┐
│                         DATA FLOW                           │
└─────────────────────────────────────────────────────────────┘

1. Upload CSV → GCS Bucket
2. GCS → Pub/Sub Topic (automatic notification)
3. Pub/Sub → Cloud Workflows (Eventarc trigger)
4. Workflows → BigQuery (load raw data)
5. Workflows → Cloud Run (trigger dbt API)
6. Cloud Run → dbt transformations → BigQuery (analytics tables)

┌─────────────────────────────────────────────────────────────┐
│                         CI/CD FLOW                          │
└─────────────────────────────────────────────────────────────┘

1. Git Push → GitHub
2. GitHub → Cloud Build (trigger)
3. Cloud Build → Docker Build → Container Registry
4. Cloud Build → Deploy to Cloud Run


🛠️ Tech Stack

# Infrastructure: Terraform
# Storage: Cloud Storage, BigQuery
# Orchestration: Cloud Workflows, Eventarc, Pub/Sub
# Transformation: dbt
# Compute: Cloud Run
# CI/CD: Cloud Build synchronized with Github
