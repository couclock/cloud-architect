# EC2 Instance Storage

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
