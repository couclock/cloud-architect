# Amazon S3 Advanced

Prompt to use:

Please summarize the following transcript into a very compact AWS Solutions Architect Associate (SAA) revision cheat sheet.
Include a second-level Markdown title (##) at the top using the section’s main topic.
Format the rest in raw Markdown inside a code block, with no separators.
Use short bullet points, minimal wording, and highlight only SAA-relevant concepts, AWS services, rules, exam tips, and best practices.
Use simple icons when relevant, but keep them limited.
Keep the cheat sheet extremely concise and easy to memorize.
Here’s the transcript:

## Lifecycle Rules & Storage Class Transitions

### 🎯 Objective
- Automate S3 cost optimization
- Move or delete objects over time without manual action

### 🔄 S3 Storage Class Transitions
- Standard → Standard-IA → Intelligent-Tiering → One-Zone-IA
- One-Zone-IA → Glacier (Instant / Flexible) → Deep Archive
- Archive data → Glacier tiers ⏳

### ⚙️ Lifecycle Rules (Core Mechanism)
- Transition actions: change storage class after X days
- Expiration actions: delete objects after X days
- Scope:
  - Whole bucket
  - Prefix (path-based)
  - Object tags (e.g. dept=finance)

### 🧩 Expiration & Cleanup Use Cases
- Delete logs after retention period (e.g. 365 days)
- Delete non-current versions (requires versioning)
- Abort incomplete multipart uploads (>14 days)

### 🗂 Versioning + Lifecycle (High Exam Value ⭐)
- Deleted object = delete marker
- Enables recovery of deleted objects
- Lifecycle can target:
  - Current versions
  - Non-current versions
- Typical flow:
  - Non-current → Standard-IA → Glacier Deep Archive
  - Permanent delete after N days

### 📸 Common Architecture Scenario
- Source images:
  - S3 Standard → Glacier after 60 days
- Thumbnails (recreatable):
  - One-Zone-IA → Expire after 60 days
- Use prefixes to apply different rules

### 📊 Amazon S3 Analytics
- Recommends optimal transition timing
- Supported: Standard, Standard-IA only
- Outputs daily CSV report
- First data after 24–48h
- Used to design/improve lifecycle rules

### 🧠 SAA Exam Tips
- Lifecycle rules = automation + cost control
- Prefix/tag filters = selective lifecycle behavior
- Versioning + lifecycle = recovery & compliance
- One-Zone-IA = single AZ, cheaper, recreatable data

---
## Requester Pays

### 🎯 Purpose
- Shift data transfer (download) costs from bucket owner to requester

### 💰 Default S3 Billing
- Bucket owner pays:
  - Storage costs
  - Data transfer (downloads) costs

### 🔁 Requester Pays Buckets
- Bucket owner pays:
  - Storage costs only
- Requester pays:
  - Data transfer (download) costs
- Useful for sharing large datasets 📦

### 🔐 Authentication Requirement
- Requester must be authenticated (not anonymous)
- AWS must identify requester to bill correctly

### 🧩 Typical Use Case
- Public or cross-account access to large files
- Prevent owner from paying high egress costs

### 🧠 SAA Exam Tips
- Requester Pays = networking cost shifted
- Storage cost always stays with bucket owner
- Anonymous access ❌ not supported
- Common in data-sharing scenarios

---
## Event Notifications

### 🎯 Purpose
- React automatically to events happening in S3 buckets

### 📦 S3 Events
- Object created (PUT, POST, COPY)
- Object removed (DELETE)
- Object restored (Glacier restore)
- Replication events
- Filter by:
  - Prefix (path)
  - Suffix (e.g. .jpg)

### 🎯 Destinations (Classic)
- AWS Lambda ⚡
- Amazon SQS 📬
- Amazon SNS 📣
- Events usually delivered within seconds (can be delayed)

### 🔐 Permissions Model (Very Important ⭐)
- S3 does NOT assume IAM roles
- Use **resource-based policies** on targets:
  - SNS → SNS topic policy
  - SQS → SQS queue policy
  - Lambda → Lambda resource policy
- Allows S3 service to publish/invoke

### 🌉 Amazon EventBridge Integration
- All S3 events can be sent to EventBridge
- Enable at bucket level (one toggle)
- Benefits:
  - Advanced filtering (metadata, size, name)
  - Multiple destinations
  - >18 AWS services supported
  - Archive & replay events
  - More reliable delivery

### 🚀 EventBridge Destinations (Examples)
- Step Functions
- Kinesis Data Streams / Firehose
- EventBridge rules & buses

### 🧩 Common Use Case
- Image upload → trigger Lambda
- Generate thumbnails automatically
- S3 → Event → SQS/Lambda pipeline

### 🧠 SAA Exam Tips
- Remember targets: SQS, SNS, Lambda, EventBridge
- Filtering = prefix + suffix only (classic)
- EventBridge = advanced filtering + fan-out
- Resource policies required ❗
- Events are near real-time, not guaranteed instant

---
## Performance & Optimization

### ⚡ Baseline S3 Performance
- Automatic scaling by default
- Latency: ~100–200 ms to first byte
- Per prefix limits:
  - 3,500 PUT / COPY / POST / DELETE per second
  - 5,500 GET / HEAD per second
- Unlimited prefixes per bucket

### 📂 Prefix Concept (Key Exam Point ⭐)
- Prefix = path between bucket name and object name
- Example: bucket/folder1/sub1/file → prefix = /folder1/sub1
- Performance scales linearly by spreading objects across prefixes
- Example: 4 prefixes → 22,000 GET/HEAD req/s

### ⬆️ Multipart Upload
- Recommended for files > 100 MB
- Mandatory for files > 5 GB
- Uploads file parts in parallel
- Maximizes bandwidth & resiliency

### 🚀 S3 Transfer Acceleration
- Speeds up uploads & downloads
- Uses closest AWS Edge Location 🌍
- Edge → S3 over private AWS network
- Best for long-distance transfers
- Compatible with multipart upload

### ⬇️ S3 Byte-Range Fetches
- Parallelize GET requests
- Request specific byte ranges
- Faster downloads for large objects
- Improved resilience (retry smaller ranges)
- Partial reads (e.g. headers only)

### 🧠 SAA Exam Tips
- Performance = per prefix, not per bucket
- Scale reads/writes by spreading prefixes
- Multipart upload = upload optimization
- Byte-range fetch = download optimization
- Transfer Acceleration = global speed boost

---
## Storage Lens

### 🎯 Purpose
- Analyze, monitor, and optimize S3 storage across accounts & orgs
- Detect anomalies, cost inefficiencies, and enforce protection best practices

### 📊 Metrics & Dashboards
- Default dashboard: multi-account, multi-region, pre-configured
- Custom dashboards: filter by account, region, bucket, prefix, storage class
- Export reports: CSV / Parquet to S3

### 🧩 Metric Categories
- **Summary Metrics**: total storage, object count, average size
- **Cost Optimization**: 
  - Non-current version storage bytes
  - Incomplete multipart uploads
  - Identify buckets for lifecycle optimization
- **Data Protection**: 
  - Versioning enabled counts
  - MFA delete enabled counts
  - SSE-KMS enabled counts
  - Cross-region replication
- **Access Management**: bucket/object ownership insights
- **Event Metrics**: S3 event notifications configured
- **Performance Metrics**: S3 Transfer Acceleration usage
- **Activity Metrics**: requests (GET, PUT), bytes, HTTP status codes

### 🟢 Free vs Advanced Metrics
- Free: ~28 usage metrics, 14 days retention
- Advanced (paid): 
  - Activity, advanced cost optimization, advanced data protection, HTTP status codes
  - Metrics published to CloudWatch
  - Prefix-level metrics
  - 15 months retention

### 🧠 SAA Exam Tips
- Storage Lens = S3-wide visibility & optimization tool
- Default dashboard = cross-account & cross-region
- Free metrics: basic usage insights
- Advanced metrics: detailed activity, cost, protection
- Useful for detecting:
  - Unencrypted objects
  - Incomplete uploads
  - Buckets not following best practices

