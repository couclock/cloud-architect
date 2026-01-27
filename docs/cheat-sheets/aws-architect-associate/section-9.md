# AWS Storage Extra

- [AWS Storage Extra](#aws-storage-extra)
  - [AWS Snowball / Snow Family](#aws-snowball--snow-family)
  - [Amazon FSx](#amazon-fsx)
  - [AWS Hybrid \& Storage Gateway](#aws-hybrid--storage-gateway)
  - [AWS Transfer Family](#aws-transfer-family)
  - [AWS DataSync](#aws-datasync)
  - [AWS Storage Overview](#aws-storage-overview)

## AWS Snowball / Snow Family 

### Overview

- ❄️ Physical, secure edge devices for **data migration** \+ **edge compute**   
- Use when internet is slow, costly, unreliable, or \>\~1 week transfer  
- Transfers **TB–PB** data between on-prem ⇆ AWS (mainly S3)

### Device Types

- Storage Optimized → \~210 TB usable → bulk migration  
- Compute Optimized → \~28 TB \+ stronger compute  
- Supports **EC2 \+ Lambda at edge**

### Use Cases

- Import → Ship device → AWS loads → **S3**  
- Export → AWS loads from **S3** → ship to you  
- Edge compute for offline/remote sites (ships, mines, trucks)  
  - preprocess, analytics, ML, media transcode

### Security & Operations

- Encrypted by default  
- Requires IAM role for S3 write access  
- Job setup: import/export/edge compute → ship → return  
- Notifications \+ shipping labels included

### Exam Tips ✅

- Choose Snowball when:   
  - Very large datasets / limited bandwidth / high network cost  
- ❌ Cannot import directly to Glacier → Import to **S3**, then **Lifecycle → Glacier** • Know difference: **Storage vs Compute Optimized**  
- Snowball ≠ long-term storage; it’s migration \+ edge compute

---
## Amazon FSx

### 💡 Core Idea

- Managed **high-performance 3rd-party file systems** on AWS  
- Like RDS but for file systems  
- Main types: **Windows FS**, **Lustre**, **NetApp ONTAP**, **OpenZFS**

### 🪟 FSx for Windows File Server

- SMB \+ NTFS, integrates **Active Directory**  
- Supports ACLs, quotas, Multi-AZ  
- Backup to S3, supports Linux mounting too  
- SSD (low latency) / HDD (cheaper)  
- DFS for hybrid w/ on-prem  
- Use for: Windows shares, enterprise apps, home dirs

### 🚀 FSx for Lustre

- **HPC / ML / Big Data** keyword ➜ choose Lustre  
- Massive throughput \+ sub-ms latency  
- SSD (IOPS/small random) vs HDD (throughput/large sequential)  
- **S3 integration** → read as FS, write back to S3  
- Accessible via VPN / DX  
- Deployment:  
  - **Scratch**: temp, no replication, highest perf  
  - **Persistent**: replicated in AZ, durable long-term

### 📦 FSx for NetApp ONTAP

- Managed **NetApp** on AWS  
- Protocols: **NFS, SMB, iSCSI**  
- Broad compatibility: Linux / Windows / macOS / VMware  
- Auto grow/shrink, snapshots, replication  
- **Compression \+ deduplication**  
- **Instant cloning** for testing
- **SnapMirror** to replicate data from a source FSx for ONTAP to a destination FSx for ONTAP.

### 🧱 FSx for OpenZFS

- Managed **ZFS** on AWS  
- Protocol: **NFS only**  
- Very high performance (\<0.5ms latency, \~1M IOPS)  
- Snapshots \+ compression  
- **No deduplication**  
- Supports instant cloning

### 🛠️ General Exam Notes

- Multi-AZ available (Windows / ONTAP)  
- Performance \+ storage tier choices matter  
- Know: **Windows \= SMB**, **Lustre \= HPC**, **ONTAP \= enterprise NAS**, **ZFS \= Linux workloads**  
- Many integrate with on-prem via VPN/DX

---
## AWS Hybrid & Storage Gateway

### 🌐 Hybrid Cloud Basics

- Hybrid \= 🤝 on-prem \+ AWS  
- Reasons: migration, compliance, DR, burst workloads  
- Storage: Block(EBS), File(EFS/FSx), Object(S3/Glacier)

### 🧩 Storage Gateway Overview

- Bridge on-prem ↔ AWS  
- Deploy: VMware / Hyper-V / KVM / EC2  
- Uses: DR, backup, migration, extend storage, local cache  
- Local caching \= low latency

### 📁 S3 File Gateway

- Expose S3 to on-prem via NFS / SMB  
- Local cache for recently accessed files  
- Supports: Standard / IA / 1Z-IA / Intelligent-Tiering  
- ❌ No direct Glacier (use Lifecycle to archive)  
- Needs IAM role  
- SMB integrates with AD auth

### 💾 Volume Gateway (Block Storage)

- iSCSI → backed by S3 \+ EBS snapshots  
- Cached Volumes → primary in S3, local cache \= hot data  
- Stored Volumes → primary on-prem, async sync to S3  
- Use: on-prem volume backup & recovery

### 🎞️ Tape Gateway

- Virtual Tape Library (VTL)  
- iSCSI-VTL \+ major backup tools  
- Stores in S3 → archive to Glacier / Deep Archive

### 🧠 Exam Tips

- Need S3 via NFS/SMB? → File Gateway  
- Need block backup via iSCSI? → Volume Gateway  
- Still using tapes? → Tape Gateway  
- Glacier via lifecycle, not File Gateway direct

---
## AWS Transfer Family

### 💡 Core Idea

- Managed service to transfer files **into/out of S3 or EFS**  
- Avoids using S3 APIs or EFS NFS directly  
- Fully managed, scalable, highly available

### 🔹 Supported Protocols

- **FTP** → unencrypted  
- **FTPS** → encrypted (SSL/TLS)  
- **SFTP** → encrypted (SSH)  
- Key: only FTPS/SFTP \= encrypted in flight

### 🛠️ Features

- Map users to S3 or EFS buckets  
- IAM role used to access storage  
- Endpoints can be public or custom hostname (via Route 53\)  
- Manage credentials internally or integrate external auth:  
  - Active Directory  
  - LDAP  
  - Okta  
  - Amazon Cognito  
  - Custom auth systems

### 💰 Pricing

- Pay **per endpoint/hour** \+ **per GB transferred**

### 🧭 Use Cases

- File sharing / public datasets  
- CRM / ERP integration  
- Migration workflows needing FTP/SFTP  
- Any scenario needing **FTP interface to AWS storage**

### 🧠 Exam Tips

- Remember: Transfer Family \= **FTP/SFTP/FTPS → S3 or EFS**  
- Fully managed, no need to maintain servers  
- Use external auth for enterprise integration if needed

---
## AWS DataSync

### 💡 Core Idea

- Managed service to **synchronize & transfer data**  
- Sources/destinations: on-prem, other cloud, or AWS storage  
- Targets: **S3 (all classes incl. Glacier), EFS, FSx**  
- Scheduled tasks (hourly/daily/weekly) → **not continuous**

### 🔹 Protocols & Agents

- Connect to on-prem via **NFS, SMB, HDFS, other**  
- **DataSync Agent** required on-prem / external cloud  
- AWS → AWS transfers \= **agentless**  
- Encrypted transfer supported

### 🛠️ Features

- Preserves **file metadata & permissions** (POSIX NFS, SMB ACLs) → compliance  
- Bandwidth throttling available  
- Supports **bi-directional sync** (on-prem ↔ AWS)  
- Can sync **between AWS services** (S3 ↔ EFS ↔ FSx)

### 📦 Integration with Snow Devices

- **AWS Snowcone** pre-installed with DataSync agent  
- Useful for **low network capacity**  
- Data physically shipped, then synchronized in AWS

### 🧭 Use Cases

- Large-scale migration on-prem → AWS  
- Backup / DR tasks  
- Cross-cloud / cross-region synchronization  
- AWS storage consolidation (S3, EFS, FSx)

### 🧠 Exam Tips

- Only **scheduled**, not real-time  
- **Metadata & permissions preserved** → unique SAA feature  
- On-prem sources require **DataSync agent**  
- Use Snowcone for offline large data transfer

---
## AWS Storage Overview

### 💡 Core Idea

- AWS provides **object, block, file, and hybrid storage**  
- Key is to pick the **right storage for the use case**

### 🔹 Object Storage

- **S3** → scalable, durable object storage, AWS-native  
- **Glacier / Deep Archive** → long-term archival

### 🔹 Block Storage

- **EBS** → attach to **one EC2 instance**, networked block storage  
  - Volumes: GP3, IO1, IO2 (high IOPS)  
  - Features: **multi-attach** (IO1/IO2)  
- **EC2 Instance Store** → ephemeral, high-performance local storage

### 🔹 File Storage

- **EFS** → NFS, Linux POSIX, multi-AZ  
- **FSx for Windows** → Windows SMB, AD integration  
- **FSx for Lustre** → HPC, Lustre-compatible, high throughput  
- **FSx for NetApp ONTAP** → cross-OS compatible, NFS/SMB/iSCSI  
- **FSx for OpenZFS** → managed ZFS file system, snapshots, cloning

### 🔹 Hybrid / On-Prem Integration

- **Storage Gateway** → bridge on-prem ↔ AWS  
  - **S3 / FSx File Gateway** → file sync to S3/FSx  
  - **Volume Gateway** → iSCSI block storage, backup to S3  
  - **Tape Gateway** → virtual tape backup, S3 → Glacier

### 🔹 Managed File Transfer

- **AWS Transfer Family** → FTP / FTPS / SFTP to S3 or EFS

### 🔹 Scheduled Data Movement

- **DataSync** → scheduled sync on-prem ↔ AWS or AWS ↔ AWS  
  - Preserves **metadata & permissions**  
  - Requires agent for NFS/SMB sources

### 🔹 Physical Data Transfer

- **Snowcone / Snowball / Snowmobile** → offline transfer for large datasets  
  - Snowcone includes **DataSync agent pre-installed**

### 🧠 Exam Tips

- Know **object vs block vs file vs hybrid**  
- Pick **S3 for objects**, **EBS/Instance Store for EC2**, **EFS/FSx for shared file systems**  
- Use **Storage Gateway** for on-prem bridging  
- Use **Transfer Family** for FTP/SFTP access  
- Use **DataSync** for scheduled migration  
- Use **Snow devices** when network is limiting