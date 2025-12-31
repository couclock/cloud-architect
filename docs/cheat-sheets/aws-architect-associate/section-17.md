
# Monitoring & Audit

- [Monitoring \& Audit](#monitoring--audit)
  - [Amazon CloudWatch Metrics](#amazon-cloudwatch-metrics)
  - [Amazon CloudWatch Logs](#amazon-cloudwatch-logs)
  - [CloudWatch Logs](#cloudwatch-logs)
  - [CloudWatch Agents](#cloudwatch-agents)
  - [CloudWatch Alarms](#cloudwatch-alarms)
  - [Amazon EventBridge](#amazon-eventbridge)
  - [CloudWatch Insights — SAA Quick Cheat Sheet](#cloudwatch-insights--saa-quick-cheat-sheet)
  - [AWS CloudTrail](#aws-cloudtrail)


## Amazon CloudWatch Metrics

### Basics 📊
- Monitor AWS resources
- Metric = time-based value (timestamped)
- Examples: EC2 CPUUtilization, S3 BucketSize

### Structure
- Namespace = per AWS service (EC2, S3)
- Dimensions = metric attributes (InstanceId)
- Max **30 dimensions**

### Resolution ⏱️
- Default EC2: **5 min**
- Detailed monitoring: **1 min** (paid)

### Dashboards
- Visualize multiple metrics
- Custom time range, export CSV

### Custom Metrics ⭐
- User-defined metrics
- Common: EC2 memory usage

### Streaming 🚀
- Near real-time via **Kinesis Data Firehose**
- Targets: S3 (+Athena), Redshift, OpenSearch
- 3rd-party: Datadog, Splunk, New Relic

### Exam Tips 🧠
- Metrics are **region-based**
- Custom ≠ automatic
- Firehose = delivery only

---
## Amazon CloudWatch Logs

### Core Structure 📄
- **Log Group** = app/service
- **Log Stream** = instance/container/file
- Retention: **1 day → 10 years** (or never expire)

### Log Sources
- EC2 (CloudWatch Agent / Unified Agent)
- Lambda (automatic)
- ECS containers
- Elastic Beanstalk
- API Gateway
- VPC Flow Logs
- CloudTrail (filtered)
- Route 53 DNS logs

### Security 🔐
- Encrypted by default
- Optional **customer-managed KMS key**

### Logs Insights 🔍
- Query & analyze logs (SQL-like)
- Historical data only (not real-time)
- Auto-detected fields
- Save queries, add to dashboards
- Query **multiple log groups / accounts**

### Export & Streaming 🚀
- **Batch export → S3**
  - API: `CreateExportTask`
  - Can take **up to 12 hours**
- **Real-time streaming** via subscription filters:
  - Kinesis Data Streams
  - Kinesis Data Firehose
  - AWS Lambda
  - OpenSearch Service

### Subscription Filters
- Filter log events before delivery
- Near real-time
- Enable **cross-account & cross-region** log aggregation

### Exam Tips 🧠
- Logs ≠ Metrics
- Insights = query engine, not live
- S3 export = batch only
- Firehose = delivery, not processing
- Unified Agent replaces old Logs Agent

---
## CloudWatch Logs

### Log Groups & Streams 📄
- Log Group = app/service
- Log Stream = instance/container/output
- Examples: Lambda, Glue, DataSync, SSM Run Command
- stdout / stderr = separate streams

### Searching Logs 🔍
- Keyword search inside streams
- Fast troubleshooting (e.g. errors, install)

### Metric Filters 📊
- Extract metrics from logs
- Pattern → Custom Metric (new namespace)
- Use for **alarms** (e.g. error count)
- Exam tip: Logs → Metrics via **metric filters**

### Alarms 🚨
- Create alarms on metric filters
- Trigger on threshold breaches

### Subscription Filters 🚀
- Real-time log streaming
- Destinations:
  - Kinesis Data Streams
  - Kinesis Firehose
  - Lambda
  - OpenSearch
- Max **2 subscription filters per log group**

### Retention & Export
- Retention: **never expire → 10 years**
- Batch export → **S3**
- Choose time range + stream prefix

### Encryption 🔐
- Encrypted by default
- Optional **customer-managed KMS key**

### Logs Insights 📈
- Query historical logs (not real-time)
- Save queries, export results
- Built-in queries (Lambda, VPC Flow Logs)
- Multi log group support

### Live Tail ⚡
- Near real-time log viewing
- Filter by log group / stream
- Great for debugging
- **~1 hour/day free**, stop to avoid cost

### Exam Tips 🧠
- Metric filters = key bridge Logs → Alarms
- Live Tail ≠ Logs Insights
- S3 export = batch only
- Subscription filters = real-time

---
## CloudWatch Agents

### Purpose 📦
- Send **logs & metrics** from EC2 / on-prem → CloudWatch
- EC2 sends **no logs by default**

### Requirements
- Install agent on instance
- **IAM role** with CloudWatch permissions
- Works on **EC2 & on-prem servers**

### Agent Types
- **CloudWatch Logs Agent** (old)
  - Logs only
- **CloudWatch Unified Agent** (recommended ⭐)
  - Logs + detailed system metrics
  - Central config via **SSM Parameter Store**

### Unified Agent Metrics 📊
- CPU (detailed states)
- Memory (RAM, swap)
- Disk (usage, IO, IOPS)
- Network (packets, bytes)
- Processes (running, sleeping, blocked)

### Key Difference (Exam) 🧠
- Default EC2 monitoring:
  - CPU, disk, network (high-level)
  - ❌ No memory
- Unified Agent:
  - **Memory + granular OS metrics**

### Best Practices
- Use **Unified Agent** for custom / OS metrics
- Use SSM for centralized management

### Exam Tips 🧠
- Memory metrics → **Unified Agent**
- Logs from EC2 → **Agent required**
- On-prem → same agent works

---
## CloudWatch Alarms

### Purpose 🚨
- Trigger actions based on **CloudWatch metrics**
- Supports simple & complex conditions

### Alarm States
- **OK** → within threshold
- **INSUFFICIENT_DATA** → not enough data
- **ALARM** → threshold breached

### Evaluation
- Period = metric evaluation window
- Supports **high-resolution metrics** (10s, 30s, 60s)
- Conditions: average, max, %, anomaly detection

### Alarm Actions 🎯
- **EC2 actions**: stop, terminate, reboot, recover
- **Auto Scaling**: scale in / out
- **SNS** → email, SMS, Lambda, automation

### Composite Alarms 🧩
- Combine multiple alarms (AND / OR)
- Reduce alarm noise
- Alarm monitors **other alarm states**, not metrics directly

### EC2 Instance Recovery ♻️
- Based on **status checks**:
  - Instance status
  - System status (hardware)
  - EBS status
- Recovery keeps:
  - Same IPs, metadata, placement group
- Can notify via SNS

### Logs → Alarms
- **Metric filters** on CloudWatch Logs
- Logs → Metric → Alarm → SNS

### Testing Alarms 🧪
- API: **SetAlarmState**
- Force alarm without waiting for threshold
- Useful for validating actions

### Exam Tips 🧠
- Composite alarms = alarm-on-alarms
- Recovery ≠ reboot
- Logs need metric filters first
- Alarms can directly terminate EC2

---
## Amazon EventBridge

### What It Is ⚡
- Event-driven service (formerly **CloudWatch Events**)
- React to AWS, SaaS, or custom events
- Supports **rules** & **schedules (cron / rate)**

### Event Sources
- AWS services (EC2, S3, IAM, CodePipeline, Trusted Advisor)
- CloudTrail → capture **any API call**
- SaaS partners (Auth0, Datadog, Zendesk)
- Custom apps (PutEvents)

### Event Buses 🚌
- **Default**: AWS service events
- **Partner**: SaaS integrations
- **Custom**: app-defined events
- Cross-account access via **resource-based policies**

### Rules 🎯
- Match **event patterns** or **schedules**
- Filter by service, event type, resource
- Generate structured **JSON event**

### Targets
- Lambda
- SNS / SQS
- Step Functions
- ECS / Batch
- Kinesis
- CodeBuild / CodePipeline
- EC2 / SSM actions
- External APIs (API Destinations)

### Scheduling ⏰
- Rate or cron expressions
- One-time or recurring
- Managed via **EventBridge Scheduler**

### Event Archive & Replay ♻️
- Archive all or filtered events
- Retention: fixed or indefinite
- **Replay events** for debugging / recovery

### Schema Registry 📘
- Auto-discover event schemas
- Versioned schemas
- Generate code bindings (Java, Python, TS, Go)

### Exam Tips 🧠
- EventBridge ≠ polling
- CloudTrail + EventBridge = API monitoring
- Schedules replace cron on EC2
- Composite workflows → EventBridge + Lambda

---
## CloudWatch Insights — SAA Quick Cheat Sheet

### Container Insights 🐳
- Metrics + logs for containers
- Supports **ECS, EKS, K8s on EC2, Fargate**
- Granular dashboards (CPU, memory, network)
- K8s uses **containerized CloudWatch Agent**

### Lambda Insights ⚡
- Deep monitoring for **AWS Lambda**
- Metrics: CPU time, memory, disk, network
- Tracks **cold starts & worker shutdowns**
- Uses Lambda **Layer**
- Exam: use for **detailed serverless troubleshooting**

### Contributor Insights 👥
- Analyze logs → **top contributors**
- Finds heavy users / top talkers
- Examples:
  - VPC Flow Logs → top IPs
  - DNS logs → most errors
- Built on **CloudWatch Logs**
- Keyword: *Top N contributors*

### Application Insights 🧠
- Automated app health dashboards
- Supports EC2 apps (Java, .NET, IIS, DBs)
- Correlates dependencies:
  - RDS, ELB, ASG, Lambda, SQS, DynamoDB, S3, ECS/EKS
- Uses **ML (SageMaker)** internally
- Alerts sent to **EventBridge & SSM OpsCenter**

### Exam Tips 🧠
- Containers → **Container Insights**
- Serverless deep dive → **Lambda Insights**
- “Top talkers” → **Contributor Insights**
- App-wide issues → **Application Insights**
- Know at **high level only**

---
## AWS CloudTrail

### What is CloudTrail? 🕵️
- **Governance, compliance, auditing**
- Logs **all API calls & user activity**
- Enabled **by default**
- Tracks actions from:
  - Console, CLI, SDK
  - IAM users & roles
  - AWS services

### Core Use Case 🔍
- Answer: **Who did what, when, and from where**
- Example: EC2 instance deleted → check CloudTrail

### Event Retention ⏱️
- **90 days** by default (Event History)
- For >90 days:
  - Send logs to **S3**
  - Query with **Amazon Athena**

### CloudTrail Event Types

#### 1. Management Events (Default) ⚙️
- Control-plane operations
- Examples:
  - Create subnet
  - Attach IAM policy
  - Terminate EC2
- Two types:
  - **Read**: list, describe (non-destructive)
  - **Write**: create, delete, modify (**important**)

#### 2. Data Events (Optional, High Volume) 📦
- **Not enabled by default**
- Examples:
  - S3 object-level: `GetObject`, `PutObject`, `DeleteObject`
  - Lambda `Invoke`
- Can separate **Read vs Write**

#### 3. CloudTrail Insights Events 🧠
- **Detects unusual activity**
- Paid & must be enabled
- Uses baseline of normal behavior
- Detects:
  - API call spikes
  - Unusual IAM activity
  - Service limit issues
- Sends findings to:
  - CloudTrail console
  - **EventBridge**
  - SNS / automation

### Trails 🧾
- Can be:
  - **Single-region**
  - **All regions**
- Used to store logs in **S3 / CloudWatch Logs**

### CloudTrail + EventBridge 🔗
- Every API call → **EventBridge event**
- Enables automation & alerts
- Examples:
  - Notify on `DeleteTable` (DynamoDB)
  - Alert on `AssumeRole`
  - Detect SG rule changes (`AuthorizeSecurityGroupIngress`)
- Typical flow:
  - CloudTrail → EventBridge Rule → SNS / Lambda

### Exam Tips 🧠
- Auditing & API history → **CloudTrail**
- >90-day retention → **S3 + Athena**
- S3 object access → **Data Events**
- Anomaly detection → **CloudTrail Insights**
- API-based alerts → **CloudTrail + EventBridge**

---
### AWS Config

### What is AWS Config
Audits and records AWS resource configurations and changes over time  
Used for compliance and visibility, not access control  
Helps answer:
• Is SSH open to the world?  
• Are S3 buckets public?  
• What changed and when?

### Core Features
• Per-region service  
• Aggregates across regions and accounts  
• Stores configuration history in S3  
• Query history with Athena  
• Integrated with CloudTrail for API-level auditing  

### Config Rules
• Evaluate resource compliance  
• AWS Managed Rules (75+)  
• Custom rules using Lambda  
• Triggered on change or on schedule  
• Output: compliant / non-compliant  
• Does NOT block or deny actions  

### Remediation
• Fix non-compliant resources automatically or manually  
• Uses SSM Automation Documents  
• Supports retries  
• Can invoke Lambda for custom logic  

### Notifications
• Compliance changes sent to SNS  
• EventBridge used for automation and alerts  

### Pricing
• Charged per configuration item recorded  
• Charged per rule evaluation  
• Costs increase quickly if many resources are tracked  

### Exam Keywords
• Compliance & configuration history → AWS Config  
• Rule-based compliance → Config Rules  
• Auto-remediation → SSM Automation  
• Audit trail → AWS Config + CloudTrail  
• Long-term analysis → S3 + Athena  

---
### CloudWatch vs CloudTrail vs AWS Config — Ultra Compact

### ☁️ CloudWatch
📊 Metrics & monitoring  
• CPU, memory, latency, errors  
• Dashboards, alarms, logs  
• Performance visibility  

### 🔍 CloudTrail
🧾 API auditing  
• Who did what, when, where  
• Console, CLI, SDK, AWS services  
• Global service  

### ⚙️ AWS Config
✅ Configuration & compliance  
• Track config changes over time  
• Evaluate rules (compliant / non-compliant)  
• Governance (no enforcement)  

### ELB Example

### ☁️ CloudWatch
• Requests, latency, 4XX/5XX errors  

### ⚙️ AWS Config
• SSL enabled?  
• SG rules compliant?  

### 🔍 CloudTrail
• Who changed SSL or SG rules?  

### Exam Shortcut
📈 Performance → CloudWatch  
🧾 Audit → CloudTrail  
✅ Compliance → Config  
