
# White papers and architectures

- [White papers and architectures](#white-papers-and-architectures)
  - [AWS Well-Architected Framework](#aws-well-architected-framework)
  - [AWS Well-Architected – Operational Excellence](#aws-well-architected--operational-excellence)
  - [AWS Well-Architected – Security](#aws-well-architected--security)
  - [AWS Well-Architected – Reliability](#aws-well-architected--reliability)
  - [AWS Well-Architected – Performance Efficiency](#aws-well-architected--performance-efficiency)
  - [AWS Well-Architected – Cost Optimization](#aws-well-architected--cost-optimization)
  - [AWS Well-Architected – Sustainability](#aws-well-architected--sustainability)
  - [AWS Trusted Advisor](#aws-trusted-advisor)
  - [AWS Architecture Resources](#aws-architecture-resources)


[AWS Well-architected Framework](https://aws.amazon.com/architecture/well-architected/)

[Disaster Recovery white papers](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-workloads-on-aws.html)

## AWS Well-Architected Framework

### What It Is 🧭

- AWS **best-practice framework + review tool**  
- Helps design **secure, reliable, efficient** workloads

### Core Principles

- Don’t guess capacity → **Auto Scaling**  
- Test at **production scale**  
- **Automate** everything (IaC)  
- Enable **evolutionary architectures**  
- Design with **data-driven decisions**  
- Improve via **game days**

### The 6 Pillars ⭐

- **Operational Excellence**  
- **Security**  
- **Reliability**  
- **Performance Efficiency**  
- **Cost Optimization**  
- **Sustainability**

### Key Concept

- Pillars are **synergistic**, not trade-offs

### Well-Architected Tool 🛠️

- Review workloads against pillars  
- Answer guided questions  
- Get **risk findings & recommendations**  
- Dashboards, reports, improvement plans

### Lenses

- Well-Architected (default)  
- Serverless  
- SaaS  
- FTR  
- Custom lenses

### Exam Tips 🧠

- Know the **6 pillar names**  
- Tool = architecture **assessment & guidance**  
- Used to identify **high-risk issues**

---
## AWS Well-Architected – Operational Excellence

### 🧠 Pillar Goal
- Run & monitor systems effectively
- Continuously **improve operations**
- Automate where possible ⭐

### 🔄 Core Principles
- Perform ops as **code**
- Make frequent, **small changes**
- Refine procedures regularly
- Anticipate failure
- Learn from failures

### 📊 Monitoring & Observability
- **CloudWatch** (metrics, logs, alarms) ⭐
- **X-Ray** (tracing)
- **CloudTrail** (API audit)

### ⚙️ Automation
- **Infrastructure as Code** (CloudFormation)
- **AWS Systems Manager** ⭐
- Automated responses (Lambda)

### 🔁 Change Management
- CI/CD pipelines
- Rollbacks (blue/green, canary)
- Minimize manual changes

### 🧪 Incident Management
- Runbooks & playbooks
- Event-driven remediation
- Post-incident reviews

### 🎯 Design Best Practices
- Standardize environments
- Limit human intervention
- Use managed services

### 🧪 Exam Tips ⭐
- Ops Excellence = **automation + monitoring**
- Treat ops as code
- Prefer managed services
- Continuous improvement mindset

---
## AWS Well-Architected – Security

### 🧠 Pillar Goal
- Protect **data, systems, assets**
- Manage risk with layered security ⭐

### 🔐 Core Principles
- Strong **identity foundation**
- Enable **traceability**
- Apply security at **all layers**
- Automate security best practices
- Protect data in transit & at rest
- Prepare for security events

### 👤 Identity & Access
- **IAM** (least privilege) ⭐
- MFA everywhere
- Roles over users

### 🛡️ Infrastructure Protection
- **VPC**, security groups, NACLs
- Private subnets
- Edge protection (WAF, Shield)

### 🔍 Detection & Monitoring
- **CloudTrail** ⭐
- **GuardDuty**
- **Security Hub**
- **AWS Config**

### 🔐 Data Protection
- **Encryption** (KMS) ⭐
- TLS for data in transit
- Secrets Manager / Parameter Store

### ⚙️ Automation
- Automated remediation (Lambda)
- Security as code (IaC)

### 🚨 Incident Response
- Playbooks
- Isolation & containment
- Forensics-ready logging

### 🧪 Exam Tips ⭐
- Least privilege always
- Encrypt by default
- Use managed security services
- Defense in depth

---
## AWS Well-Architected – Reliability

### 🧠 Pillar Goal
- Ensure systems **recover quickly**
- Handle **failures gracefully** ⭐

### 🔁 Core Principles
- Automatically recover from failure
- Test recovery procedures
- Scale horizontally
- Stop guessing capacity

### 🏗️ Architecture
- **Multi-AZ** deployments ⭐
- Stateless components
- Decouple with queues (SQS)

### 📈 Scaling
- **Auto Scaling**
- Load Balancers (ALB/NLB)
- On-demand capacity

### 🔄 Fault Tolerance
- Health checks
- Graceful degradation
- Retry with backoff

### 💾 Data Reliability
- Backups & snapshots
- Replication (RDS Multi-AZ)
- DR strategies (pilot light, warm standby)

### 🧪 Testing
- Fault injection
- Game days
- Chaos engineering (basics)

### 🧪 Exam Tips ⭐
- Prefer Multi-AZ
- Use managed services
- Design for failure
- Recovery > prevention

---
## AWS Well-Architected – Performance Efficiency

### 🧠 Pillar Goal
- Use IT resources **efficiently**
- Deliver optimal performance as demand changes ⭐

### 🔄 Core Principles
- Democratize advanced technologies
- Go global in minutes
- Use serverless architectures
- Experiment often

### 🏗️ Compute
- Right instance types
- **Auto Scaling** ⭐
- Serverless (Lambda, Fargate)

### 💾 Storage
- Choose proper storage (S3 tiers, EBS types)
- Caching with **ElastiCache** ⭐
- CDN with **CloudFront**

### 🌐 Network
- Reduce latency (edge services)
- VPC design & placement
- Use private endpoints

### 📊 Monitoring
- Performance metrics
- Load testing
- Continuous tuning

### 🧪 Exam Tips ⭐
- Match service to workload
- Cache frequently accessed data
- Serverless improves performance & agility
- Scale automatically, not manually

---
## AWS Well-Architected – Cost Optimization

### 🧠 Pillar Goal
- Avoid **unnecessary costs**
- Spend money **where it adds value** ⭐

### 🔄 Core Principles
- Adopt a consumption model
- Measure overall efficiency
- Stop spending on undifferentiated work
- Analyze and attribute costs

### 📦 Right Sizing
- Match capacity to demand
- Turn off unused resources ⭐
- Choose correct instance types

### 💰 Pricing Models
- **On-Demand**
- **Reserved Instances / Savings Plans** ⭐
- **Spot Instances**

### 🧰 Cost Management Tools
- **Cost Explorer**
- **AWS Budgets** ⭐
- **Trusted Advisor**

### 💾 Storage Optimization
- S3 lifecycle policies
- EBS snapshot cleanup
- Data tiering

### ⚙️ Automation
- Schedule stop/start
- Auto Scaling
- Event-driven cleanup

### 🧪 Exam Tips ⭐
- Use RIs / Savings Plans for steady workloads
- Spot for fault-tolerant jobs
- Delete idle resources
- Monitor costs continuously

---
## AWS Well-Architected – Sustainability

### 🧠 Pillar Goal
- Minimize **environmental impact**
- Improve energy efficiency ⭐

### 🔄 Core Principles
- Understand your impact
- Establish sustainability goals
- Maximize utilization
- Anticipate and adopt new tech

### 🏗️ Architecture
- **Serverless & managed services** ⭐
- Right-size resources
- Prefer Multi-AZ over overprovisioning

### 📈 Efficiency
- Auto Scaling
- Event-driven workloads
- Avoid idle capacity

### 💾 Data
- Use appropriate storage tiers
- Lifecycle policies
- Minimize data duplication

### 🌍 Global Optimization
- Place workloads closer to users
- Use **CloudFront**

### 🧪 Exam Tips ⭐
- Sustainability = efficiency
- Serverless reduces waste
- Right-sizing supports cost + carbon goals
- Managed services are preferred

---
## AWS Trusted Advisor

### What It Is 🔍

- **Account assessment service**  
- No setup required  
- Provides **best-practice recommendations**

### Check Categories ⭐

- **Cost Optimization**  
- **Performance**  
- **Security**  
- **Fault Tolerance**  
- **Service Limits**  
- **Operational Excellence**

### Core vs Full Checks

- **Core checks**: available to all accounts  
- **Full checks**: require **Business or Enterprise Support**

### Common Checks

- Public **S3 / EBS / RDS snapshots**  
- Open **security group ports**  
- Root account usage  
- Service limits monitoring

### Support Plan Benefits 🧠

- Business / Enterprise:  
  - Full Trusted Advisor checks  
  - **AWS Support API** (programmatic access)

### Exam Tips ⭐

- Trusted Advisor = **high-level account review**  
- Focus on **security & cost optimization**  
- Full features require **paid support plans**

---
## AWS Architecture Resources

### Why It Matters 🏗️

- Real **solution architectures** = key SAA skill  
- Covers classic + serverless designs

### AWS Architecture Center 📐

[https://aws.amazon.com/architecture/](https://aws.amazon.com/architecture/) 

- **2,000+ reference architectures**  
- Diagrams + deep explanations  
- Use cases: DR, WordPress, databases, etc.  
- Formats: **PDF / HTML**  
- Includes best practices & templates

### AWS Solutions Library 🧩

[https://aws.amazon.com/solutions/](https://aws.amazon.com/solutions/)

- **Production-ready AWS solutions**  
- Vetted architectures for business & technical use cases  
- Includes:  
  - Architecture diagrams  
  - **CloudFormation templates**  
  - Implementation guides  
  - GitHub source code

### Browsing Options

- By industry  
- By technology (e.g. serverless)  
- By organization type

### Exam Tips 🧠

- Architecture Center = **reference designs**  
- Solutions Library = **deployable solutions**  
- Know where to find **official AWS architectures**