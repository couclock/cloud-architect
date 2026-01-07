
# More solution architectures

- [More solution architectures](#more-solution-architectures)
  - [AWS Event Processing Patterns](#aws-event-processing-patterns)
  - [AWS Caching Strategies](#aws-caching-strategies)
  - [AWS Network Security \& IP Blocking](#aws-network-security--ip-blocking)
  - [High Performance Computing (HPC) on AWS](#high-performance-computing-hpc-on-aws)
  - [Highly Available EC2 Architectures](#highly-available-ec2-architectures)

## AWS Event Processing Patterns

### SQS + Lambda 📥

- Lambda **polls SQS**  
- Failed messages **retried by Lambda**  
- Risk of **infinite retries**  
- Use **SQS DLQ** after max receives

### SQS FIFO + Lambda 🔒

- **Ordered processing**  
- One bad message **blocks queue**  
- **DLQ required** to unblock processing

### SNS + Lambda 📣

- **Async invoke**  
- Lambda retries **up to 3 times**  
- Failures **discarded or sent to Lambda DLQ**  
- **DLQ configured on Lambda**, not SNS

### Fan-Out Pattern 🔀

- **SNS → multiple SQS queues**  
- Reliable **one-to-many delivery**  
- App publishes **once to SNS**  
- Preferred over multiple SQS sends

### S3 Event Notifications 🪣

- Triggers on **create, delete, restore, replicate**  
- Can filter by **object name**  
- Targets: **SNS, SQS, Lambda**  
- Delivery usually **seconds** (sometimes \>1 min)

### EventBridge 🚀

- Receives **S3 & AWS service events**  
- **Advanced filtering** (size, metadata, name)  
- **Multiple targets** (Lambda, Step Functions, Kinesis, Firehose)  
- Supports **archive & replay**

### CloudTrail + EventBridge 🔍

- **API calls → CloudTrail → EventBridge**  
- React to actions (e.g. **DynamoDB DeleteTable**)  
- Commonly used for **alerts via SNS**

### External Events 🌍

- **API Gateway → Kinesis Streams/Firehose → S3**  
- Ingest **external app events** into AWS

### Exam Tips 🧠

- **SQS DLQ** vs **Lambda DLQ** distinction  
- **SNS + SQS = fan-out**  
- Need filtering, replay, multi-target → **EventBridge**  
- FIFO + failure = **blocked queue**

---
## AWS Caching Strategies

### Cache Layers
- 🌍 **CloudFront**: Edge cache (lowest latency)
- **API Gateway**: Regional cache
- **App Cache**: Redis / Memcached / DAX
- **DB/S3**: ❌ No caching

### CloudFront (Edge)
- Closest to users
- TTL controls freshness
- ⚠️ Possible stale data
- Best for static + cacheable dynamic content

### API Gateway Cache
- Regional only
- Reduces backend calls
- Higher latency than CloudFront

### Application Cache
- ElastiCache (Redis/Memcached)
- DAX for DynamoDB
- Avoid repeated DB reads
- Improves read scalability

### Trade-offs ⚖️
- Closer cache = faster, less fresh
- Deeper cache = slower, fresher
- More caching = less DB load, more complexity

### SAA Exam Tips 🧠
- Cache placement is scenario-based
- Always think TTL
- CloudFront = edge, API GW = regional, ElastiCache/DAX = app-level

---
## AWS Network Security & IP Blocking

### Defense Layers (Order)
- 🧱 **NACL**: Subnet-level, stateless, allow + deny
- 🔐 **Security Group**: Instance/ENI-level, stateful, allow only
- 🖥️ **Instance Firewall**: OS-level, full control, CPU cost

### EC2 in Public Subnet
- NACL = 1st filter (cheap IP block)
- SG = restrict known client IPs
- Optional host firewall (iptables, etc.)

### ALB/NLB Architecture
- Client → **ALB/NLB (public)** → EC2 (private)
- ALB/NLB terminates connection
- EC2 SG: allow traffic **only from ALB/NLB**
- NACL still applies at subnet level

### ALB/NLB Security
- Same SG model for ALB & NLB
- Security can be enforced at LB level

### AWS WAF 🛡️
- Attach to **ALB** or **CloudFront**
- IP filtering, rules, protections
- Extra cost but strong L7 security

### CloudFront + ALB
- Client → CloudFront → ALB
- NACL ❌ can’t filter client IPs
- ALB SG: allow **CloudFront IP ranges only**
- CloudFront:
  - Geo Restriction 🌍
  - WAF for IP/rule filtering

### SAA Exam Tips 🧠
- NACL = stateless + deny rules
- SG = stateful + allow only
- CloudFront hides client IPs
- WAF works at ALB & CloudFront
- Draw traffic path to place rules correctly

---
## High Performance Computing (HPC) on AWS

### What is HPC
- Massive parallel compute
- Scale fast, pay per use, tear down after
- Use cases: genomics, ML/DL, finance, weather

### Data Transfer 📦
- **Direct Connect**: Private, high-throughput (GB/s)
- **Snowball / Snowmobile**: PB-scale, offline transfer
- **DataSync**: On-prem ↔ S3 / EFS / FSx

### Compute & Scaling ⚙️
- **EC2**: CPU or GPU optimized
- **Spot Instances / Fleets**: Major cost savings
- **Auto Scaling**: Scale compute dynamically
- **Placement Group (Cluster)**:
  - Same AZ, same rack
  - Low latency, high throughput

### Networking Performance 🌐
- **ENA (Enhanced Networking)**:
  - Up to **100 Gbps**
  - Higher bandwidth, PPS, lower latency
- **Intel 82599 VF**: Legacy, up to 10 Gbps
- **EFA (Elastic Fabric Adapter)**:
  - HPC-only, Linux
  - Tightly coupled workloads
  - Uses **MPI**, bypasses OS
- Exam tip: **EFA > ENA** for HPC clusters

### Storage Options 💾
- **EBS io2 Block Express**: Up to 256k IOPS
- **Instance Store**: Millions IOPS, ephemeral
- **S3**: Object storage, large datasets
- **EFS**: Scales with size or provisioned IOPS
- **FSx for Lustre** ⭐:
  - HPC-optimized filesystem
  - Millions of IOPS
  - Integrated with S3

### Orchestration & Automation 🤖
- **AWS Batch**:
  - Multi-node parallel jobs
  - Manages EC2 lifecycle
- **AWS ParallelCluster**:
  - Open-source HPC cluster tool
  - Automates VPC, EC2, storage
  - Supports **EFA** configuration

### SAA Exam Tips 🧠
- HPC = architecture, not a single service
- Cluster Placement Group + EFA = max performance
- FSx for Lustre = HPC filesystem
- Spot + Batch = cost-efficient HPC

---
## Highly Available EC2 Architectures

### Problem
- EC2 = single AZ ❌ not HA by default
- HA requires automation + failover

### Simple HA (Elastic IP)
- Public EC2 + **Elastic IP**
- Users connect via EIP
- ❌ Still single instance

### HA with Standby EC2
- Primary + Standby EC2
- **CloudWatch Alarm/Event** detects failure
- Trigger **Lambda**
- Lambda re-attaches **Elastic IP** to standby
- EIP = 1 instance at a time

### HA with Auto Scaling Group ⭐
- ASG across **2 AZs**
- Min=1 / Max=1 / Desired=1
- Only 1 instance running
- On failure:
  - ASG launches replacement in other AZ
  - **User Data** attaches Elastic IP
- No CloudWatch needed
- EC2 needs **IAM Role** (EIP API calls)

### Stateful EC2 (EBS) HA
- EC2 + **EBS (AZ-bound)**
- ASG + Lifecycle Hooks:
  - **Terminate**: Snapshot EBS
  - **Launch**: Restore volume in new AZ
- User Data:
  - Attach EBS
  - Attach Elastic IP
- Requires IAM Role

### Key Services 🧠
- Elastic IP: static endpoint
- CloudWatch: failure detection
- Lambda: automation
- ASG: self-healing
- Lifecycle Hooks: state handling
- EBS Snapshot: cross-AZ recovery

### SAA Exam Tips
- ASG can be used for HA, not just scaling
- Min=Max=1 = HA failover pattern
- EBS ≠ multi-AZ → snapshot required
- Automation = User Data + IAM Role
