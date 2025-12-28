
# Data & Analytics

- [Data \& Analytics](#data--analytics)
  - [Overview](#overview)
  - [Amazon RDS](#amazon-rds)
  - [Amazon ElastiCache](#amazon-elasticache)
  - [Amazon DynamoDB](#amazon-dynamodb)
  - [Amazon S3 (DB View)](#amazon-s3-db-view)
  - [Amazon DocumentDB](#amazon-documentdb)
  - [Amazon Keyspaces](#amazon-keyspaces)
  - [Amazon Timestream](#amazon-timestream)

## Overview

### Selection Clues 🎯
- SQL + joins → Relational
- Scale + low latency → NoSQL
- Analytics → OLAP
- Search / relationships / time → Specialized DB

### Relational (OLTP)
- **RDS**: Managed SQL engines
- **Aurora**: Cloud-native, high performance
- Use: transactions, strong schema, joins

### NoSQL
- **DynamoDB**: Key-value, serverless scale
- **ElastiCache**: In-memory cache
- **DocumentDB**: JSON docs
- **Keyspaces**: Cassandra
- Use: flexible schema, no joins

### Object Storage
- **S3**: Objects, files
- **Glacier**: Archives

### Analytics (OLAP)
- **Redshift**: Data warehouse
- **Athena**: SQL on S3
- **EMR**: Big data processing

### Specialized
- **OpenSearch**: Full-text search
- **Neptune**: Graph relationships
- **QLDB**: Immutable ledger
- **Timestream**: Time-series data

### Exam Tips 💡
- Joins? → RDS/Aurora  
- Massive scale? → DynamoDB  
- BI/Reporting? → Redshift  
- Search ≠ DB → OpenSearch  
- Files ≠ DB → S3

---
## Amazon RDS

### Core
- Managed **Relational DB (OLTP)**
- Engines: MySQL, PostgreSQL, MariaDB, Oracle, SQL Server, DB2
- **Provisioned**: instance type + EBS (storage auto-scales)

### Scaling & Availability
- **Read Replicas** 📖: scale reads, analytics, async
- **Multi-AZ** 🛡️: HA + failover only (no reads)

### Security
- **Auth**: username/password, **IAM auth** (some engines)
- **Network**: Security Groups
- **Encryption**: KMS (at rest), SSL/TLS (in transit)
- **RDS Proxy**: IAM auth + Secrets Manager integration

### Backups
- **Automated backups**: up to 35 days → **PITR**
- **Manual snapshots**: long-term retention
- Restore = **new DB instance**

### Operations
- Managed maintenance & patching (downtime possible)
- No OS access (except **RDS Custom**)

### RDS Custom
- OS / DB access
- Supported: **Oracle, SQL Server**

### Use Cases 🎯
- SQL queries, joins, transactions
- Traditional relational workloads

### Exam Tips 💡
- HA ≠ scaling → Multi-AZ
- Reads scaling → Read Replicas
- Analytics on prod DB → Read Replica
- Need OS access → RDS Custom

---
## Amazon ElastiCache

### Core
- Managed **in-memory cache**
- Engines: **Redis**, **Memcached**
- **Sub-ms latency** ⚡
- Must **provision instance type**

### Redis Features
- **Clustering & sharding**
- **Read Replicas**
- **Multi-AZ**
- **Redis AUTH**
- Backups, snapshots, **PITR**

### Security
- **Security Groups**
- **IAM** (service integration)
- **KMS** encryption at rest

### Operations
- Managed patching & maintenance
- No SQL support ❌

### Use Cases 🎯
- Cache DB queries (reduce RDS load)
- Key/Value access
- User **session storage**

### Exam-Critical Rule 🚨
- **App code change required**
- If caching **without code change** → ❌ ElastiCache

### Exam Tips 💡
- RDS + cache → ElastiCache
- Fast reads, transient data → Redis
- SQL queries needed → not ElastiCache

---
## Amazon DynamoDB

### Core
- **Serverless NoSQL (key-value)**
- **Single-digit ms latency**
- Fully **managed & multi-AZ**
- Flexible schema

### Capacity Modes
- **Provisioned** (+ auto scaling): predictable traffic
- **On-Demand** ⚡: unpredictable / spiky traffic

### Features
- **Transactions** supported
- **TTL**: auto-expire items
- **DAX** 🚀: in-memory cache → **microsecond reads**
- Reads & writes fully decoupled

### Security
- **IAM-only** auth & authorization

### Integrations
- **DynamoDB Streams** → Lambda (per-item change)
- **Kinesis Data Streams** → Firehose, long retention (≤1 year)

### Global & HA
- **Global Tables** 🌍: active-active, multi-region writes

### Backups
- **PITR**: up to **35 days** → new table
- **On-demand backups**: long-term
- **Export/Import S3**: no RCUs/WCUs used

### Use Cases 🎯
- Serverless apps
- Key/Value access
- Session storage (TTL)
- Rapid schema evolution
- Distributed cache alternative

### Exam Tips 💡
- Spiky traffic → On-Demand
- Microsecond reads → DAX
- Multi-region active-active → Global Tables
- No SQL / joins → DynamoDB
- Small items (< few 100 KB) → DynamoDB

---
## Amazon S3 (DB View)

### Core
- **Object (key-value) storage**
- **Serverless, infinite scale**
- Max object: **5 TB**
- Best for **large objects** (not many small ones)

### Storage Classes
- **Standard**, **Intelligent-Tiering**
- **Infrequent Access**
- **Glacier** (archive)
- **Lifecycle rules** → tier transitions

### Key Features
- **Versioning**
- **Replication** (CRR / SRR)
- **MFA Delete**
- **Access Logs**
- **Object Lock / Glacier Vault Lock** (WORM)

### Security
- **IAM**, **Bucket Policies**
- **ACLs**, **Access Points**
- **CORS**
- **Object Lambda** (modify objects on read)

### Encryption
- **SSE-S3**
- **SSE-KMS** 🔐
- **SSE-C**
- **Client-side encryption**
- **TLS in transit**
- Default encryption supported

### Performance
- **Multipart Upload**
- **Transfer Acceleration**
- **S3 Select** (query partial data)

### Automation
- **Event Notifications** → SNS, SQS, Lambda, EventBridge
- **S3 Batch Operations**
- **S3 Inventory**

### Use Cases 🎯
- Static assets, backups, data lakes
- Large binary objects
- Website hosting

### Exam Tips 💡
- Not a relational DB ❌
- Big objects → S3
- Archive + compliance → Glacier + Object Lock
- Encrypt existing objects → Batch Ops
- Event-driven workflows → S3 Events

---
## Amazon DocumentDB

### Core
- **NoSQL document database**
- **MongoDB-compatible API**
- JSON documents (query & index)

### Architecture
- Fully **managed**
- **Highly available**
- Data replicated across **3 AZs**
- Storage **auto-scales** (+10 GB increments)
- Designed for **millions of req/s**

### Positioning
- “**Aurora for MongoDB**”
- Similar deployment model to Aurora

### Use Cases 🎯
- MongoDB workloads
- Document / JSON-based apps
- Flexible schema, NoSQL access

### Exam Tips 💡
- MongoDB mentioned → **DocumentDB**
- JSON documents + NoSQL → DocumentDB
- Key-value only → DynamoDB
- SQL / joins → RDS / Aurora

---
## Amazon Keyspaces

### Core
- **Managed Apache Cassandra**
- **Serverless, fully managed**
- NoSQL, wide-column store
- Uses **CQL** (Cassandra Query Language)

### Architecture
- Auto-scales tables up/down
- Data replicated **3× across AZs**
- **Single-digit ms latency**
- Thousands of req/s at scale

### Capacity Modes
- **On-Demand** ⚡: unpredictable traffic
- **Provisioned + Auto Scaling**: steady traffic

### Security & Backup
- Encryption at rest
- **PITR** up to **35 days**
- Managed backups

### Use Cases 🎯
- IoT device data
- Time-series workloads
- Large-scale distributed NoSQL

### Exam Tips 💡
- Apache Cassandra → **Amazon Keyspaces**
- Wide-column NoSQL → Keyspaces
- SQL / joins needed → ❌
- Similar scaling model to DynamoDB

---
## Amazon Timestream

### Core
- **Serverless time-series DB**
- Fully managed, fast, scalable
- Stores **events with timestamps**
- SQL-compatible

### Architecture
- Auto-scales for trillions of events/day
- **Recent data** → in-memory
- **Historical data** → cost-optimized storage
- Time-series analytics functions built-in

### Integrations
- Data sources: **AWS IoT**, **Kinesis**, **Prometheus**, **Telegraf**, **MSK**
- Analytics & dashboards: **QuickSight**, **Grafana**, **SageMaker**, JDBC/SQL apps

### Security
- Encryption **at rest & in transit**

### Use Cases 🎯
- IoT data
- Operational monitoring
- Real-time analytics
- Any time-series dataset

### Exam Tips 💡
- Time + value → **Timestream**
- SQL-compatible → queries & dashboards
- Use for trillions of events/day
- Not for relational OLTP ❌
