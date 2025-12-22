# Solution architect discussions

Prompt to use:

Please summarize the following transcript into a very compact AWS Solutions Architect Associate (SAA) revision cheat sheet.
Include a second-level Markdown title (##) at the top using the section’s main topic.
Format the rest in raw Markdown inside a code block, with no separators.
Use short bullet points, minimal wording, and highlight only SAA-relevant concepts, AWS services, rules, exam tips, and best practices.
Use simple icons when relevant, but keep them limited.
Keep the cheat sheet extremely concise and easy to memorize.
Here’s the transcript:

## whatsthetime.com - EC2 → ELB → ASG → Multi-AZ Architecture Evolution

### Phase 1: Single EC2 (PoC) 🧪
- Public EC2 + **Elastic IP**
- Simple, cheap, downtime acceptable
- ❌ Single point of failure
- ❌ No scaling

### Phase 2: Vertical Scaling ⬆️
- Upgrade instance type (t2.micro → m5.large)
- Keeps Elastic IP
- ❌ Requires stop/start → downtime
- Limited scalability

### Phase 3: Horizontal Scaling (Manual) ➕
- Multiple EC2 instances
- Multiple Elastic IPs
- ❌ Users must know many IPs
- ❌ Elastic IP limit (5/region)
- Hard to manage

### Phase 4: Route 53 A Records 🌐
- Use **Route 53 A record** → returns EC2 IPs
- No more Elastic IPs
- ❌ High TTL → stale IPs
- ❌ Removed instances still queried
- Not suitable for dynamic scaling

### Phase 5: Load Balancer + Alias ⚖️
- Public **ELB**, private EC2s
- Route 53 **Alias record** → ELB
- ELB handles:
  - Health checks
  - Traffic distribution
- ✅ No downtime when instances change
- Security Groups: EC2 allows traffic **only from ELB**

### Phase 6: Auto Scaling Group 🔄
- EC2s managed by **ASG**
- Scale in/out based on demand
- Works with ELB health checks
- ✅ Less ops, better cost control

### Phase 7: Multi-AZ High Availability 🏗️
- ELB + ASG span **multiple AZs**
- Survives AZ failure
- ✅ Highly available & resilient
- Exam default for production apps

### Phase 8: Cost Optimization 💰
- **Reserved Instances** for ASG minimum capacity
- **On-Demand** for burst
- Optional **Spot Instances** (risk of termination)

### Key Exam Takeaways 📝
- Elastic IP ≠ scalable
- Route 53 A record + high TTL ❌ for dynamic infra
- **Alias record required for ELB**
- ELB + ASG + Multi-AZ = standard HA pattern
- Health checks prevent traffic to bad instances
- Security Groups often reference ELB SG
- Architecture evolves with requirements

---
## Stateful Web Application – MyClothes.com

### Overview
- E-commerce website with shopping cart
- Must scale horizontally
- Web tier should remain **stateless**
- User data and session state externalized

### The Problem
- Load balancer sends requests to different EC2 instances
- Shopping cart stored on instance → cart is lost
- Poor user experience

### Session Management Solutions
- **Sticky Sessions (ELB)**
  - Same instance per user
  - Simple but not resilient
  - Cart lost if instance terminates

- **Client-side Cookies**
  - Cart stored in browser
  - Stateless web tier
  - Size limit (~4 KB) and security risks

- **Server-side Sessions (Recommended)**
  - Client sends a session ID
  - Session data stored in **ElastiCache**
  - Secure, fast, scalable
  - Alternative: DynamoDB

### Data Storage & Scaling
- **RDS**
  - Persistent user data (addresses, orders)
- **Read Replicas**
  - Scale read traffic
- **ElastiCache (Lazy Loading)**
  - Cache frequent reads
  - Reduce RDS load, improve latency

### High Availability
- Route 53 (managed, HA)
- Application Load Balancer (Multi-AZ)
- Auto Scaling Group (Multi-AZ)
- RDS Multi-AZ (standby)
- ElastiCache Redis Multi-AZ

### Security
- ALB: open to Internet (HTTP/HTTPS)
- EC2: allow traffic only from ALB
- ElastiCache & RDS: allow traffic only from EC2

### Key Exam Takeaways
- Keep web tier stateless
- Store sessions in ElastiCache
- Cache ≠ database
- Read replicas scale reads, not HA
- Multi-AZ = high availability (higher cost)

---
## Scalable WordPress on AWS (Stateful App)

- 🧱 **App Type**: Stateful web app (WordPress)
- 🎯 **Goal**: Highly available, scalable, multi-AZ architecture

**Database Layer**
- 🗄️ MySQL on **RDS** (baseline)
- ⭐ Prefer **Aurora MySQL**
  - Multi-AZ by default
  - Read replicas
  - Global DB (optional)
  - Less ops, better scaling
- 📌 Exam tip: Aurora = managed + high performance

**File Storage (Images / Media)**
- ❌ **EBS**
  - AZ-scoped
  - One EC2 ↔ one EBS
  - ❗ Breaks with multiple instances/AZs
- ✅ **EFS**
  - NFS-based shared filesystem
  - Multi-AZ access
  - Mounted by many EC2s
  - Uses ENIs per AZ
- 📌 Exam tip: Shared files across EC2s → EFS

**Scaling Pattern**
- 👥 ALB + Auto Scaling EC2
- 🗂️ Shared storage via EFS
- 🗄️ Central DB via RDS/Aurora

**Cost Trade-offs**
- 💰 EBS: cheaper, single-instance use
- 💰💰 EFS: more expensive, required for shared state
- 📌 Architect choice = balance cost vs scalability

**Key Takeaways**
- Stateful + scale → separate DB + shared file system
- EBS ≠ scalable shared storage
- EFS = standard solution for WordPress media

---
## Fast Application Instantiation
- ⚡ **Goal**: Reduce startup time for EC2, DBs, storage

**EC2 Application Deployment**
- ⭐ **Golden AMI**
  - Preinstalled OS + apps + dependencies
  - Launch-ready EC2
  - Fastest startup
  - 📌 Exam: Preferred for rapid scaling
- 🧩 **User Data (Bootstrap)**
  - Runs at first boot
  - Dynamic config only (DB URL, secrets)
  - ❌ Slow for full installs
- ✅ **Best Practice**: Golden AMI + minimal user data

**Elastic Beanstalk**
- Uses hybrid model
  - Prebuilt AMI
  - User data for env config
- 📌 Exam: Abstracts EC2 bootstrapping

**Databases**
- 🗄️ **RDS from Snapshot**
  - Restores schema + data
  - Much faster than reloading data
- 📌 Exam: Snapshot restore = quick DB recovery

**Storage**
- 💾 **EBS from Snapshot**
  - Preformatted
  - Data already present
  - Faster than new empty volume

**Key Exam Takeaways**
- Golden AMI = fastest EC2 launch
- User data = dynamic config, not heavy installs
- Snapshots = speed for RDS & EBS
- Think: startup time + automation

---
## AWS Elastic Beanstalk Overview

### What It Is
- 🚀 Managed app deployment service
- Focus on **code**, AWS manages infra
- Free service (pay for resources)

### What It Creates
- ALB + ASG + EC2
- Optional RDS / ElastiCache
- Monitoring, scaling, health checks
- Built on **CloudFormation**

### Core Concepts
- 📦 Application: logical container
- 🏷️ Version: app code iteration
- 🌍 Environment: runs 1 version
- Multiple envs: dev / test / prod

### Environment Tiers
- 🌐 Web Tier: ALB → ASG → EC2
- ⚙️ Worker Tier: SQS → EC2 workers
- Worker scales on queue depth

### Deployment Modes
- 🧪 Single Instance
  - 1 EC2 + Elastic IP
  - Dev only
- 🏭 High Availability
  - ALB + Multi-AZ ASG
  - Prod

### Platforms
- Node.js, Java, .NET, Python, PHP, Ruby
- Go, Docker (single / multi)
- 📌 Deploy “anything”

### Operations
- Upload version → deploy
- Built-in logs, metrics, health
- Configurable but abstracted

### Exam Tips
- Beanstalk = standard web apps
- Code-centric, infra automated
- Apps → Beanstalk
- Custom infra → CloudFormation
