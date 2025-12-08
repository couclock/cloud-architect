# Elastic Compute Cloud - EC2

Prompt to use:
Please summarize the following transcript into a very compact AWS Solutions Architect Associate (SAA) revision cheat sheet.
Include a second-level Markdown title (##) at the top using the section’s main topic.
Format the rest in raw Markdown inside a code block, with no separators.
Use short bullet points, minimal wording, and highlight only SAA-relevant concepts, AWS services, rules, exam tips, and best practices.
Use simple icons when relevant, but keep them limited.
Keep the cheat sheet extremely concise and easy to memorize.
Here’s the transcript:

## EC2 Essentials
- 💻 **EC2 = Elastic Compute Cloud** → core IaaS service  
- 🖥️ **EC2 Instance:** virtual machine you rent  
- 📦 **Main Components:**  
  - EBS volumes (network storage)  
  - Instance Store (hardware storage)  
  - ELB (load balancing)  
  - ASG (auto-scaling)  

### Instance Configuration
- 🐧 OS choices: Linux (most common), Windows, macOS  
- ⚙️ Choose: CPU, RAM, storage type, network performance  
- 🔥 **Security Groups:** instance-level firewall  
- 🌐 Public IP may change on stop/start; private IP stays  

### EC2 User Data (Bootstrap)
- 📜 Runs **once at first boot**  
- Automates: updates, package installs, file creation  
- Runs as **root**  

### Launching an EC2 Instance (Key SAA Points)
- Choose AMI → e.g., Amazon Linux 2 (free tier)  
- Choose instance type → **t2.micro / t3.micro** (free tier)  
- 🔑 Create/choose SSH key pair (.pem / .ppk)  
- Configure security group:  
  - SSH (22) from anywhere  
  - HTTP (80) for web server  
- Add EBS root volume (default 8 GB gp2, delete-on-terminate = yes)  
- Add User Data script to auto-install web server  

### Public vs Private IP
- 🌍 Public IP changes after stop/start  
- 🛠️ Private IP remains stable  
- Access web server via:  
  - `http://<public-ip>` (NOT https)

### Instance Lifecycle
- ▶️ **Start** = VM becomes active  
- ⏹️ **Stop** = VM off (no compute billing, EBS billed)  
- ❌ **Terminate** = delete instance + root volume (if enabled)

### Exam Tips
- EC2 fundamentals are **core SAA topics**  
- Security Groups = **stateful**  
- User Data = **one-time run**, good for automation  
- Public IP volatility → use **Elastic IP** if persistence needed  

## EC2 Instance Types

**EC2 Instance Types**
- 🧩 **Naming:** m5.2xlarge  
  - Letter = class (M=general, C=compute, R=memory…)  
  - Number = generation  
  - Size = resources (CPU/RAM ↑ with size)

**Main Families**
- ⚖️ **General Purpose (T/M/A):** balanced CPU/RAM/network  
  - Use cases: web servers, repos  
  - Free tier: t2.micro / t3.micro  
- 🚀 **Compute Optimized (C):** high CPU  
  - Use cases: batch jobs, transcoding, HPC, ML inferencing, gaming  
- 🧠 **Memory Optimized (R/X/Z):** large in-memory datasets  
  - Use cases: DBs (SQL/NoSQL), BI, in-memory cache, realtime big data  
- 📦 **Storage Optimized (I/D/H):** high I/O local storage  
  - Use cases: OLTP, NoSQL DBs, data warehouses, distributed FS

**Exam Tips**
- Match instance family ↔ workload type  
- Larger sizes = more vCPU + RAM  
- Use AWS docs or **ec2instances.info** to compare specs & pricing  

## EC2 Security Groups (Firewall Rules)

- 🔒 **Instance-level firewall** (inbound + outbound)
- ✅ **Allow rules only** (no deny rules)
- 🌍 Rules allow IP ranges (IPv4/IPv6) or **other SGs** (SG-to-SG)

### Core Concepts
- Inbound = traffic **into** EC2  
- Outbound = traffic **from** EC2 → internet  
- SGs operate **outside** the instance → blocked traffic never reaches EC2  
- SGs are **stateful** → return traffic automatically allowed  
- SGs are tied to **Region + VPC**

### Usage & Best Practices
- EC2 can have **multiple SGs**; SGs can be attached to **many instances**
- Maintain a **dedicated SSH SG** for clean security
- **Timeout = SG issue**  
- **Connection refused = app/OS issue**, SG allowed traffic
- Use SG references for **clean architecture** (e.g., Load Balancer SG → EC2 SG)

### Exam-Relevant Ports
- 🔑 **22** – SSH (Linux) / SFTP  
- 📁 **21** – FTP  
- 🌐 **80** – HTTP  
- 🔐 **443** – HTTPS  
- 🪟 **3389** – RDP (Windows)

### Rules Structure
- Fields: **Type · Protocol · Port · Source**
- `0.0.0.0/0` = allow from **anywhere**
- Outbound: **allow all** by default  
- Inbound: **deny all** by default

### Common Patterns
- SG1 inbound allows **SG2** → any instance with SG2 can reach SG1  
- Useful for **ALB → EC2**, **App → DB**, **EC2 → EC2**

### Troubleshooting Tip
- ⏳ **Timeout** = missing inbound rule  
- Add correct port (e.g., 22, 80, 443) → connection restored

## EC2 Instance Connect (Browser-Based SSH)

### Overview
- 🌐 **Browser-based SSH session** directly from the AWS console  
- 🔑 **No need to manage SSH keys** → AWS uploads a **temporary key** automatically  
- 👤 Default username: **ec2-user** (Amazon Linux 2)

### How It Works
- Open **EC2 Console → Instance → Connect**
- Choose **EC2 Instance Connect** (not SSH client)
- AWS:
  - Verifies public IP
  - Uploads a **one-time SSH key**
  - Opens a browser terminal

### Benefits
- 🧩 No key files, no terminal setup  
- 💻 Works on Windows / Mac / Linux equally  
- 🚀 Quick access for demos & troubleshooting

### Commands You Can Run
- `whoami`  
- `ping google.com`  
- Any Linux command supported by the AMI

### Security Group Requirements
- Requires **port 22 (SSH)** inbound  
  - 🌍 **0.0.0.0/0** for IPv4 (common in demos)  
  - 🔢 Add **::/0** if using IPv6  
- If port 22 is removed → ❌ **EC2 Instance Connect will fail**

### Troubleshooting
- ❌ **Connection error?**  
  - Check SG inbound for **SSH (22)**  
  - Add IPv4 + IPv6 entries if needed  
- ✔ After fixing SG rules → reconnect via the console

## Using IAM Roles with EC2 Instances

### Core Idea
- 🔐 **Never** put Access Keys in EC2 (`aws configure` = ❌)
- ✔ EC2 must use **IAM Roles** for temporary credentials

### Steps
- Connect via 🖥️ EC2 Instance Connect or SSH  
- Run AWS CLI → `aws iam list-users` → ❗ No credentials  
- Attach role:  
  EC2 Console → Instance → Actions → Security → **Modify IAM role** → select role → Save

### After Role Attachment
- `aws iam list-users` → ✔ Works if policy allows  
- Detach policy → ❌ AccessDenied  
- ⏱ Policy changes may take a few seconds

### Key Points
- 🧩 IAM Role = secure, automatic credentials  
- 🔄 No need to manage keys  
- 🚫 Never store Access Keys on instances  

## EC2 Purchasing Options (SAA)

### On-Demand
- 🕒 Pay per sec (Linux/Windows), per hour (others)
- 💰 Highest cost, no commitment
- ✔ Unpredictable/short workloads

### Reserved Instances (RI)
- 📅 1 or 3 yrs, up to **72%** off
- 🎯 Commit to specific: type, region, tenancy, OS
- 💳 No/partial/all upfront → more discount
- 🗃 Good for steady-state (DBs)
- 🔄 Convertible RI → change type/family/OS (≤66% off)

### Savings Plans
- 💵 Commit to spend ($/hr) for 1–3 yrs
- ⚙ Flexible across size/OS/tenancy
- 🔒 Locked to instance **family** & region
- 💸 Up to ~70% off

### Spot Instances
- ⚡ Up to **90%** off
- ❗ Can be interrupted anytime (bid price exceeded)
- ✔ Batch, data analysis, render, flexible timing
- ❌ Not for critical apps or DBs

### Dedicated Host
- 🏢 Entire physical server dedicated to you
- 📜 Required for BYOL/per-core/per-socket licensing
- 💵 Most expensive (physical hardware control)

### Dedicated Instances
- 🧩 Hardware isolated from other customers
- ❌ No placement control
- ✔ Less strict than dedicated hosts

### Capacity Reservations
- 📍 Reserve capacity in an AZ (any duration)
- ❗ No discount (pay on-demand rates even unused)
- ✔ Guarantee capacity for critical, short-term needs
- ➕ Can combine with RI/Savings Plans for discounts

### Quick Selection Tips
- 🕒 **Unpredictable** → On-Demand  
- 🔁 **Steady DB** → Reserved Instance  
- 💵 **Commit to spend, flexible sizes** → Savings Plan  
- ⚡ **Cheap & interruptible** → Spot  
- 🏢 **Compliance/BYOL** → Dedicated Host  
- 📍 **Guaranteed AZ capacity** → Capacity Reservation

## EC2 Spot Instances & Spot Fleets

### Spot Instances
- ⚡ Up to **90% discount** vs On-Demand
- 💵 Define **max spot price** → instance runs if current < max
- ⏱ 2-min **grace period** when reclaimed → stop or terminate
- ⬜ Spot Block → 1–6 hrs guaranteed no interruption
- ✔ Best for **batch, data analysis, fault-tolerant workloads**
- ❌ Not for critical apps/DB

### Spot Pricing
- 💹 Varies per AZ & over time
- 🖤 Max price ensures instance retention
- 📊 Huge cost savings vs On-Demand

### Spot Request Types
- 🔹 **One-time** → launch once, request disappears
- 🔹 **Persistent** → maintains target capacity, auto-relaunch

### Terminating Spot Instances
1. Cancel **spot request** first
2. Terminate associated instances  
- ⚠ Wrong order → AWS relaunches instances

### Spot Fleets
- 🚢 Combine multiple spot & optional On-Demand instances
- 🎯 Meets **target capacity** within price constraints
- 🏷 Allocation strategies:
  - Lowest price → cheapest pool (exam focus)
  - Diversified → spread across pools (availability)
  - Capacity optimized → optimal AZ capacity
  - Price + capacity optimized → best of both worlds
- ✔ Auto-selects instance types & AZs for cost optimization

### Exam Tips
- Understand **spot vs on-demand** vs **spot fleets**
- Know **max price**, **grace period**, **request types**
- Spot fleets → best for **multi-AZ, cost-optimized workloads**

## EC2 Launch Methods & Options

### Spot Instances & Spot Fleets
- Request via **Spot Request** or **Launch Instance → Advanced Details**
- 💵 Max price → instance runs if current < max
- ⏱ Interruption behavior: terminate, stop, hibernate
- 🔹 One-time request → launched once, gone after termination
- 🔹 Persistent request → maintains target capacity, auto-relaunch
- ⚡ Spot Fleet → multiple instance types & AZs for cost optimization
  - Allocation strategies: lowest price, diversified, capacity optimized, price-capacity optimized
  - Target capacity: # instances, vCPUs, or memory
  - Networking & instance type filters optional
  - Huge savings vs On-Demand (~70%+)

### Reserved Instances (RI)
- Pre-purchase **specific instance type, AZ, OS**
- Term: 1–3 years, Payment: All, Partial, No Upfront
- Types:
  - Standard → max discount (~72%)
  - Convertible → change attributes, slightly lower discount (~66%)
- Use for **steady-state workloads**

### Savings Plans
- Commit to **$ per hour** for 1–3 yrs
- Flexible across instance size, OS, AZ, tenancy
- Discount similar to RI (~70%)
- Easier & more flexible than Reserved Instances

### Dedicated Hosts
- Full **physical server** dedicated to you
- Use for licensing compliance or BYOL
- Launch multiple instance types per host
- Billed per host (most expensive option)

### Capacity Reservations
- Reserve **specific instance types & count** in an AZ
- No time commitment or discount
- Billed at On-Demand rates
- Guarantees availability when you need it
