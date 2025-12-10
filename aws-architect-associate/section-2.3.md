# EC2 Instance Storage

Prompt to use:
Please summarize the following transcript into a very compact AWS Solutions Architect Associate (SAA) revision cheat sheet.
Include a second-level Markdown title (##) at the top using the section’s main topic.
Format the rest in raw Markdown inside a code block, with no separators.
Use short bullet points, minimal wording, and highlight only SAA-relevant concepts, AWS services, rules, exam tips, and best practices.
Use simple icons when relevant, but keep them limited.
Keep the cheat sheet extremely concise and easy to memorize.
Here’s the transcript:

## EBS Volumes

- ⭐ **EBS = Elastic Block Store**
  - Network-attached block storage for EC2
  - Persistent data across instance stops/terminations (if allowed)
  - AZ-scoped → must be in same **AZ** as EC2 to attach
  - One EC2 ↔ one EBS (single attach) at SAA level
  - Multiple EBS → single EC2 allowed

- 🔌 **Key Concepts**
  - “Network USB stick” → network latency vs instance store
  - Detach/attach quickly → useful for failover
  - Must **provision size + IOPS** upfront (GP2/GP3, etc.)
  - Pay for provisioned capacity
  - Volumes can exist **unattached**

- 🔄 **Snapshots**
  - Needed to move EBS across AZ/Region
  - Stored in S3 (managed by AWS, not directly visible)

- 🏷️ **Delete on Termination**
  - **Root volume: YES by default**
  - **Additional volumes: NO by default**
  - Controls whether EBS is removed when EC2 terminates
  - Exam tip: disable it to **preserve root disk** after termination

- 📌 **Exam Tips**
  - EBS must match **same AZ** as EC2 to attach
  - Can attach/detach live
  - Terminated EC2 → root EBS deleted (default), non-root kept
  - Snapshot → create volume in another AZ
  - EBS = block storage; use when filesystem-level access required

- 🛠️ **Use Cases**
  - Root volumes, databases, OS disks, apps needing persistence
  - Failover via detaching/attaching to new EC2 (same AZ)
 
## EBS Snapshots

### 📸 Core Concepts
- Point-in-time backup of **EBS volumes**
- 💡 No need to detach volume (but recommended)
- Copy snapshots **across AZs/Regions**
- Restore snapshot → create new EBS volume in any AZ

### 🧩 Key Features
- **Archive Tier**  
  - Up to **75% cheaper**  
  - Restore delay **24–72 hrs**

- **Recycle Bin**  
  - Protects from accidental deletion  
  - Retention: **1 day–1 year**  
  - Supports EBS snapshots + AMIs

- **Fast Snapshot Restore (FSR)**  
  - Pre-initializes snapshot → ⚡ zero-latency first use  
  - Costly; use for large/critical restores

### 📝 Exam Tips
- Snapshots are **incremental** (only changes stored)  
- Needed to **move EBS volume across AZ**  
- Useful for **DR** via cross-region copy  
- Snapshots support **encryption** (and inherit encryption)

### 🧠 Ops Notes
- Create Volume from Snapshot → choose **any AZ**  
- Archive snapshots require waiting before restore  
- Recycle Bin gives recoverability; rules can be resource-wide

## AMIs (Amazon Machine Images) – SAA Revision

### 📦 Core Concepts
- AMI = **preconfigured image** to launch EC2 instances  
- Contains: OS, software, configs, monitoring, dependencies  
- 🚀 Faster boot + consistent configuration  
- AMIs are **region-specific**, but can be **copied cross-region**

### 🧩 AMI Types
- **Public AMIs** (AWS-provided: e.g., Amazon Linux 2)  
- **Custom AMIs** (user-created; must maintain yourself)  
- **Marketplace AMIs** (vendor-built, paid or free)

### 🛠️ AMI Creation Workflow
1. Launch EC2  
2. Customize instance (install software, configs)  
3. **Stop instance** (recommended for data integrity)  
4. Create AMI → generates **EBS snapshots**  
5. Launch new instances from AMI (any AZ in same region)

### 📝 Exam Tips
- AMIs are **regional**; snapshots enable **cross-region** copy → DR  
- Best for fleets needing consistent setup + fast scaling  
- Update AMIs when patching OS/software  
- Marketplace AMIs may incur extra cost  
- AMI contains **root volume** snapshot; additional volumes optional

### ⚙️ Operational Notes
- Launching from AMI = no need to reinstall software → faster initialization  
- Combine AMI + user data for light final config  
- Custom AMIs help auto-scale groups launch quicker

## EC2 Instance Store (SAA Revision)

### ⚡ Core Concepts
- High-performance **local NVMe/SATA storage** physically attached to the EC2 host  
- Offers extremely high IOPS & throughput vs EBS  
- **Ephemeral**: data lost on **stop, terminate, or host failure**

### 🧩 Use Cases
- 🚀 Ultra-fast temporary storage  
- Cache, buffer, scratch space  
- High-speed processing workloads  
- NOT for durable data

### 🛑 Limitations
- No persistence; must manage your own backup/replication  
- Tied to the *specific host* → data disappears if instance is stopped

### 📝 Exam Tips
- “Need millions of IOPS / ultra-high disk performance” → **Instance Store**  
- “Need persistence & durability” → **EBS**  
- Instance families like **I3 / I4** commonly include Instance Store  
- Stopping instance ≠ reboot: **stop = data loss**, reboot = data preserved (unless host changes)

### 📈 Performance Context
- Instance Store can hit **>3M IOPS**, far beyond GP2/GP3 limits  
- Always ephemeral → never store critical data without replication

## EBS Volumes & Volume Types

So, now, let's talk about EBS volumes and their different volume types. They come in six different types today, and we can group them in several categories.

### General Purpose SSD (gp2, gp3)
These balance price and performance for a wide variety of workloads.

- **gp2** and **gp3** are used for general-purpose workloads.
- Can be used as **boot volumes**.
- **gp3** (newest generation):
  - Baseline: **3000 IOPS**, **125 MB/s throughput**
  - Can increase up to **16,000 IOPS** and **1000 MB/s throughput** independently
- **gp2**:
  - Small volumes can burst up to **3000 IOPS**
  - IOPS scales with size (**3 IOPS per GB**) up to **16,000 IOPS**

**Key takeaway:**  
gp3 lets you configure IOPS and throughput independently, while gp2 links performance to volume size.

### Provisioned IOPS SSD (io1, io2 / io2 Block Express)
Used for **critical, low-latency, high-performance workloads**, including databases.

- **io1**:
  - Size: 4–16 TB
  - Max IOPS: **64,000** on Nitro EC2 / **32,000** otherwise
  - IOPS can be provisioned independently of size

- **io2 Block Express**:
  - Size up to **64 TB**
  - Sub-millisecond latency
  - Max IOPS: **256,000**
  - IOPS-to-size ratio: **1000:1**
  - Supports **EBS Multi-Attach**

### HDD Volumes (st1, sc1)
Cannot be used as boot volumes. Used for throughput-intensive or cold data workloads.

- **st1 (Throughput-Optimized HDD)**:
  - For big data, data warehousing, log processing
  - Max throughput: **500 MB/s**
  - Max IOPS: **500**

- **sc1 (Cold HDD)**:
  - Lowest-cost option, for infrequently accessed data
  - Max throughput: **250 MB/s**
  - Max IOPS: **250**

### Summary
You do **not** need to memorize all numbers for the exam; just understand when to use each type:
- **gp2/gp3** → general purpose, cost-effective
- **io1/io2** → provisioned IOPS, high-performance workloads (DBs)
- **st1/sc1** → throughput or cold data at low cost

If you need **more than 32,000 IOPS**, you must use **EC2 Nitro + io1/io2**.

---

## Multi-Attach Feature

The **Multi-Attach** feature allows the **same EBS volume** to be attached to **multiple EC2 instances** *in the same Availability Zone*.

### Key Points
- Only supported on **io1** and **io2** volumes.
- Allows **full read/write access** from multiple instances simultaneously.
- Useful for:
  - Clustered Linux applications
  - Applications needing concurrent write operations
- Maximum of **16 EC2 instances** per volume.
- Requires a **cluster-aware file system** (not xfs/ext4).
- Cannot attach across different AZs.

That's it! Let me know if you want this broken into slides, a shorter summary, or converted into another format.
