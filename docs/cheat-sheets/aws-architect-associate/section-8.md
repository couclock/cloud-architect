# Cloud Front & AWS Global Accelerator



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
