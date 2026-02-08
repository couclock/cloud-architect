# Amazon S3 Fundamentals

- [Amazon S3 Fundamentals](#amazon-s3-fundamentals)
  - [Amazon S3 Overview](#amazon-s3-overview)
  - [Amazon S3 Security](#amazon-s3-security)
  - [Static Website Hosting](#static-website-hosting)
  - [Versioning](#versioning)
  - [Replication](#replication)
  - [Storage Classes](#storage-classes)
  - [S3 Express One Zone](#s3-express-one-zone)

---
## Amazon S3 Overview

### What It Is
- 🔹 Object storage, infinitely scalable
- Used for backup, DR, archival, static hosting, data lakes, analytics
- Stores files as **objects** inside **buckets**

### Buckets
- Must have **globally unique names**
- Defined **per region**
- Naming rules: 3–63 chars, lowercase letters/numbers/hyphens, not IP
- Settings:
  - Block public access ✅
  - Default encryption (SSE-S3) ✅
  - Versioning optional

### Objects
- Object = file + metadata + tags + optional version ID
- Max size 5 TB → multipart upload if >5 GB
- Key = full path (prefix + object name)
- No real folders; UI simulates directories

### Operations
- Upload / download / delete objects
- Create folders (prefixes)
- Pre-signed URLs allow temporary private access
- Public URL = blocked unless explicitly allowed

### Best Practices / Exam Tips
- Use buckets per region
- Enable encryption & block public access
- Pre-signed URLs for secure access
- S3 is backbone for many AWS services
- Think: **buckets = top-level container, objects = files**

---
## Amazon S3 Security

### User-Based Security
- IAM policies control which **API calls** a user can make
- IAM roles used for **EC2 access** to S3

### Resource-Based Security
- **Bucket Policies**: JSON rules applied directly on bucket
  - Grant cross-account access
  - Make bucket public
  - Enforce encryption
- **Object ACLs**: finer-grain, can be disabled
- **Bucket ACLs**: less common, can be disabled

### Access Logic
- IAM user/role can access S3 if:
  - Permissions **allow**
  - Bucket policy **allows**
  - No explicit **deny** exists

### Public Access
- Block Public Access settings prevent accidental data leaks
- Must disable for true public bucket
- Use **Policy Generator** to create public getObject policy
  - Principal: "*"
  - Action: "s3:GetObject"
  - Resource: bucket ARN + "/*"

### Encryption
- Use **SSE-S3** (default) or KMS for object encryption
- Bucket policies can enforce encryption at upload

### Cross-Account Access
- Use bucket policy to allow IAM user from another account
- Useful for sharing objects securely

### Exam Tips
- Prefer **bucket policies** over ACLs
- Block public access unless explicitly needed
- IAM roles for EC2, IAM users for humans
- Pre-signed URLs = temporary private access

---
## Static Website Hosting

### What It Is
- 🌐 Host **static websites** (HTML, CSS, JS, images)
- No servers, fully managed, low cost

### How It Works
- Files stored as S3 objects
- Enable **Static Website Hosting** on bucket
- Access via **S3 website endpoint** (region-based URL)

### Requirements
- 📄 **index.html** required (homepage)
- Bucket + objects must be **publicly readable**
- ❌ If 403 Forbidden → bucket not public

### Security Setup
- Disable **Block Public Access**
- Add **Bucket Policy**:
  - Principal: "*"
  - Action: s3:GetObject
  - Resource: bucket-arn/*

### Key Characteristics
- Static only (no backend, no server-side logic)
- Objects accessed via HTTP endpoint
- Folder structure = object prefixes

### Common Use Cases
- Static websites
- Landing pages
- Image hosting
- Client-side apps

### Exam Tips
- S3 static hosting ≠ EC2
- Needs public bucket policy
- Region matters for website URL
- Think: simple, scalable, serverless hosting

---
## Versioning

### What It Is
- 🕒 Keep **multiple versions** of objects
- Enabled at **bucket level**

### How It Works
- Upload same key → new **version ID**
- Pre-versioning objects = **null version**
- Suspending versioning ≠ deleting versions

### Benefits
- 🛡️ Protects against accidental deletes
- 🔄 Easy rollback to previous versions
- Best practice for critical data

### Delete Behavior
- ❌ Normal delete → adds **delete marker**
- Object hidden, not removed
- ✅ Delete specific version ID → **permanent**

### Restore Objects
- Remove delete marker → previous version restored
- Works for files & static websites

### Exam Tips
- Versioning is **not retroactive**
- Delete marker ≠ actual delete
- Suspend is safe
- Think: rollback, protection, recovery

---
## Replication

### What It Is
- Automatic, **asynchronous copy** between S3 buckets
- Requires **versioning enabled** on source & destination

### Types
- **CRR (Cross-Region Replication)**: different regions
- **SRR (Same-Region Replication)**: same region
- Buckets can be in **different AWS accounts**

### Requirements
- Versioning on both buckets
- Proper **IAM role** for S3 read/write
- Replication rules defined on **source bucket**

### How Replication Works
- Only **new objects** after enabling replication
- Existing objects → use **S3 Batch Replication**
- Version IDs are **preserved** in destination

### Delete Behavior
- ❌ Permanent deletes (specific version ID): **NOT replicated**
- 🏷️ Delete markers: **optional replication**
- Prevents malicious full deletions across buckets

### Limitations
- No replication chaining (A → B → C ❌)
- Asynchronous (not real-time)

### Use Cases
- CRR: compliance, disaster recovery, low latency, cross-account
- SRR: log aggregation, prod → test sync

### Exam Tips
- Versioning is mandatory
- Only new objects replicated by default
- Delete markers ≠ permanent deletes
- No transitive replication

---
## Storage Classes

### Core Concepts
- **Durability**: 11×9s (99.999999999%) for *all* classes
- **Availability**: varies by class
- Objects can change class **manually** or via **Lifecycle rules**

### S3 Standard
- 99.99% availability
- Low latency, high throughput
- Multi-AZ
- Use cases: active data, websites, analytics, content delivery

### S3 Infrequent Access (Standard-IA)
- 99.9% availability
- Lower cost, **retrieval fee**
- Multi-AZ
- Use cases: backups, disaster recovery

### S3 One Zone-IA
- 99.5% availability
- Stored in **single AZ**
- Lower cost than Standard-IA
- Use cases: secondary backups, reproducible data

### Glacier Storage Classes (Archive)
- Low cost + retrieval fees
- Designed for backup & long-term archive

**Glacier Instant Retrieval**
- Milliseconds access
- Min storage: 90 days
- Use: quarterly access data

**Glacier Flexible Retrieval**
- Expedited: 1–5 min
- Standard: 3–5 hrs
- Bulk: 5–12 hrs (cheapest)
- Min storage: 90 days

**Glacier Deep Archive**
- Standard: ~12 hrs
- Bulk: ~48 hrs
- Lowest cost
- Min storage: 180 days

### S3 Intelligent-Tiering
- Automatic tier movement based on access
- Small monitoring fee
- **No retrieval fees**
- Tiers:
  - Frequent (default)
  - Infrequent (≈30 days)
  - Archive Instant (≈90 days)
  - Archive / Deep Archive (optional, configurable)

### Lifecycle Rules
- Automatically transition objects between classes
- Example:
  - Standard → IA → Glacier → Deep Archive
- Works for current and previous versions

### Exam Tips
- Durability is **always 11 nines**
- IA classes = retrieval cost
- One Zone-IA = single AZ risk
- Glacier = archive + delayed retrieval
- Intelligent-Tiering = “set and forget”

---
## S3 Express One Zone
### What It Is
- High-performance S3 storage in **single AZ**
- Uses **Directory Buckets** (not standard buckets)

### Key Characteristics
- Single-digit millisecond latency
- Hundreds of thousands of requests/sec
- ~10× performance of S3 Standard
- ~50% lower cost than S3 Standard
- Lower availability (single AZ)

### Architecture
- Data stored in **one chosen AZ**
- No multi-AZ replication
- Co-locates storage & compute

### Use Cases
- Latency-sensitive applications
- Data-intensive workloads
- AI / ML training
- Financial modeling
- Media processing
- High-performance computing (HPC)

### Integrations
- Amazon SageMaker
- Athena
- EMR
- Glue

### Trade-offs
- ✅ Very high performance
- ❌ AZ failure = data unavailable
- ❌ Not for high-availability workloads

### Exam Tips
- Single AZ only
- Uses directory buckets
- Optimized for speed, not availability
- Think: **compute + storage in same AZ**
