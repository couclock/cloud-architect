# Cloud Front & AWS Global Accelerator

- [Cloud Front \& AWS Global Accelerator](#cloud-front--aws-global-accelerator)
  - [**CloudFront (CDN)**](#cloudfront-cdn)
  - [Connecting to ALB / EC2 Origins](#connecting-to-alb--ec2-origins)
  - [Geo Restriction](#geo-restriction)
  - [Pricing \& Price Classes](#pricing--price-classes)
  - [Cache Invalidations](#cache-invalidations)
  - [AWS Global Accelerator](#aws-global-accelerator)


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

---
## Pricing & Price Classes

### 💰 Why Pricing Matters
- CloudFront has edge locations worldwide
- **Cost per GB varies by region**
- Some regions (e.g., India) are significantly more expensive than others (e.g., US / Europe)

### 📉 Pricing Behavior
- Different geographic zones = different price per GB
- More data transfer → cheaper per GB (volume discounts)
- High-cost regions drive overall distribution cost up

### 🏷️ Price Classes Overview
- Control which edge locations CloudFront can use
- Trade-off: **Cost vs Performance**
- 3 available classes:

### 🎯 Price Class Options
- **Price Class All**
  - Uses *all* CloudFront regions
  - Best performance (global coverage)
  - Highest cost
- **Price Class 200**
  - Uses most regions
  - Excludes the most expensive
  - Balanced cost vs performance
- **Price Class 100**
  - Uses only the least expensive regions
  - Typically North America + Europe
  - Lowest cost, reduced global performance

### 🌍 Visual Way to Think About It
- Price Class 100 → North America + Europe
- Price Class 200 → Adds more global regions
- Price Class All → Worldwide edges

### 🧠 Exam & Real-World Tips
- Need **global performance** → Price Class All
- Need **cost optimization** → Price Class 100 / 200
- Price classes do **not** change availability of CloudFront, only which edge locations serve content

---
## Cache Invalidations

### Purpose
- Force CloudFront to refresh cached content before TTL expires
- Ensure users instantly receive updated files

### How It Works
1. Origin content changes (e.g., S3 update)
2. Edge still holds cached version
3. Create invalidation request
4. Cache entry removed → next request fetches fresh content

### Common Patterns
- All files: `/*`
- Single file: `/index.html`
- Folder: `/images/*`

### Cost & Tips
- First ~1,000 paths/month usually free; then billed
- Prefer versioned files + proper cache headers to reduce invalidations

### Key Takeaway
Use invalidations when you **can’t wait for cache TTL**, especially for critical updates.

---
## AWS Global Accelerator

### 🌐 What it is
- Global performance accelerator using AWS backbone
- **Anycast** → 2 global **static IPs** route to nearest edge
- Supports **TCP/UDP**, no caching, traffic proxied to origin

### ⚡ Key Benefits
- Lower latency, fewer internet hops
- Consistent performance + intelligent routing
- Fast failover (<1 min) via regional health checks
- Strong DR + multi-region support

### 🧩 Works With
- ALB / NLB
- EC2
- Elastic IPs
- Public or private endpoints

### 🛡️ Security
- Only 2 IPs to whitelist
- AWS Shield DDoS protection
- Stable IPs → no client caching issues

### 🛠️ Features / Config
- Listeners (ports/protocols)
- Regional Endpoint Groups
- Traffic weighting
- Health checks (HTTP/HTTPS/TCP)
- Optional client affinity (source IP)

### 🧭 Use Cases
- Non-HTTP apps: Gaming, VoIP, IoT
- HTTP apps needing static global IP
- Low latency + deterministic routing
- Rapid regional failover needs

### 🔍 Global Accelerator vs CloudFront
- **Both:** AWS edge + Shield
- **CloudFront:** CDN, caching, HTTP(S), content served from edges
- **Global Accelerator:** no cache, accelerates TCP/UDP, routes to regional apps

### 📌 Exam Tips
- Uses **Anycast** + 2 static global IPs
- Improves multi-region app performance
- Automatic health-based failover
- Prefer Global Accelerator for dynamic/non-HTTP workloads vs CloudFront

