# EC2 - Solutions Architect Associate level

- [EC2 - Solutions Architect Associate level](#ec2---solutions-architect-associate-level)
  - [EC2 Public, Private \& Elastic IPs](#ec2-public-private--elastic-ips)
  - [EC2 Placement Groups](#ec2-placement-groups)
  - [Elastic Network Interfaces (ENI)](#elastic-network-interfaces-eni)
  - [EC2 Hibernate](#ec2-hibernate)


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

## EC2 Placement Groups

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

## Elastic Network Interfaces (ENI)

### Essentials
- ENI = virtual network card in a **VPC**.
- Bound to **one AZ**; attach only to EC2s in same AZ.
- EC2 gets **primary ENI (eth0)** automatically.
- You can create **secondary ENIs (eth1, eth2...)** manually.

### ENI Attributes
- Primary private IPv4 + optional **secondary private IPv4s**.
- Public/Elastic IPs can map to private IPv4s.
- One or more **Security Groups**.
- MAC address, DNS names.

### Use Cases ⚙️
- **Failover**: move ENI (and its private IP) between instances.
- **Static private IP** without stopping/starting instances.
- **Multi-homed networking** (multiple ENIs with different SGs).

### Behavior
- ENIs created with EC2 → auto-deleted when instance terminates.
- ENIs created manually → **persist** after EC2 termination.
- Can **detach/attach** ENIs on the fly.

### Limitations / Rules
- ENI locked to **its AZ**.
- One ENI attached to **one EC2 at a time**.

### Exam Tips 🧠
- ENI = quick failover by re-attaching interface.
- Secondary ENI = extra private IPs / SG separation.
- Manually created ENIs persist → good for IP continuity.
- ENI provides network access but is **not** for cross-AZ moves.

## EC2 Hibernate

### Concept
- Preserve **RAM state** by saving it to the **encrypted EBS root volume**.
- On start → RAM restored → **fast boot**, apps/caches preserved.
- OS is *frozen* instead of restarted.

### Requirements ⚠️
- Root volume = **EBS**, **encrypted**, large enough for RAM dump.
- Instance RAM < ~150 GB (approx, limit not in exam).
- Not supported on **bare metal**.
- Works on: Linux, Windows; On-Demand, Reserved, Spot.
- Hibernate duration ≤ ~60 days.

### Lifecycle
- Hibernate → instance enters *stopping*, RAM dumped to EBS → instance stops.
- Start → RAM loaded from EBS → uptime continues (OS never “rebooted”).

### Use Cases
- Long-running processes needing state preserved.
- Fast restart of complex apps.
- Keep in-memory caches warm.

### Behaviors vs Stop/Start
- Stop/Start: OS reboots, user data may run again, RAM lost.
- Hibernate: RAM restored, OS state intact.

### Exam Tips 🧠
- **Root EBS must be encrypted** + sized ≥ RAM.
- Hibernate ≠ Stop. Hibernate keeps process/memory state.
- Great distractor Q: uptime after hibernation ≠ reset to zero.