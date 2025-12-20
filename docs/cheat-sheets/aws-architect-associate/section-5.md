# Route 53


- 54.78.199.141 => eu-west-1
- 54.242.236.184 => us-east-1
- 47.129.248.205 => ap-southeast-1
- ALB: training-ALB-766879361.eu-west-1.elb.amazonaws.com

Prompt to use:

Please summarize the following transcript into a very compact AWS Solutions Architect Associate (SAA) revision cheat sheet.
Include a second-level Markdown title (##) at the top using the section’s main topic.
Format the rest in raw Markdown inside a code block, with no separators.
Use short bullet points, minimal wording, and highlight only SAA-relevant concepts, AWS services, rules, exam tips, and best practices.
Use simple icons when relevant, but keep them limited.
Keep the cheat sheet extremely concise and easy to memorize.
Here’s the transcript:

## DNS Overview

• 🌐 DNS = Domain Name System → translates hostnames → IPs  
• Used by browsers to reach servers (e.g., www → public IP)

• 🔺 Hierarchy  
  - Root (.)  
  - TLD: .com .org .gov  
  - Second-Level: example.com  
  - Subdomain: www.example.com  
  - FQDN = full path (api.www.example.com.)  
  - URL = protocol + FQDN (http://...)

• 🏷️ Key Terms  
  - Registrar: where domains registered (Route 53, GoDaddy)  
  - Zone File: holds DNS records  
  - Name Servers (NS): resolve queries  
  - Managed by ICANN/IANA at higher levels

• 📄 Common Record Types  
  - A → hostname → IPv4  
  - AAAA → hostname → IPv6  
  - CNAME → hostname alias (no apex\!)  
  - NS → name servers for zone

• 🔁 Resolution Process (Recursive Lookup)  
  1\) Client → Local DNS (ISP/company)  
  2\) Local DNS → Root  
  3\) Root → TLD NS (.com)  
  4\) TLD NS → Domain NS (example.com)  
  5\) Domain NS → returns record (e.g., A → 9.10.11.12)  
  6\) Cache result (TTL) ➜ faster next time

• 🧠 Exam Tips  
  - DNS = hierarchical, distributed, cached  
  - NS delegation critical  
  - Records live in hosted zones  
  - Understand recursion vs authority behavior  
  - Route 53 can be both registrar + authoritative DNS

---
## Amazon Route 53 

### Overview

• 🚀 Highly available, scalable, fully-managed **authoritative DNS**  
• Authoritative → you control DNS records  
• 100% SLA ✔️  
• Also a **domain registrar**  
• Health checks supported  
• Clients resolve via R53 → returns IP → client connects

### DNS Records  
• A → hostname → IPv4  
• AAAA → hostname → IPv6  
• CNAME → hostname → hostname (❌ not at zone apex)  
• NS → authoritative name servers  
• Record fields: Name | Type | Value | Routing Policy | TTL

### Hosted Zones  
• Container of DNS records  
• Routes traffic for domain + subdomains  
• Cost ≈ $0.50 / hosted zone / month  
• Domain registration ≈ $12+/yr

### Public Hosted Zone  
• 🌍 Internet-accessible  
• Used for public domains/apps  
• Answers public client queries

### Private Hosted Zone  
• 🔐 Works only inside VPC  
• Internal/private domains (e.g., *.internal)  
• Resolves private IPs  
• Same behavior as public but scoped to VPC

### Exam Tips  
• Know: A / AAAA / CNAME / NS  
• CNAME ❌ at apex → use Alias (covered later)  
• Route 53 = **authoritative DNS**  
• Hosted zone = DNS container  
• Public vs Private hosted zones differences 👍

---
## Route 53 – Creating DNS Records

### Overview  
• Create DNS records inside Hosted Zone  
• Records route domain/subdomain → target  
• Client queries → Route 53 responds with value

### Creating Records  
• Record Name: e.g., test.example.com  
• Record Type (exam focus):  
  - A → IPv4  
  - AAAA → IPv6  
  - CNAME → hostname alias  
  - NS → name servers  
• Value = IP / hostname returned to client  
• TTL = cache duration (default often 300s)  
• Routing Policy = Simple (default; others learned later)

### Verification Tools  
• Browser may not show response unless server exists  
• CLI tools:  
  - Windows: nslookup  
  - Mac/Linux: dig  
• Shows:  
  - Record type (A, etc.)  
  - Returned IP  
  - TTL  
  - Authority info

### Exam Tips  
• Hosted zone must exist + NS configured  
• TTL affects propagation + caching behavior  
• Simple routing gives single response  
• CNAME ❌ at zone apex

---
## Records, EC2 Targets, ALB & TTL

### EC2 + ALB Setup Context (Exam-Relevant)  
• Deploy EC2 in multiple regions (for routing demos)  
• ALB: Internet-facing, HTTP:80, target group → instance  
• Each EC2 shows region/AZ → useful for routing policy testing

### Creating Records (Quick)  
• Record Name: subdomain.domain.com  
• Type: A (IPv4), AAAA (IPv6), CNAME, NS  
• Value: IP / hostname  
• TTL: cache duration  
• Routing Policy: Simple (default)

### Testing Resolution  
• Browser may fail if no real server  
• Tools:  
  - Windows → nslookup  
  - Mac/Linux → dig  
• Shows: record type, value, TTL, authority

### TTL (Time To Live)  
• Defines how long DNS answer is cached ⏳  
• High TTL:  
  - Fewer DNS queries  
  - Cheaper  
  - ❌ Slow propagation / stale records  
• Low TTL:  
  - More DNS queries  
  - 💲 More cost  
  - ✔️ Faster change propagation

### TTL Strategy  
• If planning record change:  
  - Lower TTL temporarily  
  - Wait for cache refresh  
  - Change record  
  - Raise TTL again

### Behavior  
• Cached response reused until TTL expiry  
• After expiry → resolver queries Route 53 again  
• TTL required for all records except Alias

### Exam Tips  
• Know TTL impact on propagation + cost  
• Simple routing = single record response  
• TTL caching explains why DNS changes are delayed


---
## CNAME vs Alias

### Basics  
- **CNAME:** hostname → hostname, subdomains only, ❌ apex  
- **Alias:** hostname → AWS resource, root & subdomains, free, auto IP update, health checks

### Alias Targets  
- ALB/NLB/CLB, CloudFront, API Gateway, Elastic Beanstalk, S3 Website, VPC Endpoint, Global Accelerator, Route 53 record    
- ❌ Not EC2 public DNS

### Record Behavior  
- **CNAME:** manual TTL, subdomain only    
- **Alias:** type A/AAAA, TTL auto, supports apex

### Root Domain Rule  
- ❌ CNAME at apex    
- ✅ Alias allowed at apex

### Exam Tips  
- Alias = AWS-native, free, auto health/IP update    
- CNAME = standard DNS, no apex    
- Remember: EC2 DNS cannot be alias target

---
## Simple & Weighted Routing Policies

### Key Concept  
- **Routing ≠ traffic routing**    
  DNS responds with IPs/hostnames → client directs traffic  
- Route 53 supports: Simple, Weighted, Failover, Latency-based, Geolocation, Multi-value answer, Geoproximity

### Simple Routing  
- Single resource (A/AAAA record)  
- Multiple IPs possible → client picks randomly  
- Alias + simple → only 1 AWS resource  
- ❌ No health checks by default  
- TTL defines caching (low TTL = faster change propagation)

### Weighted Routing  
- Distributes traffic by **relative weight**  
  - Example: 70%, 20%, 10% across 3 resources  
- Weights **do not need to sum to 100**  
- Records must have same name & type  
- Can be associated with health checks  
- Use cases:  
  - Test new version (small % traffic)  
  - Gradual traffic shifting  
  - Multi-region load splitting  
- TTL still applies (controls caching)  
- DNS responses → client picks resource based on weight probability

### Notes  
- Simple = easy, single target, random if multiple IPs    
- Weighted = controlled distribution across multiple records    
- TTL affects DNS caching, impacts propagation speed

---
## Latency-Based Routing

### Concept  
- Route users to **lowest-latency** AWS region    
- Measured per user location → AWS region    
- Can combine with **health checks**  

### Config  
- Record: \`latency.example.com\`    
- Type: A/AAAA or Alias    
- Specify **region** for each record (mandatory for raw IP)    
- Optional: health check, record ID  

### Notes  
- Alias auto-detects AWS region    
- TTL = caching, may delay updates    
- DNS returns closest resource → client connects directly  

### Exam Tip  
- Latency-based = geo-aware, multi-region, low-latency routing

---

## Route 53 Health Checks

- 🎯 Purpose: monitor endpoint health + enable DNS failover
- 🌍 Mostly for **public resources** (ALB, EC2, endpoints)
- 🔁 Integrated with Route 53 records (failover, latency, weighted)

Health Check Types:
- 🌐 **Endpoint health check**
  - Public endpoint only (HTTP, HTTPS, TCP)
  - ~15 global Route 53 checkers
  - Healthy if ≥18% checkers succeed
  - Status codes: **2xx / 3xx**
  - Optional string match (first **5,120 bytes**)
  - Interval: **30s (standard)** | **10s (fast, $$$)**
  - Must allow Route 53 checker IPs in SG/NACL

- 🧮 **Calculated health check**
  - Combines up to **256 child checks**
  - Logic: AND / OR / NOT
  - Define how many must pass
  - Use case: aggregate health, maintenance windows

- 🔒 **CloudWatch Alarm health check**
  - For **private VPC / on-prem** resources
  - Health based on alarm state
  - Common exam use case for private endpoints

Failover & DNS:
- Used with Route 53 records for **automatic DNS failover**
- Common with **multi-region** architectures
- Latency / Failover records + health checks = HA

Metrics & Monitoring:
- Health check metrics visible in **CloudWatch**
- Can create alarms on health check status

Exam Tips 📝:
- Route 53 health checks run **outside VPC**
- Private resource → **CloudWatch Alarm required**
- SG must allow Route 53 health checker IP ranges
- Health checks ≠ ELB target health checks
