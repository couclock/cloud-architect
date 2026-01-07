
# Other services

- [Other services](#other-services)
  - [AWS CloudFormation – Infrastructure at Scale](#aws-cloudformation--infrastructure-at-scale)
  - [CloudFormation Hands-on – Stack Lifecycle](#cloudformation-hands-on--stack-lifecycle)
  - [CloudFormation Service Roles](#cloudformation-service-roles)
  - [Amazon SES](#amazon-ses)
  - [Amazon Pinpoint](#amazon-pinpoint)
  - [SSM Session Manager](#ssm-session-manager)
  - [AWS Systems Manager (Other Features)](#aws-systems-manager-other-features)
  - [AWS Cost Explorer \& Cost Anomaly Detection](#aws-cost-explorer--cost-anomaly-detection)
  - [AWS Outposts](#aws-outposts)
  - [AWS Batch](#aws-batch)
  - [Amazon AppFlow](#amazon-appflow)
  - [AWS Amplify](#aws-amplify)
  - [AWS Instance Scheduler](#aws-instance-scheduler)

## AWS CloudFormation – Infrastructure at Scale

### What it is
- 🧱 **Infrastructure as Code (IaC)** service
- **Declarative** templates (YAML / JSON)
- Defines & provisions AWS resources **automatically, in correct order**

### Core Benefits
- 🔁 **Repeatable & consistent** deployments
- 👀 **Code review & version control** for infra
- 🏷️ **Automatic tagging** per stack → cost tracking
- 💰 **Cost estimation** from templates
- ⚡ **Easy create / update / delete** stacks

### Productivity & Operations
- 🚀 Destroy & recreate infra on demand
- 🧠 Dependency management handled by CloudFormation
- 📊 **Auto-generated architecture diagrams**
- ♻️ Ideal for **ephemeral environments** (dev/test)

### Cost Optimization
- ⏰ Schedule stack deletion (e.g. nights/weekends)
- 💸 No idle resources → cost savings

### Coverage & Extensibility
- ✅ Supports **most AWS services**
- 🧩 **Custom Resources** for unsupported services
- 📚 Reuse community & AWS-provided templates

### Visualization
- 🧭 **Infrastructure Composer**
- Shows resources **+ relationships** (ALB, EC2, SGs, RDS, etc.)

### Exam Tips (SAA)
- Use when:
  - IaC is required
  - Same architecture across **environments / regions / accounts**
- Key keywords:
  - *Declarative, Stack, Template, Repeatable, IaC*
- CloudFormation = **foundation of AWS IaC**

---
## CloudFormation Hands-on – Stack Lifecycle

### Stack Creation
- 📍 **Region matters** (templates may be region-specific)
- AMI IDs & AZs are **region-scoped**
- Create stack from:
  - Existing template (YAML / JSON)
  - Sample templates
  - Application Composer

### Template Basics
- `Resources`: define AWS resources (EC2, SG, EIP, etc.)
- Properties define exact config (AMI, instance type, AZ)
- Example: EC2 `t2.micro`, specific AMI, specific AZ

### Application Composer
- 🧭 Visualize templates as diagrams
- View/edit **YAML ↔ JSON**
- Shows **resources + relationships**

### Stack Parameters & Tags
- `Parameters`: user inputs at deploy time
- `Tags`: applied automatically to all stack resources
- Default CloudFormation tags:
  - Stack name
  - Logical ID
  - Stack ID

### Stack Update
- Update stack = upload **new template**
- 🔍 **Change Sets**:
  - Preview what will change before applying
  - Add / Modify / Replace resources
- ⚠️ **Replacement = resource destroyed & recreated**
  - Critical for EC2 with local data

### Dependency Management
- CloudFormation handles:
  - Correct creation order (SG → EC2 → EIP)
  - Correct deletion order
- Fully **declarative**: no manual sequencing

### Resource Tracking
- `Resources` tab = everything created by stack
- `Events` tab = step-by-step lifecycle
- Easy audit & troubleshooting

### Deletion (Best Practice)
- ❌ Do NOT delete resources manually
- ✅ Delete the **stack**
- CloudFormation cleans up **all resources safely**

### Exam Tips (SAA)
- Keywords:
  - *Stack, Template, Change Set, Replacement*
- CloudFormation:
  - Controls full lifecycle (create/update/delete)
  - Automatically tags & manages dependencies
- Manual changes = **anti-pattern**

---
## CloudFormation Service Roles

### Purpose 🔐

- IAM role **assumed by CloudFormation**  
- CFN creates/updates/deletes resources **on your behalf**

### Why Use?

- **Least privilege**  
- Users don’t need resource-level permissions  
- Users only invoke CloudFormation

### Key Exam Rule ⭐

- User **must have `iam:PassRole`**  
- Required to pass role to CloudFormation

### Behavior

- Role specified → CFN uses **role permissions**  
- No role → CFN uses **user permissions**  
- Missing permissions → **stack fails**

### Example

- Role: `S3:*`  
- Create S3 ✅  
- Create EC2 ❌

### Best Practices ✅

- Dedicated CFN roles  
- Minimal permissions  
- Ensure role covers **all stack resources**

---
## Amazon SES

### Purpose 📧

- **Fully managed email service**  
- Send/receive emails at scale

### Access

- **API** or **SMTP**

### Features

- Email metrics (deliveries, bounces, opens)  
- Reputation & spam feedback  
- Inbound + outbound email

### Security 🔐

- **SPF**  
- **DKIM**

### IP Options

- Shared | Dedicated | Customer-owned

### Use Cases ⭐

- Transactional  
- Marketing  
- Bulk emails

---
## Amazon Pinpoint

### What It Is 📣

- **Scalable marketing communication service**  
- Inbound + outbound messaging

### Channels

- **SMS** (core use case)  
- Email  
- Push notifications  
- Voice  
- In-app messages

### Key Features

- User **segmentation & personalization**  
- Campaigns, templates, schedules  
- Receive replies  
- Scales to **billions of messages/day**

### Events & Integrations 🔗

- Delivery, success, replies  
- → **SNS**, **Kinesis Data Firehose**, **CloudWatch Logs**

### Use Cases ⭐

- Marketing campaigns (bulk)  
- Transactional SMS

### Pinpoint vs SNS / SES (Exam Tip ⭐)

- SNS/SES: app manages audience & delivery  
- **Pinpoint: managed campaigns, targeting, scheduling**  
- Best for **full marketing automation**

---
## SSM Session Manager

### What It Is 🔐

- Secure shell access via **AWS Systems Manager**  
- **No SSH**, no keys, no bastion host

### Key Benefits

- Port **22 closed**  
- Works with EC2 + on-prem  
- More secure than SSH

### How It Works

- Instance runs **SSM Agent**  
- Agent connects to **Session Manager**  
- Users connect via AWS console / CLI

### Requirements ⭐

- **SSM Agent installed** (Amazon Linux 2 default)  
- EC2 IAM role with:  
  - `AmazonSSMManagedInstanceCore`  
- Outbound internet or VPC endpoints

### Logging & Auditing 📜

- Session logs → **CloudWatch Logs** or **S3**  
- Full command history

### Supported OS

- Linux  
- Windows  
- macOS

### Access Options (Compare) 🧠

- SSH → port 22 + keys  
- EC2 Instance Connect → port 22  
- **Session Manager → no inbound ports**

### Exam Tips ⭐

- Most secure EC2 access  
- Used when **no SSH allowed**  
- Centralized access + auditing

---
## AWS Systems Manager (Other Features)

### Run Command ▶️

- Execute **commands/scripts** on many instances  
- EC2 + on-prem (SSM Agent required)  
- **No SSH needed**  
- Output → **S3** / **CloudWatch Logs**  
- Status & failures → **SNS**  
- Triggered manually or via **EventBridge**  
- Auditing → **IAM + CloudTrail**

### Patch Manager 🩹

- Automates **OS & app patching**  
- EC2 + on-prem  
- Linux | Windows | macOS  
- Patch **on-demand** or **scheduled**  
- Uses **Maintenance Windows**  
- Compliance & patch reports  
- Core command: `AWS-RunPatchBaseline`

### Maintenance Windows ⏱️

- Define **when** tasks run  
- Includes:  
  - Schedule  
  - Duration  
  - Target instances  
  - Tasks (patching, scripts, installs)  
- Common for patching & updates

### Automation 🤖

- Automate **maintenance & remediation**  
- Uses **SSM Automation Runbooks**  
- Examples:  
  - Restart instances  
  - Create AMIs / snapshots  
- Triggers:  
  - Console / CLI / SDK  
  - **EventBridge**  
  - Maintenance Windows  
  - **AWS Config** (auto-remediation)

### Exam Tips ⭐

- Run Command = remote exec at scale  
- Patch Manager = compliance + OS updates  
- Maintenance Window = scheduling layer  
- Automation = multi-step workflows + remediation

---
## AWS Cost Explorer & Cost Anomaly Detection

### Cost Explorer 💰

- Visualize & analyze **AWS costs & usage**  
- Granularity: total, monthly, hourly, resource-level  
- Custom reports & dashboards  
- **Optimize costs**: Savings Plans recommendations  
- **Forecast usage**: up to 12 months  
- Exam tip: main billing service likely asked

### Key Features

- Identify over/under-utilized resources  
- Compare instance types & usage patterns  
- Forecast spend for cost planning

### Cost Anomaly Detection 🤖

- ML-based monitoring of cost & usage  
- Detects unusual spend **without thresholds**  
- Monitors: services, accounts, tags, cost categories  
- Alerts via **SNS** (individual/daily/weekly)  
- Root cause analysis of anomalies

### Exam Tips ⭐

- Cost Explorer = **visualize + plan + optimize**  
- Cost Anomaly Detection = **automatic spend alerts**  
- Both focus on **cost management & forecasting**

---
## AWS Outposts

### What It Is 🌐

- **Hybrid cloud solution**: AWS services on-premises  
- AWS-managed server racks in your data center  
- Same **APIs, tools, services** as cloud

### Key Benefits

- **Low latency** to on-prem systems  
- **Local data processing** (data may stay on-prem)  
- **Data residency** compliance  
- Simplifies **migration to cloud**  
- Fully managed by AWS (except physical security)

### Supported Services ⭐

- **EC2**, **EBS**, **S3**  
- **EKS**, **ECS**, **RDS**, **EMR**

### Exam Tip 🧠

- Use Outposts when **hybrid cloud** + **on-prem AWS APIs** needed  
- Physical security is your responsibility  
- Enables consistent cloud experience **on-premises**

---
## AWS Batch

### What It Is ⚙️

- **Fully managed batch processing**  
- Runs batch jobs at **any scale**

### Batch Jobs

- Jobs with **start & end**  
- Not streaming / always-on  
- Example: nightly processing

### How It Works

- Submit jobs to **Batch Queue**  
- AWS Batch provisions **EC2 or Spot**  
- Auto-scales compute & memory  
- Runs jobs as **Docker containers (ECS-based)**

### Key Features ⭐

- Any runtime (Docker)  
- No execution time limit  
- Uses EC2 storage (EBS / instance store)  
- Cost-optimized via Spot instances

### Common Architecture

- S3 upload → Batch job triggered  
- ECS cluster processes job  
- Output → S3

### Batch vs Lambda (Exam Tip 🧠)

- **Lambda**: serverless, 15 min limit, limited disk/runtime  
- **Batch**: EC2-based, no time limit, large storage, any runtime

### When to Use ⭐

- Long-running  
- Compute-intensive  
- Large-scale batch workloads

---
## Amazon AppFlow

### What It Is 🔄

- **Fully managed data integration service**  
- Transfer data between **SaaS apps & AWS**

### Common Sources ⭐

- **Salesforce** (exam favorite)  
- SAP  
- Zendesk  
- Slack  
- ServiceNow

### Destinations

- **Amazon S3**  
- **Amazon Redshift**  
- Non-AWS (Snowflake, Salesforce)

### Triggers

- Scheduled  
- Event-based  
- On-demand

### Features

- Data filtering & validation  
- Encryption in transit  
- **AWS PrivateLink** for private transfer

### Exam Tips 🧠

- AppFlow = **no custom integration code**  
- Used for **SaaS ↔ AWS data movement**  
- Remember **Salesforce + S3/Redshift**

---
## AWS Amplify

### What It Is 🚀

- **Web & mobile app development platform**  
- High-level service (think **Elastic Beanstalk for frontend apps**)

### Purpose

- Build, connect, and deploy **full-stack apps**  
- Single place to manage AWS backend services

### Backend (via Amplify CLI) ⭐

- **S3** (storage)  
- **Cognito** (auth)  
- **AppSync / API Gateway** (APIs)  
- **Lambda** (functions)  
- **DynamoDB** (data)  
- AI/ML (SageMaker, Lex, Predictions)

### Frontend

- Amplify Libraries (web & mobile)  
- Supports many frameworks

### Deployment

- Source: GitHub, CodeCommit, GitLab, Bitbucket  
- Deploy via **Amplify Console**  
- Uses **CloudFront** for hosting

### Key Features

- Auth, APIs (REST/GraphQL)  
- CI/CD  
- Analytics, Pub/Sub, monitoring

### Exam Tips 🧠

- Amplify = **full-stack app accelerator**  
- Best for **web/mobile dev teams**  
- Abstracts complex AWS setup

---
## AWS Instance Scheduler

### What It Is ⏱️

- **AWS Solution** (not a native service)  
- Deployed via **CloudFormation**  
- Automatically **start/stop resources** to save costs

### Purpose 💰

- Reduce costs (up to \~70%)  
- Stop resources **outside business hours**

### Supported Resources ⭐

- **EC2 instances**  
- **Auto Scaling Groups**  
- **RDS** (incl. clusters)

### How It Works

- Schedules stored in **DynamoDB**  
- **Lambda** checks schedules  
- Lambdas start/stop resources  
- Uses **tags** to control scheduling

### Key Features

- Cross-account & cross-region  
- Production-ready AWS Solution  
- Optional RDS snapshot on stop

### Exam Tips 🧠

- Instance Scheduler = **cost optimization**  
- Implemented with **CFN + Lambda + DynamoDB**  
- Use when resources don’t need 24/7 runtime