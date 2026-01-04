
# Disaster Recovery & Migration

- [Disaster Recovery \& Migration](#disaster-recovery--migration)
  - [Disaster Recovery (DR)](#disaster-recovery-dr)
  - [AWS Elastic Disaster Recovery (DRS)](#aws-elastic-disaster-recovery-drs)
  - [AWS Database Migration Service (DMS)](#aws-database-migration-service-dms)
  - [Migrating to Amazon Aurora (MySQL / PostgreSQL)](#migrating-to-amazon-aurora-mysql--postgresql)
  - [On-Premise ↔ AWS Migration Services](#on-premise--aws-migration-services)
  - [AWS Backup](#aws-backup)
  - [AWS Migration Planning \& Rehosting](#aws-migration-planning--rehosting)
  - [Large Data Transfer](#large-data-transfer)
  - [VMware Cloud on AWS – SAA Ultra-Compact](#vmware-cloud-on-aws--saa-ultra-compact)

## Disaster Recovery (DR)

See this [white paper](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-workloads-on-aws.html) to get details.

### Core
- 💥 **Disaster**: Business/financial impact
- 🔁 **DR**: Prepare + recover
- 📘 Common SAA exam topic

### Key Metrics (MEMORIZE)
- **RPO**: Data loss tolerance (backup freq)
- **RTO**: Downtime tolerance
- ⬇️ RPO/RTO ⇒ ⬆️ Cost

### DR Models
- On-prem → On-prem (legacy, $$$)
- On-prem → AWS (hybrid)
- AWS → AWS (multi-region)

### DR Strategies (Cost ⬆️ | RTO/RPO ⬇️)
#### Backup & Restore
- High RPO/RTO, cheapest
- Snapshots → S3/Glacier
- Restore via AMI/snapshots

#### Pilot Light
- Core data always on
- RDS running, EC2 on demand
- Route 53 failover

#### Warm Standby
- Full stack, min size
- ASG + ELB running
- Scale on disaster

#### Multi-Site / Hot Site
- Full prod in 2 sites
- Active-Active, Route 53
- $$$, seconds RTO

### Cloud-Native DR
- Aurora Global DB
- Multi-region active

### Backup & Replication
- EBS/RDS snapshots
- S3 CRR, Glacier
- Snowball, Storage Gateway

### HA & Network
- RDS Multi-AZ, S3, EFS
- Direct Connect + VPN backup

### Automation (BEST PRACTICE)
- CloudFormation, Elastic Beanstalk
- CloudWatch + Lambda

### Chaos Testing
- Netflix Simian Army
- Random failure testing

### Exam Tips 📝
- Start with RPO/RTO
- Cheap = Backup & Restore
- Fast = Warm/Hot
- Pilot Light = data first

---
## AWS Elastic Disaster Recovery (DRS)

### Overview
- 🔁 **AWS Elastic Disaster Recovery (DRS)**
- Formerly **CloudEndure DR**
- Fast DR for **physical, virtual, cloud servers**
- Use case: critical systems, ransomware recovery

### What It Protects
- Databases: Oracle, MySQL, SQL Server
- Enterprise apps: SAP
- OS + apps + data (full server)

### How It Works
- 📦 **Continuous block-level replication**
- 🔧 **AWS Replication Agent** on source servers
- Replicates disks → AWS **staging area**
- Staging uses **low-cost EC2 + EBS**

### Disaster Event
- ⚡ **Failover in minutes**
- Launch production-sized EC2 + EBS
- Minimal **RPO** and **RTO**

### Recovery Flow
- Source → AWS (continuous replication)
- Staging → Production (on disaster)
- 🔄 **Failback** to on-prem / original site when ready

### Key Benefits (Exam-Relevant)
- Near-zero data loss
- Minutes-level recovery
- Works for on-prem → AWS
- Cost-efficient (small staging footprint)

### Exam Tips 📝
- Choose **DRS** for fast DR + minimal RPO/RTO
- Ideal for legacy + enterprise workloads
- Not backups → **continuous replication**
- Supports failover **and** failback

---
## AWS Database Migration Service (DMS)

### Purpose
- 🔄 **Migrate databases** to AWS
- Source DB stays **online**
- Secure, resilient, self-healing

### Core Components
- **DMS**: Data migration + replication
- **SCT (Schema Conversion Tool)**: Schema conversion (if engines differ)
- **Replication Instance**: EC2 (provisioned) or **Serverless**

### Migration Types
- **Homogeneous** (same engine)
  - Oracle → Oracle, Postgres → Postgres
  - ❌ SCT not needed
- **Heterogeneous** (different engines)
  - Oracle / SQL Server → Aurora / MySQL / Postgres
  - ✅ SCT required

### Replication Modes
- **Full Load**: One-time migration
- **CDC (Change Data Capture)**: Continuous replication
- **Full Load + CDC** (most common)

### Sources (Examples)
- On-prem / EC2 DBs: Oracle, SQL Server, MySQL, Postgres
- AWS: RDS, Aurora, S3, DocumentDB
- Other clouds: Azure SQL

### Targets (Examples)
- RDS / Aurora
- Redshift, DynamoDB
- S3, Kinesis, Kafka
- DocumentDB, Neptune

### High Availability
- **Multi-AZ DMS**
  - Primary + standby replication instance
  - Less IO freeze, fewer latency spikes

### Typical Flow (Exam-Style)
1. (If needed) Convert schema with **SCT**
2. Create **Source & Target endpoints**
3. Create **Replication instance** (or serverless)
4. Run **Task** (Full Load + CDC)

### Key Exam Tips 📝
- DMS = **data**, not full servers
- SCT only if **engines differ**
- RDS ≠ engine (engine = MySQL, Postgres, etc.)
- Serverless DMS = no instance sizing
- Common use: on-prem → AWS migration

---
## Migrating to Amazon Aurora (MySQL / PostgreSQL)

### Aurora MySQL from RDS MySQL
- **Snapshot Restore**
  - RDS MySQL snapshot → Aurora MySQL
  - ⛔ Downtime required
  - Fast, simple

- **Aurora Read Replica**
  - Create Aurora RR from RDS MySQL
  - Promote when lag = 0
  - ⏱️ Low downtime, 💲 replication cost

### External MySQL → Aurora MySQL
- **Percona XtraBackup**
  - Backup → S3 → Import to Aurora
  - ✅ Only supported backup tool

- **mysqldump**
  - Dump → pipe into Aurora
  - ⏱️ Slow, no S3

- **AWS DMS**
  - Continuous replication
  - Minimal downtime

### Aurora PostgreSQL
- **From RDS PostgreSQL**
  - Snapshot restore → Aurora
  - Aurora Read Replica → promote

- **External PostgreSQL**
  - Backup → S3 → import via **Aurora S3 extension**
  - Or use **AWS DMS**

### Exam Tips 📝
- Snapshot = fastest, needs downtime
- Read Replica = near-zero downtime
- External DBs use S3-based imports or DMS
- DMS = continuous replication
- Percona only for MySQL S3 import

---
## On-Premise ↔ AWS Migration Services

### OS & VM Options
- 🐧 **Amazon Linux 2 ISO**
  - Run on-prem as VM
  - VMware, KVM, VirtualBox, Hyper-V
- 📦 **VM Import/Export**
  - Import on-prem VMs → EC2
  - Export EC2 VMs → on-prem
  - Useful for DR backups

### Migration Planning
- 🔍 **Application Discovery Service**
  - On-prem server inventory
  - Utilization + dependency mapping
- 📊 **Migration Hub**
  - Track & manage migrations

### Data & App Migration
- 🗄️ **Database Migration Service (DMS)**
  - DB replication
  - On-prem ↔ AWS ↔ AWS
  - Supports many engines
- 🖥️ **Application Migration Service (MGN)**
  - Incremental replication
  - Lift-and-shift live servers

### Big Picture (Exam Focus)
- All services = **on-prem ↔ cloud strategy**
- Know names + purpose only
- DMS = databases
- MGN = servers
- Discovery + Hub = plan & track
- VM Import/Export = VM-level move

---
## AWS Backup

### What It Is
- 🗄️ Centralized, fully managed backups
- No scripts, single control plane

### Supports
- EC2, **EBS**
- **RDS / Aurora**
- **DynamoDB**
- **S3**
- EFS, FSx, Storage Gateway

### Core Features
- ⏱️ Scheduled + on-demand
- 🌍 Cross-Region (DR)
- 🏢 Cross-Account
- ♻️ Point-in-time recovery

### Backup Plans
- Frequency + window
- Cold storage transition
- Retention period
- Templates or custom

### Resource Selection
- By **resource type**
- By **tags** (e.g. `Env=Prod`)

### Backup Vault
- AWS-managed storage
- Region copy supported

### Vault Lock 🔒
- **WORM** backups
- No delete (even root)
- Ransomware protection

### Exam Tips 📝
- AWS Backup = centralized backups
- Tags = automation
- Vault Lock = compliance
- DR = Cross-Region backups

---
## AWS Migration Planning & Rehosting

### Plan Migration
- On-prem → AWS needs planning
- Fresh start = no migration

### Discovery
- 🔍 **Application Discovery Service**
  - Inventory + utilization
  - Dependency mapping
- Agentless = VM + performance
- Agent = deep process + network data
- 📊 View in **Migration Hub**

### Move Servers
- 🖥️ **Application Migration Service (MGN)**
  - Lift-and-shift (rehost)
  - Continuous disk replication
  - Staging EC2 → production EC2
  - Minimal downtime

### Exam Tips 📝
- Discovery = plan & order
- MGN = migrate servers
- Agentless = basic
- Agent = deep
- Fastest on-prem → AWS = MGN

---
## Large Data Transfer

### Transfer Options
- 🌐 **Internet / VPN**
  - Immediate setup
  - Slow for large data (e.g. 200 TB @100 Mbps ≈ 185 days)

- 🔌 **Direct Connect**
  - Faster (1 Gbps ≈ 18.5 days)
  - One-time setup (~1 month)

- 📦 **AWS Snowball**
  - Best for **one-off large transfers**
  - End-to-end ≈ 1 week
  - Can combine with DMS for DB

- 🔄 **Ongoing Transfers**
  - Site-to-Site VPN
  - Direct Connect
  - DMS / DataSync

### Exam Tips 📝
- Small data → Internet/VPN
- Large one-off → Snowball
- Ongoing → DMS / DataSync
- Direct Connect → faster, long setup

---
## VMware Cloud on AWS – SAA Ultra-Compact

### What It Is
- Extend on-prem VMware to AWS
- Manage **vSphere, vSAN, NSX** across on-prem + cloud
- Hybrid / private / public options

### Use Cases
- ⬆️ Extend compute & storage to cloud
- 🖥️ Migrate VMware workloads to AWS
- 🌐 Run prod workloads across multiple DCs
- 🔄 Disaster Recovery strategy

### AWS Integration
- Access AWS services:
  - EC2, S3, FSx, RDS, Redshift, Direct Connect

### Exam Tips 📝
- VMware Cloud = hybrid extension
- Leverages existing VMware skills
- Enables DR + AWS service usage
