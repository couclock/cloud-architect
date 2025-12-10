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

