# EC2 - Solutions Architect Associate level

Prompt to use:
Please summarize the following transcript into a very compact AWS Solutions Architect Associate (SAA) revision cheat sheet.
Include a second-level Markdown title (##) at the top using the section’s main topic.
Format the rest in raw Markdown inside a code block, with no separators.
Use short bullet points, minimal wording, and highlight only SAA-relevant concepts, AWS services, rules, exam tips, and best practices.
Use simple icons when relevant, but keep them limited.
Keep the cheat sheet extremely concise and easy to memorize.
Here’s the transcript:

## EC2 Public, Private & Elastic IPs

### Basics
- IPv4 = common (x.x.x.x), IPv6 supported but rare for SAA.
- Private IP ➜ internal VPC only; must be unique **within** VPC.
- Public IP ➜ reachable from Internet; must be unique **globally**.
- Cannot SSH via private IP unless on same network/VPN/Bastion.

### Public IP Behavior
- Auto-assign Public IP = Yes → instance gets public IP.
- **Public IP changes** on **Stop/Start** (not Reboot).
- Used for temporary access.

### Private IP Behavior
- **Stable** across Stop/Start.
- Internal EC2/VPC communication.
- Internet access needs **IGW/NAT** depending on direction.

### Elastic IP (EIP) ⚠️
- Static public IPv4 you keep until released.
- Remains the same after Stop/Start.
- 1 EIP per instance; default quota = **5**.
- **Costs** when unused or attached to stopped instances.
- Prefer DNS (Route 53) or Load Balancer instead of EIP.

### Exam Tips 🧠
- Public IP changed? → Use Elastic IP.
- Private IP unreachable from home → Need VPN, DX, or Bastion.
- NAT Gateway = private subnet → Internet.
- IGW = public subnet → Internet.
- EIPs generally = bad architecture → use DNS/ALB.

## EC2 Placement Groups (SAA Revision)

### 🧩 Types
- **Cluster PG**  
  - Same AZ; tightly packed  
  - ⚡ Ultra-low latency, high throughput (10+ Gbps)  
  - ❗ High blast radius  
  - Use: HPC, big data, fast compute jobs

- **Spread PG**  
  - Instances on distinct hardware across AZs  
  - 🛡️ Max HA; isolates failures  
  - Limit: **7 instances per AZ per PG**  
  - Use: critical apps needing failure isolation

- **Partition PG**  
  - Instances in **partitions = rack groups**  
  - Up to **7 partitions per AZ**, multi-AZ  
  - Supports hundreds of instances  
  - Use: partition-aware systems (HDFS, HBase, Cassandra, Kafka)  
  - Each partition isolated from rack failure

### 📝 Exam Tips
- Cluster = performance; Spread = HA; Partition = scalable HA  
- Cluster only in **one AZ**  
- Spread strict **7-instance** rule  
- Partition for big data distributed systems  
- Partition metadata visible via **Instance Metadata Service**

### 🧠 Key Rules
- Create PG **before** launching instances  
- Can't change PG type after creation  
- Enhanced networking boosts Cluster PG performance

