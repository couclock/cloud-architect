# Cloud Front & AWS Global Accelerator

Prompt to use:

Please summarize the following transcript into a very compact AWS Solutions Architect Associate (SAA) revision cheat sheet. Include a second-level Markdown title (##) at the top using the section’s main topic. Format the rest in raw Markdown inside a code block, with no separators. Use short bullet points, minimal wording, and highlight only SAA-relevant concepts, AWS services, rules, exam tips, and best practices. Use simple icons when relevant, but keep them limited. Keep the cheat sheet extremely concise and easy to memorize. Here’s the transcript:

## **CloudFront (CDN)**

### 🌐 Purpose

- AWS **Content Delivery Network (CDN)**  
- Cache content globally → reduce latency  
- Improve user experience worldwide  
- Provides **DDoS protection** via edge locations \+ AWS Shield/WAF

### 🧱 Architecture

- **Origins** \= backend sources  
  - S3 buckets (with OAC)  
  - VPC origins (ALB, NLB, EC2)  
  - Custom HTTP origins (public websites)  
- **Edge locations** \= cache content near users  
- Cache checks: if edge has content → serve; else fetch from origin

### 🔑 Security

- S3 origin → use **Origin Access Control (OAC)**  
- Private VPC origin → connect via **CloudFront** \+ security policies

### ⚡ Performance

- Content cached at edge → faster for repeated requests  
- Reduces load on origin

### 📊 CloudFront vs S3 Replication

- **CloudFront**  
  - CDN, caches globally (\~216 edge locations)  
  - Best for static content  
  - Edge caching, not full replication  
- **S3 Cross-Region Replication**  
  - Replicates bucket content to other regions  
  - Near real-time, read-only  
  - Best for dynamic content or DR

### 🧰 Hands-On Practice

- Create S3 bucket → upload files (e.g., index.html, images)  
- Test access: object URL → **access denied** (private)  
- Generate CloudFront distribution:  
  - Origin: S3 bucket  
  - Enable **private bucket access** (OAC created automatically)  
  - CloudFront modifies bucket policy for secure access  
- Distribution ready → copy domain name  
  - Access files via CloudFront URL (private S3 objects accessible)  
  - Files cached at edge → faster load globally  
- Benefits:  
  - No public S3 objects required  
  - Content globally distributed with low latency  
  - Automatic caching at edge locations

### 🧠 Exam Tips

- CDN \= **think CloudFront**  
- Edge locations \= global caching \+ DDoS protection  
- OAC secures S3 origins  
- Distinguish **caching (CloudFront)** vs **replication (S3 CRR)**

---
## Connecting to ALB / EC2 Origins

### 🎯 Goal
- Use CloudFront in front of **applications running on ALB, NLB, or EC2**
- Improve security + latency
- Prefer **private VPC origins** over old public edge-IP allowlisting method

### 🆕 Best Practice: VPC Origins
- Deliver content from **private subnets**
- Keep backend **fully private** (no internet exposure)
- Works with:
  - Application Load Balancer
  - Network Load Balancer
  - EC2 instances
- CloudFront → VPC Origin → Private Backend
- Most secure architecture

### 🔐 Security Advantages
- Backend stays private
- No need to manage IP allow lists
- No Internet-facing ALB/EC2 required
- Cleaner + safer network path

### 🏛️ Legacy Method (Public Network – Old Way)
- Backend must be **public**
- Allow only CloudFront edge IPs in Security Groups
- Requires:
  - Fetching CloudFront IP ranges list
  - Updating SG rules when IPs change
- Risks:
  - Misconfiguration can expose app publicly

### 🧠 Exam / Real-World Tips
- If you see **secure, private CloudFront → backend** → think **VPC Origins**
- Legacy method still valid knowledge, but **not preferred**
- VPC Origins = newer, safer, simpler

---
## Geo Restriction

### 🌍 Purpose
- Control **who can access your CloudFront distribution** based on country
- Enforce legal, licensing, and compliance restrictions

### 🚦 Modes
- **Allowlist** → Only selected countries can access
- **Blocklist** → Selected countries are blocked

### 🧠 How It Works
- Uses **third-party Geo-IP database**
- Matches user’s IP → determines country

### 🏷️ Common Use Cases
- Copyright & licensing control
- Regional content restrictions
- Compliance requirements

### ⚙️ Configuration (Console)
Security → Geographic Restrictions → Countries → Edit
- Choose:
  - Allowlist → specify allowed countries
  - Blocklist → specify banned countries
- Save → applied to the distribution

### 🧠 Exam Tips
- Country detection = **Geo-IP lookup**
- Works only at **country level**, not city / region
- Simple allowlist / blocklist model

