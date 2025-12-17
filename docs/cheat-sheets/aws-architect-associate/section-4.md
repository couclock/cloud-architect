# RDS, Aurora and ElastiCache

Prompt to use:

Please summarize the following transcript into a very compact AWS Solutions Architect Associate (SAA) revision cheat sheet.
Include a second-level Markdown title (##) at the top using the section’s main topic.
Format the rest in raw Markdown inside a code block, with no separators.
Use short bullet points, minimal wording, and highlight only SAA-relevant concepts, AWS services, rules, exam tips, and best practices.
Use simple icons when relevant, but keep them limited.
Keep the cheat sheet extremely concise and easy to memorize.
Here’s the transcript:

## AWS RDS Overview
- 🗄️ RDS = managed **relational (SQL)** database service
- 📊 Query language: **SQL**

**Supported Engines (memorize)**
- PostgreSQL
- MySQL
- MariaDB
- Oracle
- Microsoft SQL Server
- IBM DB2
- Aurora (AWS proprietary ⭐)

**Why RDS vs EC2-hosted DB**
- ✅ Fully managed provisioning
- 🔄 OS patching handled by AWS
- 💾 Automated backups + **Point-in-Time Restore**
- 📈 Monitoring & performance dashboards
- 📚 **Read Replicas** → scale reads
- 🟦 **Multi-AZ** → high availability & DR
- 🕒 Maintenance windows
- 📏 Scaling:
  - Vertical: instance size
  - Horizontal: read replicas
- 💽 Storage backed by **EBS**
- 🚫 No SSH access (managed service tradeoff)

**RDS Storage Auto Scaling (Exam Tip ⭐)**
- 📦 Automatically increases DB storage
- ⚙️ Set **max storage limit**
- 📉 Triggers when:
  - <10% free storage
  - Low storage ≥ 5 min
  - ≥ 6 hrs since last scaling
- 🔁 No downtime/manual ops
- 🎯 Best for **unpredictable workloads**
- ✅ Supported by **all RDS engines**


---
## RDS Read Replicas vs Multi-AZ

### RDS Read Replicas (Scale Reads 📈)
- Purpose: **read scaling**
- Up to **15 replicas**
- Placement:
  - Same AZ
  - Cross AZ (same region)
  - Cross Region 🌍
- Replication: **Asynchronous**
  - ⚠️ **Eventually consistent**
- Usage:
  - **SELECT only** (no INSERT/UPDATE/DELETE)
- App must:
  - Update connection string to read replicas
- Can be **promoted** to standalone DB (breaks replication)
- Common use case:
  - Reporting / analytics offload from prod DB

### Networking Cost 💰
- Same region (even cross AZ): **FREE replication**
- Cross region: **Inter-region data transfer cost**

### RDS Multi-AZ (High Availability / DR 🛡️)
- Purpose: **Disaster Recovery**
- Architecture:
  - Master (AZ A) + Standby (AZ B)
  - **Synchronous replication**
- Access:
  - Single **DNS endpoint**
  - Auto failover on:
    - AZ outage
    - Instance/storage/network failure
- Standby:
  - 🚫 No reads
  - 🚫 No writes
- ❌ Not for scaling

### Read Replicas + Multi-AZ (Exam Tip ⭐)
- ✅ Read Replicas **can themselves be Multi-AZ**

### Single-AZ → Multi-AZ (Exam Tip ⭐)
- ✅ **Zero-downtime**
- Action:
  - Modify DB → enable Multi-AZ
- Behind the scenes:
  - Snapshot taken
  - Standby restored
  - Sync established


---
## Creating & Using an Amazon RDS Instance

### Database Creation
- Console → **RDS → Create database**
- Creation method:
  - **Standard Create** ⭐ (shows all exam-relevant options)
- Engines:
  - MySQL, MariaDB, PostgreSQL, Oracle, SQL Server
  - Aurora (covered separately)
- Templates:
  - Free tier / Dev-Test / Production (preselect settings)

### Availability & Durability
- Options:
  - **Single-AZ** (free tier)
  - **Multi-AZ** (standby for DR)
  - Multi-AZ DB Cluster
- Single-AZ → Multi-AZ:
  - Modify DB, **zero downtime**

### Instance Configuration
- Instance classes:
  - Standard
  - Memory-optimized
  - **Burstable (db.t3.micro / db.t2.micro)** ⭐ free tier
- Scaling:
  - Vertical: change instance type

### Storage
- Backed by **EBS**
- Types:
  - **gp2/gp3** (general purpose)
  - io1/io2 (high IOPS, prod)
- **Storage Auto Scaling** ⭐
  - Set max storage limit

### Connectivity & Security
- Networking:
  - VPC + Subnet Group
  - Public access: Yes/No
- Security Groups:
  - Allow DB port (MySQL: **3306**)
- Auth methods:
  - Username/password ⭐
  - IAM DB authentication
  - Kerberos

### Backups & Maintenance
- Automated backups:
  - Retention: **1–35 days**
  - 0 days = disabled
- **Point-in-Time Restore**
- Maintenance window (minor upgrades)
- **Deletion protection** ⭐

### Monitoring & Logs
- CloudWatch metrics:
  - CPU, connections, IOPS
- Enhanced monitoring (optional)
- Export DB logs to CloudWatch

### Snapshots & Restore
- Manual snapshots
- Restore to:
  - Point in time
  - New DB
  - Different region 🌍

### Read Replicas
- Create directly from DB
- Used for **read scaling**
- Optional Multi-AZ for replica ⭐

### Exam Tips ⭐
- RDS = **fully managed** (no SSH)
- Free tier: db.t2.micro / db.t3.micro
- Must disable deletion protection to delete DB
- Multi-AZ = HA/DR, not scaling
- Read Replicas = scaling reads only

---
## Amazon RDS Custom

### RDS vs RDS Custom
- **Standard RDS**
  - Fully managed DB + OS
  - 🚫 No OS / DB-level access
  - No SSH / SSM

- **RDS Custom** ⭐
  - Managed setup + **customer-controlled OS & DB**
  - Supported engines:
    - **Oracle**
    - **Microsoft SQL Server**
  - Use cases:
    - OS customization
    - Install patches / agents
    - Enable native DB features

### Access & Customization
- ✅ Access underlying **EC2 instance**
- Login via:
  - **SSH**
  - **SSM Session Manager**
- Can modify:
  - OS settings
  - DB internals

### Best Practices (Exam Tips ⭐)
- 🛑 **Disable automation mode** before custom changes
  - Prevents AWS from patching/scaling during changes
- 📸 **Take DB snapshot first**
  - Required for recovery if changes break DB

### Key Exam Takeaways ⭐
- RDS Custom ≠ standard RDS
- Only for **Oracle & SQL Server**
- Tradeoff:
  - More control 🆚 more responsibility

---
## Amazon Aurora

### Overview
- ⭐ **AWS proprietary** relational DB
- Compatible with:
  - **MySQL**
  - **PostgreSQL**
- Uses same drivers as MySQL/Postgres

### Performance & Cost
- 🚀 ~**5× MySQL**, **3× PostgreSQL** vs RDS
- 💰 ~20% more expensive than RDS
- 💡 More cost-efficient at scale

### Storage Architecture (Key Exam Concept ⭐)
- 🔁 **6 copies of data across 3 AZ**
- Write quorum: **4/6**
- Read quorum: **3/6**
- 🧠 **Self-healing** + peer-to-peer replication
- 📦 **Auto-expanding storage**
  - Starts at **10 GB**
  - Scales to **128–256 TB** (exam: “auto grows”)

### Availability & Failover
- One **writer (master)** instance
- Up to **15 read replicas**
- ⚡ Failover < **30 seconds**
- Any replica can become writer
- Built-in **Multi-AZ by design**

### Read Scaling
- Up to **15 Aurora Replicas**
- 🔄 Faster replication (sub-10 ms lag)
- Supports:
  - Cross-AZ
  - **Cross-region replication**

### Endpoints (Very Important ⭐)
- ✍️ **Writer Endpoint**
  - Always points to current master
- 📖 **Reader Endpoint**
  - Load balances connections across replicas
  - Handles replica auto-scaling
- ⚠️ Load balancing = **connection-level**

### Auto Scaling
- 🔁 Read Replica Auto Scaling
  - Based on CPU / connections
  - Min: 1, Max: 15 replicas
- **Aurora Serverless v2**
  - Uses **ACUs (Aurora Capacity Units)**
  - Scales between min/max ACU automatically

### Backup & Recovery
- Automated backups
- **Backtrack** ⭐
  - Restore DB to any past second
  - Does NOT rely on backups

### Features (Managed Service)
- Automatic failover
- Zero-downtime patching
- Encryption, compliance
- Monitoring & maintenance handled by AWS

### Global Aurora
- 🌍 Cross-region cluster
- Requires compatible engine/version
- Used for global reads & DR

### Exam Takeaways ⭐
- Aurora ≠ RDS
- Built-in HA (no need to enable Multi-AZ)
- Remember:
  - **Shared auto-scaling storage**
  - **Writer vs Reader endpoints**
  - **Up to 15 replicas**
  - **Fast failover**

---
## Amazon Aurora – Advanced Concepts
### 🔁 Replica Auto Scaling
- Scales **Aurora Read Replicas** automatically
- Triggered by metrics (e.g., CPU on reader endpoint)
- Reader endpoint auto-updates to include new replicas
- Improves read scalability, lowers CPU load

### 🎯 Custom Endpoints
- Define subsets of replicas (e.g., large instances)
- Route specific workloads (analytics vs normal reads)
- Reader endpoint usually **not used** once custom endpoints exist
- Enables workload isolation + performance tuning

### ⚡ Aurora Serverless
- Auto-provisioning + auto-scaling DB capacity
- Pay per second; no capacity planning
- Best for **infrequent / unpredictable workloads**
- Client → Aurora-managed proxy → auto-created instances

### 🌍 Aurora Global Database
- Cross-region read scalability + DR
- 1 primary (read/write) + up to **10 secondary regions**
- < **1s replication lag** (exam keyword)
- Up to **16 read replicas per secondary region**
- Failover RTO < **1 minute**
- Use for global low-latency reads + disaster recovery

### 🤖 Aurora Machine Learning
- Run ML predictions via **SQL**
- Integrates with:
  - **SageMaker** (custom ML models)
  - **Amazon Comprehend** (sentiment analysis)
- No ML expertise required
- Use cases: fraud detection, recommendations, ads

### 🐟 Babelfish for Aurora PostgreSQL
- Run **SQL Server (T-SQL)** apps on Aurora PostgreSQL
- Minimal/no code changes
- Keeps SQL Server driver + T-SQL
- Enables easy SQL Server → Aurora migration
- Use with **AWS SCT + DMS** for migration

### 📝 Exam Tips
- Auto scaling applies to **read replicas only**
- Custom endpoints = workload-based routing
- “<1 second cross-region replication” → Global Aurora
- Serverless = unpredictable workloads
- Babelfish = SQL Server compatibility, not MySQL


---
## Cross-Zone Load Balancing (XZLB)

- 🎯 **Goal**: Distribute traffic evenly across all registered targets in all AZs

- 🔄 **With XZLB ON**
  - Each LB node sends traffic evenly to **all** targets (all AZs)
  - Fixes uneven AZ target counts (e.g., 2 vs 8 instances)
  - ALB: **no inter-AZ data charges**
  - NLB/GWLB: **charges apply** for inter-AZ traffic

- 🚫 **With XZLB OFF**
  - Each LB node sends traffic **only to targets in its AZ**
  - Client traffic split by LB nodes → can cause imbalance if AZs differ in target count

![From Udemy course - Ultimate AWS Certified Solutions Architect Associate](images/cross-zone-load-balancing.png)


- ⚙️ **Defaults & Charges**
  - **ALB**: XZLB **ON by default**  
    - Can override per **Target Group** (force ON/OFF)  
    - No inter-AZ data charge
  - **NLB / GWLB**: XZLB **OFF by default**  
    - Enabling = 💰 inter-AZ data charges
  - **CLB**: XZLB OFF by default; enabling = **no charge** (legacy)

- 📝 **Exam Tips**
  - ALB = XZLB always available + free  
  - NLB/GWLB = enabling may incur cost  
  - XZLB ensures even distribution across uneven AZ capacity

  ---
  ## SSL / TLS Certificates & SNI (ELB)

  - 🔐 **SSL/TLS** = In-transit encryption (HTTPS)
  - SSL = legacy term, **TLS** = modern standard
  - Public certs issued by **CAs** (e.g., DigiCert, Let’s Encrypt)
  - Certs expire → must renew

- 🌐 **ELB SSL Termination**
  - Client → **HTTPS** → Load Balancer
  - LB decrypts → backend can use **HTTP** (inside VPC)
  - Uses **X.509 server certificate**

- 🧾 **Certificate Management**
  - Use **ACM (AWS Certificate Manager)** ✅
  - Can import own certs
  - HTTPS listener requires **default cert**
  - Optional additional certs for multiple domains

- 🧠 **SNI (Server Name Indication)** ⭐
  - Client sends **hostname during TLS handshake**
  - LB selects correct SSL cert
  - Enables **multiple domains + certs on one LB**
  - Supported by:
    - ✅ **ALB**
    - ✅ **NLB**
    - ✅ **CloudFront**
    - ❌ **CLB** (old)

- ⚖️ **ELB Certificate Support**
  - **CLB**
    - ❌ One cert only
    - Multiple domains → multiple CLBs
  - **ALB**
    - ✅ Multiple certs per listener
    - Uses **SNI**
  - **NLB**
    - ✅ Multiple certs (TLS listeners)
    - Uses **SNI**

- ⚙️ **Listener Setup**
  - ALB: Listener = **HTTPS :443**
  - NLB: Listener = **TLS**
  - Choose:
    - Cert source (ACM preferred)
    - **SSL/TLS security policy** (legacy vs modern)

- 📝 **Exam Tips**
  - Multiple SSL certs on one LB → **ALB or NLB**
  - SNI = hostname-based cert selection
  - Prefer **ACM** over IAM/import


---

## ELB Connection Draining - Deregistration Delay


- 🔄 Purpose: allow in-flight requests to finish before instance removal
- Names:
  - Classic Load Balancer → Connection Draining
  - ALB / NLB → Deregistration Delay
- When used:
  - Instance deregistered
  - Instance marked unhealthy
- Behavior:
  - ❌ No new connections sent to draining instance
  - ✅ Existing connections allowed to complete
- Timer:
  - Range: 1–3600 seconds
  - Default: 300s (5 min)
  - 0 = disabled (immediate drop)
- Tuning:
  - ⏱ Short requests → low value (e.g. 30s)
  - 📦 Long uploads / long-lived connections → high value
  - Settings on targetGroup level
- Trade-off:
  - Higher value = graceful shutdown but slower scale-in
- 🧠 Exam tip:
  - Ensures zero-downtime deployments & safe instance replacement

---
## Auto Scaling Group (ASG)
- ⚡ Purpose: auto scale EC2 instances based on load  
  - Scale out → add instances (↑ load)  
  - Scale in → remove instances (↓ load)  
- 🔢 Capacity settings:  
  - Min size → minimum instances  
  - Desired → target instances  
  - Max size → maximum instances  
- 🧩 Works with Load Balancer:  
  - Instances auto registered to target group  
  - Health checks from ELB → terminate unhealthy instances  
- 📦 Launch template (required):  
  - AMI, instance type, EBS, security group, IAM role  
  - User data scripts, network/subnet info  
- 🕹 Scaling policies:  
  - Triggered via CloudWatch alarms (CPU, custom metrics)  
  - Scale out policy → add instances  
  - Scale in policy → remove instances  
- 🔄 Behavior:  
  - ASG ensures desired capacity  
  - Automatic replacement of unhealthy instances  
- 🏗 Exam tips:  
  - Free service, pay only for underlying EC2  
  - Always pair with ELB for traffic distribution & health checks  
  - Min/Max/Desired + scaling policies = core ASG logic  

---
## Auto Scaling Policies

- ⚡ Purpose: control ASG scaling behavior  
- 🏷 Types:  
  1. **Dynamic Scaling**  
     - **Target Tracking**: maintain a metric at target (e.g., CPU 40%)  
     - **Step / Simple Scaling**: CloudWatch alarm → add/remove instances in steps  
  2. **Scheduled Scaling**  
     - Predefined scaling actions based on known patterns or events  
  3. **Predictive Scaling**  
     - Forecast load using historical data → schedule scaling ahead of time  
- 📊 Common metrics to scale on:  
  - CPU utilization (average)  
  - RequestCountPerTarget (ALB)  
  - Network in/out (for network-bound apps)  
  - Custom CloudWatch metrics  
- ⏱ Scaling cooldown:  
  - Default 300s (5 min)  
  - Prevents immediate repeated scaling actions  
  - Reduce cooldown with pre-baked AMIs for faster instance readiness  
- 🔄 Target Tracking Example:  
  - Track avg CPU 40% → scale out/in automatically  
  - CloudWatch creates AlarmHigh (scale out) & AlarmLow (scale in)  
- 🧠 Exam tips:  
  - Use target tracking for automatic metric-based scaling  
  - Step/simple scaling for custom CloudWatch alarms  
  - Scheduled for predictable traffic spikes  
  - Predictive for cyclical patterns using ML forecasts  
  - Enable detailed monitoring for 1-min metrics for faster scaling response  
