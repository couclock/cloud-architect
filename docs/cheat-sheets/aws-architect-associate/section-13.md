
# Serverless solution architecture discussions

- [Serverless solution architecture discussions](#serverless-solution-architecture-discussions)
  - [MyTodoList](#mytodolist)
  - [MyBlog.com](#myblogcom)
  - [AWS SAA – Serverless Hosted Website (MyBlog.com)](#aws-saa--serverless-hosted-website-myblogcom)
  - [Software Updates Offloading](#software-updates-offloading)

## MyTodoList

### Core Architecture
- **API Gateway** → HTTPS REST API 🌐
- **Lambda** → serverless compute
- **DynamoDB** → scalable NoSQL backend
- Fully serverless, pay-per-use

### Authentication
- **Amazon Cognito** 👤
  - User authentication
  - Integrated with API Gateway
  - No IAM users on clients

### Data Storage
- **DynamoDB**
  - High read throughput
  - Serverless, auto-scale
- **Amazon S3**
  - Users access own folders
  - Access via Cognito temporary credentials
  - ❌ Never store AWS creds on clients

### Performance & Caching
- **DAX**
  - Cache DynamoDB reads
  - Reduce RCUs & cost
- **API Gateway Caching**
  - Cache static / rarely changing responses

### Security
- Cognito + API Gateway auth
- Temporary AWS credentials
- Fine-grained S3 access policies

### Exam Keywords
- Serverless REST API
- API Gateway + Lambda + DynamoDB
- Cognito = auth + temp creds
- DAX = DynamoDB read cache
- API Gateway response caching
- Pay-per-use, no infra management

---
## MyBlog.com

## AWS SAA – Serverless Hosted Website (MyBlog.com)

### Static Content (Global & Cached)
- **S3** → static website assets
- **CloudFront (CDN)** → global delivery + caching
- **OAC (Origin Access Control)** → only CloudFront can access S3
- Bucket policy blocks direct S3 access

### Dynamic Content (REST API)
- **API Gateway (HTTPS)** → public REST API
- **Lambda** → serverless backend
- **DynamoDB** → data store (read-heavy)
- **DAX** → cache frequent reads
- **DynamoDB Global Tables** → low latency worldwide

### User Subscription (Welcome Email)
- **DynamoDB Streams** → capture new users
- **Lambda** → triggered by stream
- **Amazon SES** → send welcome emails
- Fully serverless, auto-scaling

### Image Upload & Thumbnails
- Upload via **S3** or **CloudFront + S3 Transfer Acceleration**
- **S3 Event** → triggers Lambda
- **Lambda** → generate thumbnails
- Store thumbnails in S3 (same or separate bucket)
- S3 can also trigger **SQS / SNS**

### Key Serverless Benefits
- Global scale 🌍
- Heavy read optimization
- Built-in caching
- Event-driven workflows
- No infrastructure management
- Pay-per-use

### Exam Keywords
- CloudFront + S3 (static hosting)
- OAC + bucket policy
- API Gateway + Lambda
- DynamoDB Global Tables
- DAX caching
- DynamoDB Streams
- SES (serverless email)
- S3 event notifications

---
## Microservice architecture

### Core Concept
- **Microservices** = small, independent services
- Communicate via **REST APIs (HTTPS)** or **events**
- Independent scaling, deployment, codebase

### Example Service Designs
- **Service 1**: Route 53 → ALB → **ECS (Docker)** → DynamoDB
- **Service 2**: API Gateway → **Lambda** → ElastiCache
- **Service 3**: Route 53 → ALB → **EC2 Auto Scaling** → RDS
- Each service has its own DNS (e.g. `service1.example.com`)

### Communication Patterns
- **Synchronous** 🔁
  - REST calls via **API Gateway / ALB**
  - Tight coupling, immediate response
- **Asynchronous** 📩
  - **SQS, SNS, Kinesis, S3 events, Lambda triggers**
  - Loose coupling, no direct response needed

### Key AWS Services
- **Route 53** → service discovery (DNS)
- **ALB / API Gateway** → expose microservices
- **ECS / EC2 / Lambda** → compute choices
- **DynamoDB / RDS / ElastiCache** → per-service datastore

### Challenges
- Higher operational overhead
- Multiple versions to manage
- Client complexity (many APIs)
- Resource utilization inefficiency

### Serverless to the Rescue
- **API Gateway + Lambda** → auto-scale, pay-per-use
- Easy environment cloning
- **Swagger / OpenAPI** → generate client SDKs

### Exam Tips
- Microservices = **design pattern**, not a service
- Each service owns its **data store**
- Prefer **async (SQS/SNS)** for decoupling
- Serverless reduces ops & scaling complexity

---
## Software Updates Offloading

### Problem
- App on **EC2 (ASG + ALB)** distributes software updates
- Update releases = traffic spikes 🚀
- High **CPU, network, EFS** costs
- No desire to re-architect app

### Existing Setup
- **ALB + Auto Scaling Group (Multi-AZ)**
- **EC2** serves update files
- Update files stored on **Amazon EFS**
- Files are **static & immutable**

### Simple Solution
- Add **Amazon CloudFront** in front of app
- No backend changes required ✅

### Why CloudFront Works
- Caches **static update files** at edge locations
- Serves users globally 🌍
- Offloads traffic from EC2
- Scales automatically (serverless)

### Benefits
- 🔽 EC2 CPU & ASG scaling
- 🔽 Network + EFS costs
- 🔼 Availability & performance
- Zero app rewrite

### Exam Tips
- Use **CloudFront** to offload static content
- Ideal for **read-heavy, immutable files**
- Works with **existing EC2-based apps**
- Easiest cost-optimization wins often = caching
