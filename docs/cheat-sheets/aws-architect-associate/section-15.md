
# Data & Analytics

- [Data \& Analytics](#data--analytics)
  - [Amazon Athena](#amazon-athena)
  - [Amazon Redshift](#amazon-redshift)
  - [Amazon OpenSearch Service](#amazon-opensearch-service)
  - [Amazon EMR](#amazon-emr)
  - [Amazon QuickSight](#amazon-quicksight)
  - [AWS Glue](#aws-glue)
  - [AWS Lake Formation](#aws-lake-formation)
  - [Amazon Managed Service for Apache Flink](#amazon-managed-service-for-apache-flink)
  - [Amazon MSK (Managed Streaming for Apache Kafka)](#amazon-msk-managed-streaming-for-apache-kafka)
  - [Serverless Big Data Ingestion Pipeline](#serverless-big-data-ingestion-pipeline)

## Amazon Athena

### What It Is
- 🟢 **Serverless SQL** queries on **S3**
- Built on **Presto**
- No servers, no data movement

### Data & Cost
- Formats: CSV, JSON, **Parquet**, **ORC**
- 💰 Pay **per TB scanned**
- ⭐ Use **Parquet/ORC** to reduce cost

### Use Cases
- Ad-hoc queries, BI, analytics
- Log analysis (VPC, ALB, CloudTrail)
- Dashboards via **QuickSight**

### Performance (Exam Key)
- **Columnar formats** (Parquet/ORC)
- **Partition S3 paths** (`/year=/month=/day=`)
- **Compress data**
- **Large files** (≥128 MB)
- ETL & conversion with **AWS Glue**

### Federated Query
- SQL across **S3 + other sources**
- Uses **Lambda connectors**
- Sources: DynamoDB, RDS, Aurora, Redshift, CloudWatch, on-prem
- Results → **S3**

### Exam Tip 🎯
- *Serverless SQL on S3* → **Athena**

---
## Amazon Redshift

### What It Is
- 🟢 **OLAP data warehouse** (PostgreSQL-based)
- Analytics, BI, aggregations (not OLTP)
- **Columnar storage + parallel queries**
- Scales to **petabytes**

### Deployment Modes
- **Provisioned**: choose node types, RI savings
- **Serverless**: no cluster/node management

### Architecture
- **Leader node**: query planning, result aggregation
- **Compute nodes**: execute queries
- SQL interface, BI tools (QuickSight, Tableau)

### Redshift vs Athena (Exam)
- **Redshift**: faster joins/aggregations, indexed, managed cluster
- **Athena**: serverless, data stays in S3
- 👉 Heavy analytics, frequent queries → **Redshift**

### Snapshots & DR
- Single-AZ (default), **Multi-AZ available**
- **Snapshots**: stored in S3, incremental
- Automated (8h / 5GB) or manual
- **Cross-region snapshot copy** → DR

### Data Ingestion
- **COPY command from S3** (best practice)
- **Kinesis Data Firehose** → S3 → Redshift
- **JDBC insert** (batch only, never row-by-row)
- **Enhanced VPC Routing** → private S3 traffic

### Redshift Spectrum
- Query **S3 data without loading**
- Requires Redshift cluster
- Uses **thousands of Spectrum nodes**
- Results returned to cluster

### Exam Tips 🎯
- Columnar + OLAP → **Redshift**
- Large batch loads → **COPY**
- Query S3 with Redshift power → **Spectrum**

---
## Amazon OpenSearch Service

### What It Is
- 🟢 Managed **search & analytics** engine
- Successor to **Amazon Elasticsearch**
- Full-text, partial-field search (not key-based)

### When to Use
- Add **search** to an app (complement DBs)
- Log analytics & observability
- Near real-time analytics

### Deployment Modes
- **Managed cluster**: provisioned instances
- **Serverless**: auto-scale, no ops

### Queries & Visualization
- Native **OpenSearch DSL** (not SQL)
- SQL support via **plugin**
- Dashboards via **OpenSearch Dashboards**

### Data Ingestion
- **Kinesis Data Firehose**
- **CloudWatch Logs**
- **IoT**
- Custom apps (API)

### Common Architectures (Exam)
- **DynamoDB + OpenSearch**
  - DynamoDB Streams → Lambda → OpenSearch
  - Search in OpenSearch → fetch item from DynamoDB
- **CloudWatch Logs → OpenSearch**
  - Subscription Filter → Lambda (real-time)
  - Subscription Filter → Firehose (near real-time)
- **Kinesis → OpenSearch**
  - Firehose (near real-time)
  - Lambda consumer (real-time)

### Security
- IAM & **Cognito** auth
- Encryption **at rest & in transit**

### Exam Tips 🎯
- Need **full-text / partial search** → OpenSearch
- Not a primary DB → use **with DynamoDB/RDS**
- Logs + search + dashboards → OpenSearch

---
## Amazon EMR

### What It Is
- 🟢 **Big data processing** on AWS
- Managed **Hadoop / Spark** clusters
- Runs on **EC2** (provisioned)

### When to Use
- Massive data processing
- ML, web indexing, analytics
- Hadoop ecosystem workloads

### Built-in Frameworks
- Apache **Spark**
- **Hadoop**
- **HBase**
- **Presto**
- **Flink**

### Cluster Node Types
- **Master node**: cluster management (must run)
- **Core nodes**: tasks + data storage (must run)
- **Task nodes**: tasks only (optional)

### Pricing & Instances (Exam)
- **On-Demand**: predictable workloads
- **Reserved Instances**: cost savings  
  - Best for **Master + Core nodes**
- **Spot Instances**: cheap, interruptible  
  - Best for **Task nodes**

### Scaling & Lifecycle
- **Auto-scaling** supported
- **Long-running clusters** → RI-friendly
- **Transient clusters** → create, process, terminate

### Exam Tips 🎯
- Hadoop / Spark cluster → **EMR**
- Big data tools without setup → **EMR**
- Spot for compute-only → **Task nodes**

---
## Amazon QuickSight

### What It Is
- 🟢 **Serverless BI & dashboards**
- ML-powered, auto-scaled
- Per-session pricing
- Embeddable in apps/websites

### Use Cases
- Business analytics & insights
- Visual ad-hoc analysis
- Reporting & dashboards

### Data Sources (Exam)
- AWS: **Athena**, **Redshift**, **RDS**, Aurora, **S3**
- Analytics: OpenSearch, Timestream
- SaaS: Salesforce, Jira
- On-prem DBs (JDBC)
- Files: CSV, Excel, JSON, TSV, logs

### SPICE Engine ⭐
- In-memory acceleration
- Works **only when data is imported**
- Not used with live DB connections

### Dashboards vs Analysis
- **Analysis**: editable, full exploration
- **Dashboard**: read-only snapshot of analysis
- Share with users / groups after publishing

### Users & Security
- QuickSight-local users (not IAM)
- **Groups + CLS** (column-level security)
  - Enterprise edition only

### Common Exam Patterns 🎯
- Athena → QuickSight (S3 analytics)
- Redshift → QuickSight (data warehouse BI)
- Need dashboards, not querying → **QuickSight**

---
## AWS Glue

### What It Is
- Managed **ETL (Extract, Transform, Load)** service
- Fully **serverless**
- Used to prepare data for analytics

### Core ETL Use Case
- Extract from **S3 / RDS**
- Transform (filter, enrich, clean)
- Load into **Redshift**
- Run by submitting ETL jobs (code-based)

### Common Exam Scenario
- Convert **CSV → Parquet**
  - Parquet = columnar, faster & cheaper for analytics
  - Optimized for **Athena**
- Typical flow:
  - S3 (CSV) → Glue ETL → S3 (Parquet)

### Automation
- Trigger Glue jobs on S3 uploads via:
  - **Lambda** or **EventBridge**

### Glue Data Catalog
- Central metadata store
- Uses **crawlers** to scan:
  - S3, RDS, DynamoDB, JDBC sources
- Stores tables, schemas, data types
- Used by:
  - Glue ETL, **Athena**, Redshift Spectrum, **EMR**

### Additional Glue Features (Exam-Relevant)
- **Job Bookmarks** → avoid reprocessing old data
- **Glue DataBrew** → no-code data cleaning
- **Glue Studio** → GUI for ETL jobs
- **Glue Streaming ETL**
  - Based on Spark Structured Streaming
  - Reads from **Kinesis**, **Kafka / MSK**

### Exam Tips 📝
- Glue = serverless ETL + Data Catalog
- CSV → Parquet → Athena = classic question
- Data Catalog is shared across analytics services


---
## AWS Lake Formation

### What It Is
- 🟢 Fully managed **data lake** service
- Central analytics data store on **Amazon S3**
- Speeds setup (days vs months)

### What It Does
- Discover, ingest, cleanse, transform data
- Automates cataloging & de-duplication
- Uses **ML transforms**
- Built on **AWS Glue** (abstracted)

### Data Sources
- Amazon **S3**
- **RDS / Aurora**
- On-prem SQL & NoSQL
- Blueprints for easy ingestion

### Key Feature ⭐ (Exam Favorite)
- **Centralized fine-grained access control**
  - **Row-level & column-level security**
  - Single place to manage permissions
  - Tag-based Access Control (TBAC)

### Architecture
- Lake Formation layer on top of **Glue**
- Data stored in **S3**
- Glue provides crawlers, ETL, catalog
- Security enforced by Lake Formation

### Analytics Integrations
- **Athena**
- **Redshift**
- **EMR**
- Spark & other analytics tools

### Why Use It (Exam)
- Avoid managing security in:
  - S3, Athena, QuickSight, RDS separately
- One permission model for all analytics

### Exam Tips 🎯
- Central data lake + fine-grained security → **Lake Formation**
- Multiple analytics tools, shared data → **Lake Formation**
- Row/column access across services → **Lake Formation**

---
## Amazon Managed Service for Apache Flink

### What It Is
- 🟢 Managed **real-time stream processing**
- Runs **Apache Flink** apps (Java, Scala, SQL)
- Formerly **Kinesis Data Analytics for Flink**

### When to Use
- Real-time stream transformations
- Stateful stream processing
- Complex event processing

### Data Sources
- **Kinesis Data Streams**
- **Amazon MSK (Kafka)**
- ❌ **Not Firehose** (exam trap)

### Key Features
- Fully managed compute & scaling
- Parallel processing
- **Checkpoints & snapshots** (backups)
- Flink dashboard for monitoring

### Application Types
- **Streaming applications** (Flink runtime)
- **Studio notebooks** (interactive analysis)
- Legacy **SQL apps** (Firehose-compatible)

### Exam Tips 🎯
- Real-time stream processing → **Flink**
- Needs complex transformations → **Flink**
- Kinesis Streams / Kafka input → **Flink**
- Firehose input → ❌ Flink (use SQL legacy)

---
## Amazon MSK (Managed Streaming for Apache Kafka)

### What It Is
- 🟢 Fully managed **Apache Kafka** on AWS
- Real-time **data streaming**
- Handles **brokers + Zookeeper**
- Deploy in **VPC**, multi-AZ (up to 3) for HA
- Data stored on **EBS** indefinitely

### Deployment Modes
- **Provisioned**: manage brokers
- **Serverless**: auto-scale compute & storage, no capacity management

### Kafka Basics
- **Producers** → Kafka **Topics** → **Consumers**
- Topics replicated across brokers
- Streams consumed for processing/storage (EMR, S3, SageMaker, RDS, Kinesis)

### Comparison with Kinesis
- Message size: 1 MB default (MSK configurable)
- Shards (Kinesis) ↔ Partitions (Kafka)
- Scaling: Kinesis (shard split/merge), MSK (add partitions only)
- Encryption: in-flight TLS/plaintext, at-rest both
- Retention: MSK unlimited (pay EBS)

### Consumption Patterns
- **Flink** app (Kinesis Data Analytics)
- **Glue Streaming ETL**
- **Lambda** event source
- Custom **Kafka consumer** (EC2, ECS, EKS)

### Exam Tips 🎯
- Managed Kafka → **MSK**
- Stream ingestion → **Producers → Topics → Consumers**
- Flink reads from MSK for real-time analytics
- Serverless MSK → auto-scaling without capacity planning

---
## Serverless Big Data Ingestion Pipeline

### Overview
- Real-time **data ingestion → transformation → query → visualization**
- Fully serverless & AWS-managed

### Pipeline Components
- **IoT Core** → collects data from IoT devices
- **Kinesis Data Streams** → real-time streaming
- **Kinesis Data Firehose** → near real-time delivery to **S3**
- **Lambda** → optional transformation / cleansing
- **S3** → ingestion & reporting buckets
- **SQS** → optional event queue for Lambda triggers
- **Athena** → serverless SQL querying on S3
- **QuickSight** → visualization dashboards
- **Redshift** → data warehouse for analytics

### Flow (Exam Key)
1. IoT devices → **IoT Core**
2. IoT Core → **Kinesis Data Stream**
3. Stream → **Firehose** → **S3 ingestion bucket**
4. Optional **Lambda** → transform data
5. S3 → trigger **SQS/Lambda**
6. Lambda → **Athena SQL** → **S3 reporting bucket**
7. QuickSight / Redshift → dashboards & analytics

### Exam Tips 🎯
- Serverless pipeline → **IoT Core + Kinesis + Firehose + Lambda + Athena**
- S3 for **raw + reporting data**
- Visualization → **QuickSight**; analytics → **Redshift**
- Use **Lambda** for real-time transformation
