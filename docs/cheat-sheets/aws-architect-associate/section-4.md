# RDS, Aurora and ElastiCache

- [RDS, Aurora and ElastiCache](#rds-aurora-and-elasticache)
  - [AWS RDS Overview](#aws-rds-overview)
  - [RDS Read Replicas vs Multi-AZ](#rds-read-replicas-vs-multi-az)
  - [Creating \& Using an Amazon RDS Instance](#creating--using-an-amazon-rds-instance)
  - [Amazon RDS Custom](#amazon-rds-custom)
  - [Amazon Aurora](#amazon-aurora)
  - [Amazon Aurora – Advanced Concepts](#amazon-aurora--advanced-concepts)
  - [RDS \& Aurora: Backups, Security, Proxy](#rds--aurora-backups-security-proxy)
  - [Amazon ElastiCache](#amazon-elasticache)
  - [Common Network \& Database Ports](#common-network--database-ports)


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
## RDS & Aurora: Backups, Security, Proxy

### 💾 RDS Automated Backups
- Daily full backup + transaction logs every **5 min**
- **Point-in-time recovery (PITR)** up to 5 min ago
- Retention: **1–35 days**
- Set **0 days = disabled** (RDS only)

### 📸 Manual DB Snapshots
- User-triggered
- **Retained indefinitely**
- Used for long-term backup & cost-saving tricks
- Restore always creates a **new DB**

### 💰 Cost-Saving Exam Trick
- Take snapshot → delete RDS → keep snapshot
- Restore snapshot when needed
- Snapshot storage cheaper than running DB

### 💾 Aurora Backups
- Automated backups **cannot be disabled**
- Retention: **1–35 days**
- PITR supported
- Manual snapshots supported (infinite retention)

### 🔄 Restore Options
- Backup/snapshot → **new DB**
- Restore **RDS MySQL from S3**
- Restore **Aurora MySQL from S3**:
  - Requires **Percona XtraBackup**
- On-prem → S3 → RDS/Aurora

### 🧬 Aurora Database Cloning
- Fast, cost-effective copy of Aurora cluster
- Uses **copy-on-write**
- No snapshot/restore needed
- Ideal for **staging from prod**

---

### 🔐 RDS & Aurora Security

#### 🔒 Encryption at Rest
- Uses **KMS**
- Defined **at launch only**
- Unencrypted DB → snapshot → restore encrypted
- Unencrypted master → replicas **cannot** be encrypted

#### 🔐 Encryption in Transit
- TLS supported by default
- Clients use AWS-provided TLS certs

#### 👤 Authentication
- Username/password
- **IAM authentication** supported

#### 🌐 Network Security
- Controlled via **Security Groups**
- No SSH access (managed service)
- Exception: **RDS Custom**

#### 📜 Audit Logs
- Enable DB audit logs
- Export to **CloudWatch Logs** for retention

---

### 🔌 Amazon RDS Proxy

### 🎯 Purpose
- **Connection pooling** for RDS & Aurora
- Reduces DB CPU/RAM & connection exhaustion
- Critical for **Lambda-heavy workloads**

### ⚡ Key Benefits
- Fully managed, **serverless**, auto-scaling
- **Multi-AZ**, highly available
- Reduces failover time by **up to 66%**
- No app code changes

### 🔐 Security Benefits
- Enforce **IAM authentication**
- Credentials stored in **AWS Secrets Manager**
- **Never publicly accessible** (VPC-only)

### 🧩 Supported Engines
- RDS: MySQL, PostgreSQL, MariaDB, SQL Server
- Aurora: MySQL & PostgreSQL

### 📝 Exam Tips
- “Too many DB connections / Lambda” → **RDS Proxy**
- “Reduce failover time” → **RDS Proxy**
- “Encrypt existing DB” → snapshot + restore
- Aurora backups **cannot be disabled**
- Cloning = fastest way to copy Aurora DB


  ---
  ## Amazon ElastiCache

### Overview
- Managed **in-memory cache** (Redis / Memcached)
- Sub-millisecond latency
- Reduces **RDS read load**
- Helps build **stateless applications**


### Engines
- **Redis / Valkey (recommended)**
- Multi-AZ + auto-failover
- Read replicas
- Persistence (AOF)
- Backup & restore
- Advanced data types (sets, sorted sets)
- **Memcached**
- Sharding only (no replication)
- No HA (node failure = data loss)
- Multi-threaded


### Common Architectures
- **Cache-aside (read-through)**
- Cache hit → return data
- Cache miss → read DB → write cache
- **Session Store**
- Store user sessions in cache
- Enables stateless apps


### Deployment
- **Serverless** or **Node-based cluster**
- Cluster mode:
- Disabled = 1 shard + replicas
- Enabled = multiple shards
- Runs in **VPC** (subnet groups)
- Supports **Outposts**


### Security ⭐
- **IAM auth**: Redis only (API-level)
- **Redis AUTH**: password / auth token
- **SSL in-transit encryption**
- **Memcached**: SASL authentication


### Cache Loading Patterns ⭐
- **Lazy Loading**: read → cache on miss (stale possible)
- **Write Through**: write DB + cache (no stale)
- **Session Store**: TTL-based expiration


### Redis Special Use Case ⭐
- **Gaming Leaderboards**
- Uses **Sorted Sets**
- Real-time ranking
- Uniqueness + ordering


### Exam Tips ⭐
- Redis = HA, durability, advanced features
- Memcached = simple, fast, no HA
- Sorted Sets = leaderboard questions
- Cache invalidation = hardest problem


---

## Common Network & Database Ports


## Common Network & Database Ports

```md
### Important / General Ports ⭐
- **FTP**: 21
- **SSH**: 22
- **SFTP**: 22 (over SSH)
- **HTTP**: 80
- **HTTPS**: 443 ⭐ (most important)

### RDS / Database Ports ⭐
- **PostgreSQL**: 5432
- **MySQL**: 3306
- **MariaDB**: 3306 (same as MySQL)
- **Oracle RDS**: 1521
- **Microsoft SQL Server**: 1433
- **Amazon Aurora**:
  - PostgreSQL-compatible: 5432
  - MySQL-compatible: 3306

### Exam Tips ⭐
- Do **not memorize all ports**
- Be able to **recognize service vs database ports**
- **HTTPS (443)** is the most commonly referenced
- Database ports often appear in **Security Group questions**
```
