# Amazon S3 Advanced

Prompt to use:

Please summarize the following transcript into a very compact AWS Solutions Architect Associate (SAA) revision cheat sheet.
Include a second-level Markdown title (##) at the top using the section’s main topic.
Format the rest in raw Markdown inside a code block, with no separators.
Use short bullet points, minimal wording, and highlight only SAA-relevant concepts, AWS services, rules, exam tips, and best practices.
Use simple icons when relevant, but keep them limited.
Keep the cheat sheet extremely concise and easy to memorize.
Here’s the transcript:

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
