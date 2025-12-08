# AWS Certified Solutions Architect – Associate (SAA-C03)
## Study Notes – Udemy Course

| Field | Value |
|------|------|
| Course | AWS Certified Solutions Architect – Associate (SAA-C03) |
| Source | Udemy |
| Objective | Pass the AWS SAA-C03 exam |
| Start Date | 2025-12-01 |
| Target Exam Date | 2025-12-30 |
| Status | In progress |

---

## 📚 Table of Contents

1. [🎯 Goal](#-goal)
2. [Section 1 – AWS Fundamentals & IAM](section-1.md)
   - [Regions, AZs and Edge locations](section-1.md#regions-azs-and-edge-locations)
   - [IAM – Identity & Access Management](section-1.md#-iam--identity--access-management)
3. Section 2 – Elastic Compute Cloud - EC2
   - [Fundamentals](section-2.1.md)
   - [Solutions Architect Associate level](section-2.2.md)


3. [Section 2 – Networking & VPC](#-section-2--networking--vpc)
   - [VPC – Virtual Private Cloud](#-vpc--virtual-private-cloud)
   - [Subnets, IGW, NAT, Route Tables, NACLs, Security Groups](#-subnets-igw-nat-route-tables-nacls-security-groups)
4. [Section 3 – Compute](#-section-3--compute)
   - [EC2 – Elastic Compute Cloud](#-ec2--elastic-compute-cloud)
   - [Auto Scaling & Load Balancers](#-auto-scaling--load-balancers)
   - [Lambda](#-lambda)
   - [Containers – ECS / Fargate / EKS](#-containers--ecs--fargate--eks)
5. [Section 4 – Storage](#-section-4--storage)
   - [S3 – Simple Storage Service](#-s3--simple-storage-service)
   - [EBS / EFS / FSx](#-ebs--efs--fsx)
   - [S3 Lifecycle & Replication](#-s3-lifecycle--replication)
6. [Section 5 – Databases](#-section-5--databases)
   - [RDS / Aurora](#-rds--aurora)
   - [DynamoDB](#-dynamodb)
   - [ElastiCache](#-elasticache)
7. [Section 6 – Messaging & Serverless Architectures](#-section-6--messaging--serverless-architectures)
   - [SQS / SNS / EventBridge](#-sqs--sns--eventbridge)
   - [API Gateway / Step Functions](#-api-gateway--step-functions)
8. [Section 7 – Monitoring & Security](#-section-7--monitoring--security)
   - [CloudWatch / CloudTrail / AWS Config](#-cloudwatch--cloudtrail--aws-config)
   - [AWS Shield / WAF / KMS](#-aws-shield--waf--kms)
9. [Section 8 – Cost Optimization](#-section-8--cost-optimization)
10. [Final Section – Exam Tips & Common Pitfalls](#-final-section--exam-tips--common-pitfalls)
11. [🗓️ 14-Day Revision Plan](#️-14day-revision-plan)

---

## 🎯 Goal

**Primary Objective:**  
Pass the AWS Certified Solutions Architect Associate (SAA-C03) exam with confidence.

**Focus Areas:**
- Well-Architected Framework
- High availability & scalability
- Security best practices
- Cost optimization
- Real exam scenarios

---


# SECTION 2 — Networking & VPC

## ✅ Video Checklist

- [ ] What is VPC?
- [ ] Subnets (Public vs Private)
- [ ] Internet Gateway
- [ ] NAT Gateway / Instance
- [ ] Security Groups / NACLs
- [ ] VPC Peering / Endpoints

---

## 🌐 VPC – Virtual Private Cloud

### Core components

- CIDR block
- Subnets
- Route tables
- Internet Gateway (IGW)
- NAT Gateway
- Security Groups (stateful)
- Network ACLs (stateless)

### Key distinctions

| Security Group | NACL |
|------|------|
| Stateful | Stateless |
| Applied to instance | Applied to subnet |
| Allow only | Allow + Deny |

---

## 🔁 Subnets, IGW, NAT, Route Tables, NACL, SG

Public subnet = route to IGW  
Private subnet = no IGW, uses NAT for outbound

---

# SECTION 3 — Compute

## ✅ Video Checklist

- [ ] EC2 basics
- [ ] Instance types
- [ ] Auto Scaling Groups
- [ ] Load Balancers (ALB / NLB / CLB)
- [ ] Lambda
- [ ] Containers

---

## 💻 EC2 – Elastic Compute Cloud

| Concept | Notes |
|------|------|
| On-Demand | Pay per second |
| Reserved | 1 or 3 years |
| Spot | Cheapest, interruptible |
| Dedicated | Compliance |

User Data = bootstrap script  
AMI = template

---

## ⚖️ Auto Scaling & Load Balancers

- ALB (HTTP/HTTPS – Layer 7)
- NLB (TCP/UDP – Layer 4)
- ASG + CloudWatch metrics

---

## ⚡ Lambda

- Max 15 minutes
- Serverless
- Pay per execution
- Supports many languages

---

## 📦 Containers – ECS / Fargate / EKS

| Service | Use case |
|------|------|
| ECS | Simple containers |
| Fargate | Serverless containers |
| EKS | Kubernetes |

---

# SECTION 4 — Storage

## ✅ Video Checklist

- [ ] S3 Basics
- [ ] Storage classes
- [ ] EBS vs EFS
- [ ] Lifecycle rules

---

## 🪣 S3 – Simple Storage Service

| Feature | Value |
|------|------|
| Object storage | Yes |
| Max object size | 5TB |
| Min storage size | 0 bytes |
| Durability | 99.999999999% |

Storage classes:
- Standard
- IA
- One Zone IA
- Glacier / Deep Archive
- Intelligent Tiering

---

## 💾 EBS / EFS / FSx

| Service | Usage |
|------|------|
| EBS | Block, single EC2 |
| EFS | Multi EC2, shared |
| FSx | High performance |

---

## 🔁 S3 Lifecycle & Replication

- Move objects between tiers automatically
- CRR / SRR
- Versioning required

---

# SECTION 5 — Databases

## RDS / Aurora

- Managed SQL
- Multi-AZ = failover
- Read Replicas = scaling

---

## DynamoDB

- NoSQL
- Single-digit ms latency
- Global tables

---

## ElastiCache

- Redis / Memcached
- Very high performance

---

# SECTION 6 — Messaging & Serverless

| Service | Role |
|------|------|
| SQS | Queue |
| SNS | Pub/Sub |
| EventBridge | Event routing |

---

# SECTION 7 — Monitoring & Security

| Tool | Purpose |
|------|------|
| CloudWatch | Metrics/Logs |
| CloudTrail | API logs |
| Config | Resource tracking |
| KMS | Encryption |
| WAF | Protect from attacks |

---

# SECTION 8 — Cost Optimization

- Use tags
- Use right sizing
- Spot instances
- Savings Plans
- S3 lifecycle

---

# FINAL SECTION — Exam Tips & Common Pitfalls

✅ Always pick:
- Most scalable
- Most serverless
- Most highly available
- Most secure by default

❌ Avoid:
- Single AZ solutions
- EC2 when Lambda fits
- Manual scaling

---

# 🗓️ 14-Day Revision Plan

| Day | Focus |
|------|------|
| 1 | IAM + Security |
| 2 | VPC + Subnets |
| 3 | EC2 + ASG |
| 4 | Load Balancers |
| 5 | S3 |
| 6 | Databases |
| 7 | Messaging |
| 8 | Full revision |
| 9 | Practice Exam 1 |
| 10 | Weak Areas |
| 11 | Practice Exam 2 |
| 12 | Architecture Patterns |
| 13 | Review Notes |
| 14 | Light review + rest |

---

✅ If you want, next I can generate:

- A **quiz section in Markdown**
- A **Cheat Sheet (1 page)**
- Version for **Notion / Obsidian / iPad note app**

Just say: **"Make me the AWS cheat sheet page"**
