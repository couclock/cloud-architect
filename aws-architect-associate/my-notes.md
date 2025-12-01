# 📘 AWS Certified Solutions Architect – Associate (SAA-C03)
## Study & Note-Taking Template

## ✅ Goal

- Start date:
- Target exam date:
- Current strengths:
- Main weaknesses:

---

# 📍 SECTION 1 – AWS Fundamentals & IAM

## 🎯 Section objectives
- [ ] Understand AWS global infrastructure
- [ ] Master IAM basics
- [ ] Understand shared responsibility model

---

## 🔹 IAM – Identity & Access Management

### 📌 Definition (1–2 lines)
Service used to manage **users, groups, roles and permissions** in AWS.

---

### 🧠 Key concepts
- User ≠ Role
- Principle of least privilege
- MFA (Multi-Factor Authentication)
- Policies written in JSON
- Users belong to **groups**, groups get **policies**

---

### ⚙ Common use-cases
- Grant access to AWS services
- Allow EC2 / Lambda to access S3 (via roles)
- Secure applications

---

### ⚠ Exam traps / Must remember
- Root account should never be used daily
- Always enable **MFA**
- Never share access keys
- Use roles instead of access keys where possible

---

### ✅ Typical exam question
> What is the best way to protect your AWS root account?

→ Enable MFA + do not use it for regular activities

---

### 📌 Section Summary (Exam Focus)
- IAM controls access
- Use least privilege & MFA
- Roles > users for services

---

# 📍 SECTION 2 – Networking & VPC

## 🔹 VPC – Virtual Private Cloud

### 📌 Definition
A **logically isolated virtual network** in AWS.

---

### 🔧 Key components

| Component | Description |
|------|------|
Subnet (Public/Private) | Network segmentation  
Internet Gateway | Allows internet access  
NAT Gateway | Outbound only for private subnets  
Route Tables | Network traffic rules  
Security Groups | Instance-level firewall  
NACL | Subnet-level firewall  

---

### 🧠 Key differences (important!)

| Security Group | NACL |
|------|------|
| Stateful | Stateless |
| Attached to instance | Attached to subnet |
| Allows only | Allows and denies |

---

### ⚠ Exam traps
- No IGW = no internet access
- Private subnet = needs NAT to access internet
- Public subnet = route to IGW

---

### ✅ Architecture use case
Web app in public subnet + DB in private subnet

---

### 📌 Section Summary (Exam Focus)
- VPC = network
- SG protects instances
- NACL protects subnets

---

# 📍 SECTION 3 – Compute

## 🔹 EC2 – Elastic Compute Cloud

### 📌 Definition
Scalable virtual servers (VMs) in AWS.

---

### ⚙ Key concepts
- Instance types (t2, m5, c5…)
- AMI
- EBS volumes
- User data scripts
- Auto Scaling Group

---

### ✅ EC2 Use cases
- Websites
- Legacy applications
- Custom environments

---

### ⚠ Exam traps
- EBS is tied to one AZ
- Stop vs Terminate = data loss risk
- Instance store = temporary

---

## 🔹 Lambda

### 📌 Definition
Serverless compute service that runs code on demand.

| Feature | Value |
|------|------|
Max runtime | 15 minutes  
Scaling | Automatic  
Servers | Not managed by you  

✅ Best for event-driven tasks  
⚠ Not for long-running applications

---

## 🔹 Containers (ECS / Fargate / EKS)

| Service | Main idea |
|------|------|
ECS | Container orchestration  
Fargate | Serverless containers  
EKS | Kubernetes  

---

### 📌 Section Summary (Exam Focus)
- EC2 = full control
- Lambda = serverless
- Fargate = containers without server management

---

# 📍 SECTION 4 – Storage

## 🔹 S3 – Simple Storage Service

### 📌 Definition
Object storage system (not a file system).

---

### 🧠 Features
- 11 9’s durability
- Versioning
- Lifecycle rules
- Encryption
- Storage classes

---

### 📊 Storage Classes

| Type | Use |
|------|------|
Standard | Frequent access  
IA | Infrequent  
Glacier | Archive  

---

### ⚠ Exam traps
- Not for databases
- Bucket name is global
- Region based
- Object size limit: 5 TB

---

## 🔹 EBS vs EFS

| Feature | EBS | EFS |
|------|------|------|
Type | Block | File  
Multi-AZ | ❌ | ✅  
Usage | EC2 only | Multiple instances  

---

### 📌 Section Summary (Exam Focus)
- S3 = objects
- EBS = disk for EC2
- EFS = shared file storage

---

# 📍 SECTION 5 – Databases

| Service | Type | Use |
|------|------|------|
RDS | SQL | Structured data  
DynamoDB | NoSQL | Massive scale  
Aurora | SQL | High-performance  
ElastiCache | Cache | Speed up apps  

---

### ⚠ Exam traps
- RDS Multi-AZ = High Availability (not scaling)
- DynamoDB = Serverless NoSQL
- Aurora = AWS-native database

---

### 📌 Section Summary (Exam Focus)
- SQL = structured
- Dynamo = scalable & serverless
- Cache = high speed

---

# 📍 SECTION 6 – Messaging & Serverless Architectures

| Service | Role |
|------|------|
SQS | Queue  
SNS | Pub/Sub  
EventBridge | Events + rules  
Step Functions | Workflows  

✅ Used for decoupling systems

---

# 📍 SECTION 7 – Monitoring & Security

| Service | Purpose |
|------|------|
CloudWatch | Metrics & logs  
CloudTrail | Audit trail  
AWS Shield | DDoS  
KMS | Encryption  

---

### 📌 Section Summary (Exam Focus)
- CloudWatch = monitoring
- CloudTrail = auditing
- KMS = encryption

---

# 📍 SECTION 8 – Cost Optimization

## 💰 Key principles
- Right sizing
- Reserved Instances
- Spot instances
- Lifecycle rules
- Storage class choice

⚠ Cost scenarios = common in the exam

---

# 📍 FINAL SECTION – EXAM NOTES

## 📌 Must-know values

- S3 durability: **99.999999999%**
- Lambda max duration: **15 minutes**
- EBS single AZ
- DynamoDB = serverless NoSQL
- Multi-AZ = HA, not performance

---

## 🧠 Architecture Method for Exam

Always ask:
1. How to make it **scalable**?
2. How to make it **highly available**?
3. How to make it **secure**?
4. How to make it **cost-efficient**?
