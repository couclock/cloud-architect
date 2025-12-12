# High Availability & Scalability: ELB & ASG

Prompt to use:

Please summarize the following transcript into a very compact AWS Solutions Architect Associate (SAA) revision cheat sheet.
Include a second-level Markdown title (##) at the top using the section’s main topic.
Format the rest in raw Markdown inside a code block, with no separators.
Use short bullet points, minimal wording, and highlight only SAA-relevant concepts, AWS services, rules, exam tips, and best practices.
Use simple icons when relevant, but keep them limited.
Keep the cheat sheet extremely concise and easy to memorize.
Here’s the transcript:

## Scalability & High Availability

### 🔼 Vertical Scaling (Scale Up/Down)
- Increase instance size (e.g., t2.micro → t2.large)
- Used for non-distributed systems (DBs: RDS, ElastiCache)
- Limited by hardware ceilings
- Simple but not fault-tolerant

### ➕ Horizontal Scaling (Scale Out/In)
- Add/remove instances → distributed systems
- Common for web/modern apps
- Requires stateless design for best results
- Uses Auto Scaling Groups (ASG) + Elastic Load Balancing (ELB)

### 🟢 High Availability (HA)
- Run across ≥2 AZs to survive AZ failure
- HA ≠ scalability (often paired but independent)
- Active-active: multiple AZs serving traffic
- Passive: e.g., RDS Multi-AZ standby

### 🛠 EC2 Scaling Terms
- **Scale Up/Down**: vertical (instance size)
- **Scale Out/In**: horizontal (instance count)
- ASG must span Multi-AZ for HA
- ELB distributes traffic across Multi-AZ targets

### 📝 Exam Tips
- Vertical = bigger box; Horizontal = more boxes
- HA always implies Multi-AZ
- Horizontal scaling requires distributed/stateless design
- ASG + ELB = scalability + HA
- RDS Multi-AZ = HA but **not** read scaling (use Read Replicas)

---
## Elastic Load Balancing overview
### 🎯 Purpose
- Distribute traffic across multiple EC2/backends
- Single public endpoint; users unaware of backend targets
- Enables HA, fault tolerance, scalability

### 🔍 Why Use ELB
- Spread load across instances
- Health checks → route only to healthy targets
- SSL/TLS termination
- Session stickiness (cookies)
- Multi-AZ support
- Public vs internal LB
- Deep AWS integration: ASG, ECS, ACM, CW, R53, WAF, GA

### ❤️ Health Checks
- Protocol + Port + Path (e.g., HTTP:4567/health)
- Must return 200 OK → else instance marked unhealthy
- LB stops routing to unhealthy targets

### ⚙️ Managed ELB Types
- **CLB (old, deprecated)**: HTTP/HTTPS, TCP/SSL  
- **ALB (L7)**: HTTP/HTTPS, WebSocket  
- **NLB (L4)**: TCP/TLS/UDP, ultra-fast, static IP  
- **GWLB (L3)**: IP-level, appliance insertion (firewalls, etc.)
- Prefer newer generation (ALB/NLB/GWLB)

### 🔐 Security Groups
- **LB SG**: allow 0.0.0.0/0 on 80/443
- **EC2 SG**: allow only LB SG as source on app port (e.g., 80)
- Ensures traffic flows *only* through LB

### 📝 Exam Tips
- ALB = L7, path/host-based routing  
- NLB = L4, extreme performance, static IP  
- Health checks critical for ASG + ELB  
- Internal LBs for private traffic; external for internet-facing  

