# Amazon S3 Advanced

- [Amazon S3 Advanced](#amazon-s3-advanced)
  - [Object Encryption](#object-encryption)
  - [CORS](#cors)
  - [S3 MFA Delete](#s3-mfa-delete)
  - [Access Logs](#access-logs)
  - [Pre-Signed URLs](#pre-signed-urls)
  - [Glacier Vault Lock \& S3 Object Lock](#glacier-vault-lock--s3-object-lock)
  - [Access Points](#access-points)
  - [S3 Object Lambda](#s3-object-lambda)


## Object Encryption

### 🎯 Encryption Options Overview
- 4 methods:
  - SSE-S3 (default)
  - SSE-KMS
  - SSE-C
  - Client-Side Encryption

### 🔐 SSE-S3 (Server-Side, S3-Managed Keys)
- Keys fully managed by AWS
- Encryption: AES-256
- Header: x-amz-server-side-encryption: AES256
- Enabled by default for all new buckets & objects
- No key management, lowest complexity

### 🔑 SSE-KMS (Server-Side, KMS-Managed Keys)
- Keys managed in AWS KMS
- Header: x-amz-server-side-encryption: aws:kms
- Fine-grained access control
- Key usage logged in CloudTrail 📝
- Requires permissions to:
  - S3 object
  - KMS key
- ⚠️ KMS API limits (5k–30k req/s per region)
- Use **S3 Bucket Key** to reduce KMS API costs

### 🧾 SSE-C (Server-Side, Customer-Provided Keys)
- Keys managed outside AWS
- Key sent with every request
- AWS never stores the key
- HTTPS required ❗
- Must provide key on upload & download
- CLI / API only (❌ not supported in Console)

### 🧑‍💻 Client-Side Encryption
- Encrypt data before upload
- Decrypt data after download
- Keys fully managed by client
- AWS stores only encrypted data
- Use client-side encryption libraries

### 🚚 Encryption In Transit
- HTTPS (TLS) = encrypted ✔
- HTTP = unencrypted ❌
- Enforce HTTPS with bucket policy:
  - Deny if aws:SecureTransport = false

### 🪣 Default Encryption
- Enabled by default: SSE-S3
- Can be changed to:
  - SSE-KMS
  - DSSE-KMS (double KMS encryption)
- Applies automatically to new objects
- SSE-C not available as default option

### 📜 Bucket Policies vs Default Encryption (Exam Favorite ⭐)
- Bucket policies can **force encryption**
- Example:
  - Deny PUT if SSE-KMS header missing
  - Deny PUT if SSE-C headers missing
- Bucket policy is evaluated **before** default encryption
- Default encryption ≠ enforcement
- Bucket policy = strict compliance control

### 🧠 SAA Exam Tips
- SSE-S3 = default, simplest
- SSE-KMS = audit + access control + cost impact
- SSE-C = customer-managed keys, HTTPS mandatory
- Client-side = maximum control, client responsibility
- Use bucket policies to enforce encryption rules
- Default encryption alone does NOT block unencrypted PUTs

---
## CORS

### 🔐 What is CORS

- Cross-Origin Resource Sharing  
- Browser security feature  
- Origin = protocol + domain + port  
- Same-origin only if ALL match

### 🌐 How It Works

- Browser sends **preflight OPTIONS**  
- Server must return valid **CORS headers**  
- If approved → request allowed

### 🧩 Key Headers

- Access-Control-Allow-Origin  
- Access-Control-Allow-Methods  
- Often GET / PUT / DELETE / POST  
- `*` allows all origins (use carefully)

### 📦 S3 + CORS (Exam\!)

- Needed for **S3 static website cross-bucket access**  
- Configure in **S3 Permissions → CORS**  
- If missing → browser blocks, NOT AWS error  
- Must specify requesting origin in config

### ⚠️ SAA Exam Tips

- CORS = **browser-side**, NOT IAM auth  
- Cross-origin → requires proper headers  
- OPTIONS preflight = normal behavior  
- Remember: **Access-Control-Allow-Origin is mandatory**

---

## S3 MFA Delete 

### 🔐 What is MFA Delete

- Multi-Factor Authentication protection on S3  
- Prevents destructive actions without MFA code  
- Extra safety for critical data

### 🧱 What Requires MFA

- ❌ Permanent delete of object versions  
- ❌ Suspending bucket versioning

### ✅ What Does NOT Require MFA

- Enabling versioning  
- Listing versions  
- Normal deletes (adds delete markers)

### ⚙️ Requirements

- Bucket **versioning must be enabled**  
- Only **root account** can enable/disable  
- Must configure via **AWS CLI** (not console)

### 🚨 Exam Key Points

- Protects against **accidental / malicious permanent deletion**  
- Browser/console deletes still possible → only delete marker  
- Permanent delete blocked unless MFA provided  
- Root credentials + MFA device needed to configure

### 📝 Best Practices

- Enable for sensitive buckets  
- Use virtual or hardware MFA  
- Remove root access keys after use 👍

---

## Access Logs

### 📘 Purpose

- Audit all S3 access requests  
- Logs **allowed + denied** requests  
- Stored as objects in another S3 bucket  
- Can analyze with Athena

### ⚙️ How It Works

- Enable **Server Access Logging** on source bucket  
- Logs delivered to **target logging bucket**  
- Must be in **same region**

### 📦 Storage & Format

- Delivered as log files into logging bucket  
- Special S3 access log format

### 🚫 Critical Warning (Exam\!)

- ❗ Never log into the **same bucket**  
- Causes infinite loop + massive cost

### 📝 Permissions

- AWS updates logging bucket policy automatically  
- Grants S3 permission to write logs

### ⏱️ Behavior Notes

- Delivery delay possible (not instant)  
- Generates objects over time as traffic happens

### 🧠 Exam Tips

- Separate dedicated logging bucket recommended  
- Same-region rule  
- Use Athena for querying logs

---

## Pre-Signed URLs

### 🎯 Purpose

- Temporary access to private S3 objects  
- Share securely without making bucket public

### 🔐 How It Works

- Generated via Console / CLI / SDK  
- URL contains signed authorization  
- Recipient inherits **permissions of creator**  
- Supports GET (download) + PUT (upload)

### ⏳ Expiration

- Console: up to \~12 hours  
- CLI/SDK: up to \~168 hours (7 days)

### 🧰 Common Use Cases

- Temporary file sharing  
- Premium content delivery  
- Allow restricted uploads to specific S3 paths

### ⚠️ Notes & Exam Tips

- Works only for **that specific object**  
- Still private; access only via signed URL  
- Auto-expires → improves security  
- Useful alternative to making objects public

---

## Glacier Vault Lock & S3 Object Lock

### 🗄️ Glacier Vault Lock

- WORM model: **Write Once, Read Many**  
- Apply **Vault Lock Policy** → lock policy permanently  
- Once locked → objects **cannot be deleted/modified**, even by root  
- Use case: compliance, legal, data retention

### 🔒 S3 Object Lock

- Protect individual object versions  
- Requires **bucket versioning enabled**  
- WORM model at **object level**  
- Two retention modes:  
  - **Compliance Mode** ✅  
    - No one can delete/overwrite  
    - Retention cannot be shortened  
  - **Governance Mode** ⚖️  
    - Admins can override/delete  
    - Regular users cannot alter/delete

### ⏳ Retention Period

- Set for each object  
- Can be extended  
- Object protected until retention expires

### ⚖️ Legal Hold

- Protects object **indefinitely**, ignoring retention period  
- Requires IAM permission **s3:PutObjectLegalHold**  
- Can be applied/removed as needed (e.g., for legal cases)

### 🧠 Exam Tips

- Glacier Vault Lock = bucket-level, strict WORM  
- S3 Object Lock = object-level, retention + legal hold  
- Compliance = strict, Governance = flexible  
- Legal Hold overrides retention period

---

## Access Points

### 🗂️ Purpose

- Simplify access management for large S3 buckets  
- Avoid complex bucket policies with many users/data  
- Define **separate access points per use case**

### 🔑 How It Works

- Create **access point** per group/prefix  
  - e.g., Finance AP → finance/*, Sales AP → sales/*  
- Each AP has **its own policy** (like bucket policy)  
- Users connect via **AP DNS name**  
- Policies control read/write or read-only access

### 🌐 Internet vs VPC

- AP can be **public (internet)** or **private (VPC origin)**  
- Private access → create **VPC endpoint** in VPC  
- VPC endpoint policy grants access to target AP + bucket  
- Layered security: S3 bucket + access point + VPC endpoint

### 🧩 Benefits

- Scales S3 access management  
- Simplifies security for multiple teams  
- Allows fine-grained access per prefix/object  
- Reduces complexity of bucket policy

---

## S3 Object Lambda

### 🎯 Purpose

- Modify or transform S3 objects **on-the-fly** during retrieval  
- Avoid duplicating buckets for different versions of objects  
- Useful for redaction, enrichment, format conversion, or personalization

### 🔑 How It Works

- Requires an **S3 Access Point** + **Lambda function**  
- Client accesses **Object Lambda Access Point**  
- Lambda fetches object from original S3 bucket  
- Lambda modifies object (redact/enrich/transform)  
- Returns transformed object to client

### 🧩 Use Cases

- Redact PII for analytics / non-production  
- Enrich objects with external data (e.g., loyalty DB)  
- Convert formats (XML → JSON)  
- Resize/watermark images dynamically

### ⚠️ Exam Tips

- One bucket → multiple views via Object Lambda AP  
- Lambda executes automatically on GET requests  
- Access point policies still apply  
- Reduces storage duplication and simplifies data handling
