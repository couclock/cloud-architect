
# Networking - VPC

- [Networking - VPC](#networking---vpc)
  - [CIDR \& IPv4](#cidr--ipv4)
  - [Default VPC \& Custom VPC](#default-vpc--custom-vpc)
  - [VPC Subnets](#vpc-subnets)
  - [Internet Access \& Public Subnets](#internet-access--public-subnets)
  - [Bastion Host](#bastion-host)
  - [NAT Instance](#nat-instance)
  - [NAT Gateway](#nat-gateway)
  - [Security Groups \& NACLs](#security-groups--nacls)
  - [VPC Peering](#vpc-peering)
  - [VPC Endpoints](#vpc-endpoints)
  - [VPC Flow Logs](#vpc-flow-logs)
  - [Site-to-Site VPN](#site-to-site-vpn)
  - [AWS Direct Connect (DX)](#aws-direct-connect-dx)
  - [AWS Transit Gateway \& VPC Traffic Mirroring](#aws-transit-gateway--vpc-traffic-mirroring)
  - [IPv6 in AWS 🌐](#ipv6-in-aws-)
  - [Egress-Only Internet Gateway (EIGW) – IPv6 🔒](#egress-only-internet-gateway-eigw--ipv6-)
  - [VPC \& Networking – Full Summary 🌐](#vpc--networking--full-summary-)
  - [AWS Networking Cost Overview 💰](#aws-networking-cost-overview-)
  - [AWS Network Protection 🔐](#aws-network-protection-)

## CIDR & IPv4

### CIDR Basics
- Format: `IP/Prefix` → defines IP range
- Used in VPCs, subnets, SGs, NACLs
- Prefix = fixed bits 🧠

### Must-Know Prefixes
- `/32` → 1 IP
- `/24` → 256 IPs (common)
- `/16` → 65,536 IPs
- `/0` → all IPv4 (`0.0.0.0/0`) 🌍

### Octet Shortcut ⚡
- `/32` → no octet changes
- `/24` → last octet changes
- `/16` → last 2 octets change
- `/8` → last 3 octets change

### Key Examples
- `192.168.0.0/24` → `.0–.255`
- `134.56.78.123/32` → single IP
- `0.0.0.0/0` → allow all ❗

### Private IPv4 Ranges 🔒
- `10.0.0.0/8` → large AWS VPCs
- `172.16.0.0/12` → default VPC
- `192.168.0.0/16` → home networks

### SAA Exam Tips 📝
- Smaller prefix = larger network
- `/0` = public access (risk)
- AWS mainly uses `/xx` notation

---
## Default VPC & Custom VPC

### Default VPC
- Created automatically in every region
- Has **internet access by default** 🌍
- EC2 gets **public + private IPv4** automatically
- Includes:
  - 1 VPC CIDR (usually `172.16.0.0/16`)
  - Subnets in **multiple AZs** (HA)
  - Internet Gateway attached
  - Main route table + main NACL
- Subnets:
  - Auto-assign public IPv4 = **enabled**
  - ~4091 usable IPs (`/20`, 5 reserved by AWS)
- Best practice ⚠️: **Don’t use default VPC in prod**

### Default Networking Behavior
- Route table: `0.0.0.0/0 → Internet Gateway`
- NACL: allow all inbound/outbound
- Main route table is **implicitly** associated

### VPC Basics
- VPC = Virtual Private Cloud
- Up to **5 VPCs per region** (soft limit)
- Up to **5 CIDRs per VPC**
- IPv4 CIDR size:
  - Min `/28` (16 IPs)
  - Max `/16` (65,536 IPs)
- **Only private IPv4 ranges allowed** 🔒

### Private IPv4 Ranges
- `10.0.0.0/8`
- `172.16.0.0/12`
- `192.168.0.0/16`

### CIDR Design Rules (Exam Tip 📝)
- CIDRs **must not overlap** (VPCs, on-prem, peering)
- Plan for future connectivity
- Smaller prefix = larger network

### VPC Creation Defaults
- Main route table & NACL auto-created
- Tenancy:
  - Default = shared hardware (use this)
  - Dedicated = costly 💰

### Key Takeaways ⚡
- Default VPC = easy start, not prod-ready
- Internet access requires:
  - Internet Gateway
  - Route `0.0.0.0/0`
  - Public IP on EC2
- Always design your **own VPC** for production

---
## VPC Subnets

### Subnet Basics
- Subnet = CIDR range **inside a VPC**
- Lives in **one AZ only**
- Used to separate public vs private tiers

### AWS Reserved IPs (Very Important ❗)
- **5 IPs per subnet are unusable**
  - `.0` → network address
  - `.1` → VPC router
  - `.2` → AWS DNS
  - `.3` → future use
  - last IP → reserved (no broadcast in VPC)

### Exam Trap ⚠️
- Usable IPs = **CIDR size − 5**
- Need **N IPs** → subnet must have **N + 5**
- Example:
  - `/27` = 32 − 5 = 27 ❌ (not enough for 29)
  - `/26` = 64 − 5 = 59 ✅

### Public vs Private Subnets
- **CIDR alone does NOT make subnet public**
- Public subnet:
  - Route `0.0.0.0/0 → Internet Gateway`
- Private subnet:
  - No direct route to IGW

### Typical Subnet Design 🏗️
- Public subnets:
  - Smaller CIDR (e.g. `/24`)
  - ALB, Bastion, NAT
- Private subnets:
  - Larger CIDR (e.g. `/20`)
  - EC2, RDS, internal services

### Multi-AZ Best Practice
- Create subnets in **multiple AZs**
- Enables **high availability**

### Key Takeaways ⚡
- Always account for **5 reserved IPs**
- Subnets must **not overlap**
- Public/private = **routing**, not CIDR
- Size subnets carefully for growth

---
## Internet Access & Public Subnets

### Internet Gateway (IGW)
- Enables VPC ↔ Internet 🌍
- Managed, HA, auto-scales
- **1 IGW per VPC**
- Must be **created & attached** to VPC
- IGW alone ≠ internet access ❗

### What Makes a Subnet Public?
A subnet is **public** if ALL are true:
- Route table has `0.0.0.0/0 → IGW`
- EC2 has **public IPv4**
- Subnet allows **auto-assign public IPv4**

### Required Steps (In Order ⚡)
1. Create IGW
2. Attach IGW to VPC
3. Create **public route table**
4. Add route: `0.0.0.0/0 → IGW`
5. Associate route table with **public subnets**
6. Enable auto-assign public IPv4 on subnet

### Route Tables
- `local` route → VPC CIDR (auto-created)
- Main route table:
  - Used **only if no explicit association**
- Best practice ✅:
  - Separate **public** and **private** route tables

### Common Mistakes (Exam Traps ⚠️)
- IGW attached but **no route** → no internet
- Public IP but **private route table** → no internet
- Subnet called “public” but **no IGW route**

### Validation
- EC2 Instance Connect / SSH works
- Can reach internet (e.g. `ping google.com`)

### Key Takeaways 📝
- Public subnet = **routing + public IP**
- IGW + route table = internet access
- Explicit subnet-route table associations preferred

---
## Bastion Host

### What is a Bastion Host?
- EC2 instance used to **SSH into private EC2**
- Deployed in a **public subnet**
- Acts as a secure jump box 🔐

### Why It’s Needed
- Private subnet EC2 has **no direct internet access**
- Users are on the **public internet**
- Bastion bridges public → private access

### Architecture
- User → SSH → **Bastion Host (public subnet)**
- Bastion → SSH → **Private EC2 (private subnet)**

### Security Groups (Exam Favorite ⚠️)
- Bastion SG:
  - Allow **SSH (22)** from **trusted IPs only**
  - ❌ Avoid `0.0.0.0/0` if possible
- Private EC2 SG:
  - Allow SSH **from Bastion SG** (or Bastion private IP)

### Key Rules
- Bastion must have:
  - Public subnet
  - Public IPv4
  - Route to IGW
- Private EC2:
  - No public IP
  - No IGW route

### Connectivity Notes
- SSH works via bastion
- **No internet access** from private EC2 (yet)
- EC2 Instance Connect ❌ for private subnets

### Best Practices ✅
- Restrict bastion access tightly
- Use SG-to-SG rules (preferred)
- One bastion can serve **many private EC2s**

### SAA Takeaways 📝
- Bastion = inbound access solution
- Public subnet + IGW + SSH
- Private subnet stays isolated

---
## NAT Instance

### What is a NAT Instance?
- EC2 that enables **private subnet → internet** 🌍
- Performs **Network Address Translation (NAT)**
- **Outbound-only** internet for private EC2

### Core Requirements ❗
- Launched in a **public subnet**
- Must have **Elastic IP**
- **Source/Destination check = DISABLED**
- Route table (private subnet):  
  `0.0.0.0/0 → NAT Instance`

### How It Works
- Private EC2 → NAT Instance → Internet
- NAT **rewrites source IP** (private → public)
- Responses return via NAT to private EC2

### Security Groups
- NAT SG inbound:
  - Allow **HTTP/HTTPS** from VPC CIDR
  - ICMP if needed (ping)
  - Optional SSH (restricted)
- NAT SG outbound:
  - Allow all (default)

### Limitations ⚠️
- ❌ Not highly available (single EC2)
- ❌ Bandwidth tied to instance size
- ❌ Manual scaling & patching
- ❌ Deprecated AMIs (old support)
- ❌ Must manage SGs & failover

### Exam Position 📝
- **Outdated but testable**
- NAT Gateway is **preferred answer**
- Use NAT Instance only if:
  - Question explicitly says so
  - Need custom NAT behavior

### Compare (Quick)
- NAT Instance: EC2-based, manual, legacy
- NAT Gateway: managed, HA, scalable ✅

### Key Takeaways ⚡
- Private subnets need NAT for outbound internet
- Disable source/dest check (classic exam trap)
- Choose **NAT Gateway** unless told otherwise

---
## NAT Gateway

### What It Is 🚪
- Managed AWS service for outbound internet access
- Used by **private subnets**
- Replaces NAT Instances (preferred in exams)

### Key Characteristics
- Managed, no admin/patching
- High bandwidth: **5 Gbps → auto-scale to 100 Gbps**
- Uses **Elastic IP**
- **No Security Groups**
- **Cannot act as Bastion Host**

### Placement & Routing 🗺️
- Created in a **public subnet**
- Requires an **Internet Gateway (IGW)**
- Route:  
  `Private Subnet → NAT Gateway → IGW → Internet`
- **Cannot be used by instances in the same subnet**

### High Availability ⚠️
- HA **within one AZ only**
- For AZ fault tolerance:
  - Deploy **one NAT Gateway per AZ**
  - Each private subnet routes to its local AZ NAT GW
- No cross-AZ routing needed

### Cost 💰
- Pay per hour + data processed
- More expensive than NAT Instance, but:
  - Less ops
  - More scalable
  - Exam-preferred choice

### NAT Gateway vs NAT Instance (Exam Favorite) 📝
- **NAT Gateway**
  - Managed, auto-scale, no SGs
  - Up to 100 Gbps
  - Per-hour + data cost
- **NAT Instance**
  - Self-managed, needs SGs & patches
  - Bandwidth depends on EC2 type
  - Can be Bastion Host

### Exam Tips ⭐
- Private subnet internet access → **NAT Gateway**
- HA requirement → **Multiple NAT GWs (1 per AZ)**
- Simplicity & scale → **Choose NAT Gateway**
- NAT Gateway **always needs IGW**

---
## Security Groups & NACLs

### Security Groups (SG) 🔒
- **Instance-level** firewall
- **Stateful**: return traffic auto-allowed
- Allow rules only
- Inbound/outbound rules evaluated per instance
- SG outbound irrelevant for responses to inbound traffic
- Common ports: SSH 22, HTTP 80, HTTPS 443
- Exam tip: SG + NACL must allow traffic for success

### Network ACLs (NACL) 🛡️
- **Subnet-level** firewall
- **Stateless**: inbound/outbound evaluated separately
- Supports **allow & deny rules**
- Default NACL: allows all inbound/outbound
- Custom NACL: deny/allow specific traffic
- Rule numbers **1–32,000**, lower = higher priority
- AWS best practice: number rules by increments of 100
- Default NACL auto-assigned to new subnets
- Exam tip: NACL denies override allows if higher priority

### Rule Processing ⚡
- NACL: first match wins
- SG: all rules evaluated
- Inbound + outbound must be allowed for successful traffic
- Deny example: NACL inbound HTTP 80 can block traffic even if SG allows it

### Ephemeral Ports 🌊
- Clients use random **ephemeral ports** for responses
- Windows: 49,152–65,535, Linux: 32,768–60,999
- NACL must allow ephemeral port ranges for return traffic
- Important for **DB-client or private subnet communication**

### SG vs NACL Summary ✅
| Feature | SG | NACL |
|---------|----|------|
| Level | Instance | Subnet |
| Stateful? | Yes | No |
| Rules | Allow only | Allow + Deny |
| Evaluation | All rules | First match |
| Return traffic | Auto-allowed | Must allow explicitly |
| Exam tip | Always check NACL if SG seems fine |

---
## VPC Peering

### What It Is 🔗
- Connect **two VPCs** to behave as one network
- Can be **same account / cross-account / cross-region**
- VPC CIDRs **must NOT overlap**
- **Not transitive**: A↔B, B↔C ≠ A↔C

### How It Works
- Create peering connection → accept
- Update **route tables** in all involved subnets
- Security groups can reference SGs in peered VPCs (powerful)

### Routing 🗺️
- Add CIDR of peered VPC as destination
- Target: VPC Peering connection
- Must configure routes in **both VPCs** for bidirectional traffic

### Security Notes 🔒
- SGs: allow traffic from **peered SG** or CIDR
- NACLs: ensure inbound/outbound allow peered CIDR
- Exam tip: peering ≠ automatic connectivity

### Exam Tips ⭐
- Always check **CIDR overlap**
- Always update **route tables**
- SG referencing other SG is allowed **within region**
- Peering connection must be **accepted** before working

---
## VPC Endpoints

### Purpose 🔗
- Access **AWS services privately** from VPC
- Avoid public internet, NAT gateway, or IGW
- Uses **AWS PrivateLink** for private network access
- Redundant & horizontally scalable

### Types of VPC Endpoints
- **Interface Endpoint (ENI)**
  - Powered by **PrivateLink**
  - Private IP in your VPC
  - Requires **security group**
  - Supports most AWS services
  - Cost: per hour + per GB
  - Use when private access needed from **on-prem or other VPCs**
- **Gateway Endpoint**
  - Only for **S3 & DynamoDB**
  - Configured as **route table target**
  - Free & scales automatically
  - Preferred for exam unless cross-VPC/on-premises access required

### How It Works 🗺️
- Private route to AWS service via endpoint
- Interface → via ENI & SG  
- Gateway → via route table
- No internet/NAT required
- DNS must be enabled for proper resolution

### Route Tables
- Interface: ENI handles routing  
- Gateway: add route to endpoint in **private subnet route table**
- Exam tip: Gateway endpoint = **preferred for S3/DynamoDB**

### Security Notes 🔒
- Attach IAM role/policy to EC2 for service access
- SG needed for Interface endpoints
- Ephemeral ports not an issue for endpoints (service-managed)

### Exam Tips ⭐
- Use **Gateway endpoint for S3/DynamoDB** (free + simple)
- Interface endpoint for **other AWS services or cross-VPC/on-prem**
- Always check **route table & DNS settings**
- Traffic **never leaves AWS network**

---
## VPC Flow Logs

### Purpose 🔍
- Capture **IP traffic metadata** for VPC, subnets, or ENIs
- Monitor & troubleshoot connectivity issues
- Useful for **security analysis**, detecting attacks, or usage patterns

### Supported Targets
- **CloudWatch Logs** – real-time monitoring, metrics, alarms  
- **Amazon S3** – batch storage & analytics via Athena/QuickSight  
- **Kinesis Data Firehose** – streaming to other services

### Key Features ⚡
- Supports **AWS managed interfaces**: ELB, RDS, Redshift, NAT, Transit Gateway, etc.
- Captures:
  - Source & destination IPs
  - Source & destination ports
  - Protocol
  - Packets, bytes
  - Action: **ACCEPT/REJECT**
  - Log status & interface ID
- Use **action field** to troubleshoot **Security Groups (stateful)** and **NACLs (stateless)**
  - Inbound reject → SG or NACL  
  - Inbound accept + outbound reject → NACL  
  - Outbound reject → SG or NACL  
  - Outbound accept + inbound reject → NACL

### Flow Log Architecture 🗺️
- CloudWatch Logs → Metrics filters & Contributor Insights  
  - Detect unusual traffic (SSH, RDP, etc.)
  - Trigger alarms via SNS
- S3 → Athena → SQL queries → QuickSight visualizations
- Permissions:
  - IAM role for VPC Flow Logs must have:
    - `logs:CreateLogGroup`
    - `logs:CreateLogStream`
    - `logs:PutLogEvents`
  - Required for CloudWatch Logs delivery

### Best Practices ✅
- Choose **aggregation interval**:
  - 1 min → fast debugging, more records  
  - 10 min → cost-effective for production
- Filter traffic as needed: **ACCEPT, REJECT, or ALL**
- Use **partitions** in Athena for efficient querying

### Exam Tips ⭐
- VPC Flow Logs **do not capture packet payloads**, only metadata
- Use **CloudWatch Logs** for real-time analysis  
- Use **S3 + Athena** for large-scale historical analysis  
- Combine with **SNS** or **QuickSight** for alerts & visualization

---
## Site-to-Site VPN

### Purpose 🔗
- Connect **on-premises networks** to AWS VPCs securely
- Uses **encrypted VPN tunnels** over the **public internet**
- Can extend private networks or provide multi-site connectivity

### Key Components ⚙️
1. **Customer Gateway (CGW)**  
   - Device/software on your corporate network  
   - Public IP (or NAT device public IP if behind NAT-T)  
   - Optional BGP ASN for dynamic routing  

2. **Virtual Private Gateway (VGW)**  
   - VPN concentrator on the AWS side  
   - Attached to a VPC  
   - Optional ASN customization  

3. **VPN Connection**  
   - Links VGW ↔ CGW  
   - Encrypted traffic over the public internet  
   - Can use static or dynamic routing (BGP)

### Routing & Security 🛡️
- **Route propagation** must be enabled in VPC route tables for VPN to work
- Ensure **ICMP (ping) allowed** in security groups if needed
- Traffic passes over **public internet**, but **encrypted**

### Advanced: AWS VPN CloudHub 🌐
- Hub-and-spoke model for **multiple on-premises sites** connecting to one VGW  
- Each site has its own CGW  
- Enables **secure site-to-site communication between on-premises locations**
- Uses multiple VPN connections + dynamic routing
- Cost-effective for primary/secondary network connectivity

### Exam Tips ⭐
- Steps to set up a Site-to-Site VPN:
  1. **Create Customer Gateway** (on-premises IP, optional BGP ASN)
  2. **Create Virtual Private Gateway** (attach to VPC, optional ASN)
  3. **Create VPN Connection** (link CGW ↔ VGW, configure routing)
- **CloudHub** = multiple CGWs connect to one VGW for multi-site VPN
- VPNs **do not require a direct private line**; use internet + encryption

---
## AWS Direct Connect (DX)

### What it is 🔗
- Dedicated **private connection** from on-premises → AWS  
- Avoids public internet → **lower latency, higher bandwidth, predictable network**  
- Access:
  - **Private VIF** → VPC subnets  
  - **Public VIF** → AWS public services  
  - **Direct Connect Gateway** → multi-VPC/multi-region access  

### Use Cases ⚡
- Large data transfers  
- Hybrid cloud  
- Real-time apps  
- Multi-region access  

### Connection Types 🔌
- **Dedicated:** 1/10/100 Gbps, physical port, setup >1 month  
- **Hosted:** 50 Mbps → 10 Gbps, via partner, flexible capacity  

> **Exam tip:** DX setup is slow → not for urgent transfers if no existing connection  

### Security 🔒
- Private but **not encrypted**  
- Optional: **VPN over DX** for IPsec encryption  

### Resiliency 🛡️
- **High:** 2 DX locations + 2 corporate sites  
- **Maximum:** 2 locations × 2 connections = 4 independent links  

### Exam Architecture 🏢
- Primary: Direct Connect  
- Backup: Site-to-Site VPN → ensures connectivity if DX fails

---
## AWS Transit Gateway & VPC Traffic Mirroring

### Transit Gateway (TGW) 🛠️
- **Purpose:** Simplifies complex AWS networks (multi-VPC, VPNs, Direct Connect)  
- **Topology:** Hub-and-spoke, transitive routing between VPCs, on-prem, DX, VPN  
- **Key Features:**
  - Regional, can **peer across regions**
  - Share across accounts via **Resource Access Manager**
  - Supports **IP multicast** (unique in AWS)
  - Route tables control which attachments can communicate  

### Performance & VPN ECMP ⚡
- ECMP = Equal-Cost Multi-Path Routing → use multiple tunnels for higher throughput  
- **VPN direct to VPC:** max 1.5 Gbps (2 tunnels per VPN)  
- **VPN via TGW:** single VPN → 2.5 Gbps, add more VPNs → more throughput  
- **Cost:** per GB through TGW  

### Direct Connect Sharing 🌐
- DX → Direct Connect Gateway → Transit Gateway → multiple VPCs/accounts  
- Allows **sharing DX connection** across accounts & regions  

### VPC Traffic Mirroring 🔍
- **Purpose:** Capture and inspect ENI traffic non-intrusively  
- **Components:**
  - **Source ENI(s):** where traffic originates
  - **Target ENI or NLB:** where mirrored traffic is sent  
- **Optional:** Filters to capture specific traffic  
- **Use Cases:** Threat monitoring, content inspection, troubleshooting  
- **Topology:** Works within VPC or across VPCs with peering  
- **Behavior:** Original traffic continues normally; mirrored copy sent to analysis targets

---
## IPv6 in AWS 🌐

### Why IPv6?
- IPv4: 4.3 billion addresses → soon exhausted  
- IPv6: 3.4×10³⁸ addresses, **public and internet-routable**  
- Format: 8 groups of hexadecimal (0000–ffff)  

### Key Points
- AWS VPCs **cannot disable IPv4**, but IPv6 can be **enabled**  
- Dual-stack mode: EC2 gets **private IPv4 + public IPv6**  
- Internet Gateway supports **IPv4 & IPv6 connectivity**  

### Exam Scenario: EC2 Launch Failure
- EC2 cannot launch in IPv6-enabled VPC?  
  - Not IPv6 exhaustion (space is huge)  
  - Likely **IPv4 exhaustion in subnet** → solution: add new IPv4 CIDR  

### IPv6 Hands-On
1. **Enable IPv6 on VPC:** Add an **IPv6 CIDR block** (Amazon-provided or custom)  
2. **Enable IPv6 on Subnets:** Assign IPv6 CIDR & enable **auto-assign**  
3. **Assign IPv6 to EC2:**  
   - Go to **Network → Manage IP Addresses → Assign IPv6**  
4. **Update Security Group:** Add inbound rules for IPv6 (e.g., SSH `::/0`)  
5. **Route Table:** AWS automatically adds `local` route for IPv6 traffic within VPC  

### Notes
- Even with many IPv6 addresses, **IPv4 limits still apply** per subnet  
- IPv6 allows direct internet access if provider supports it  
- Useful for modern apps, dual-stack networks, and future-proofing deployments  

---
## Egress-Only Internet Gateway (EIGW) – IPv6 🔒

### What It Is
- IPv6-only gateway, similar to **NAT Gateway** (which is IPv4)  
- Purpose: allow **outbound IPv6 traffic** while **blocking inbound IPv6 connections** from the internet  

### How It Works
- Public Subnet:
  - EC2 has IPv4 + IPv6 → uses **Internet Gateway** (IGW) for both  
  - Inbound/outbound internet access allowed  
- Private Subnet:
  - IPv4 → uses **NAT Gateway** for outbound internet access  
  - IPv6 → uses **Egress-Only Internet Gateway** for outbound only  

### Route Table Example
| Traffic Type | Destination | Target |
|--------------|------------|--------|
| Local IPv4   | VPC CIDR   | local  |
| Local IPv6   | VPC IPv6   | local  |
| IPv4 Internet| 0.0.0.0/0  | NAT GW |
| IPv6 Internet| ::/0       | EIGW   |

### Key Points
- EC2 in private subnet can **reach the internet over IPv6**  
- Internet **cannot initiate connections to EC2**  
- Helps **secure private subnets** while using IPv6  

### Hands-On Summary
1. Create **Egress-Only Internet Gateway** → attach to VPC  
2. Edit **private subnet route table** → add `::/0` → EIGW  
3. Private EC2 instances now have **outbound IPv6 access only**  

✅ Useful for IPv6-only outbound traffic in private subnets

---
## VPC & Networking – Full Summary 🌐

### Key Concepts
- **CIDR** → IP address range  
- **VPC** → Virtual Private Cloud (IPv4 + IPv6)  
- **Subnets** → tied to an AZ, can be **public** or **private**  
  - Public subnet → attach **Internet Gateway** + route to IGW  
  - Private subnet → uses NAT Gateway (IPv4) or Egress-Only IGW (IPv6)  

### Routing & Access
- **Route Tables** → control traffic flow within VPC  
- **Bastion Host** → public EC2 used to SSH into private EC2s  
- **NAT Instance** → old method, now replaced by **NAT Gateway** (managed, scalable)  
- **Security**
  - **NACL** → subnet-level, **stateless**, evaluates inbound/outbound separately  
  - **Security Groups** → instance-level, **stateful**, inbound = outbound automatically  

### VPC Connectivity
- **VPC Peering** → connects 2 VPCs (non-overlapping CIDRs, non-transitive)  
- **VPC Endpoints** → private access to AWS services  
  - Gateway Endpoints → S3, DynamoDB  
  - Interface Endpoints → other AWS services via ENI  
- **VPC Flow Logs** → metadata on traffic, can be sent to **S3** (analyzed via Athena) or **CloudWatch Logs**  

### Hybrid Connectivity
- **Site-to-Site VPN** → encrypted, over public internet  
  - AWS: Virtual Private Gateway (VGW)  
  - On-prem: Customer Gateway (CGW)  
  - Multiple VPNs → **VPN CloudHub** for hub-and-spoke  
- **Direct Connect** → private connection, more secure & stable  
  - Direct Connect Gateway → connect multiple VPCs across regions  

### Advanced Networking
- **PrivateLink / VPC Endpoint Services** → expose private services without IGW/NAT/peering  
- **ClassicLink** → connect EC2-Classic to VPC (deprecated soon)  
- **Transit Gateway** → transitive hub for VPCs, VPNs, Direct Connect, allows full network flow  
- **Traffic Mirroring** → copy ENI traffic for analysis  

### IPv6
- Dual-stack mode: IPv4 + IPv6 in VPC  
- **Egress-Only Internet Gateway** → IPv6 outbound only, similar to NAT Gateway  

### Exam Tips
- Understand differences: **IGW vs NAT Gateway vs Egress-Only IGW**  
- Know connectivity options: **VPC Peering, Transit Gateway, VPN, Direct Connect**  
- Remember: **NACL stateless**, **Security Groups stateful**  
- Flow Logs: **VPC, Subnet, ENI levels**, analyze via S3/Athena or CloudWatch  

---
## AWS Networking Cost Overview 💰

### Key Principles
- **Ingress traffic (into AWS)** → free  
- **Egress traffic (out of AWS)** → paid, varies by destination  

### EC2 to EC2 Communication
- **Same AZ, private IP** → free  
- **Different AZ, private IP** → ~$0.01/GB  
- **Different AZ, public/elastic IP** → ~$0.02/GB  
- **Different region** → ~$0.02/GB  
💡 **Tip:** Use private IPs and same AZ for cost savings and better performance.  

### Example: RDS Read Replica
- Same AZ → free replication  
- Different AZ → $0.01/GB for replication  

### Optimizing Network Costs
1. Keep traffic **within AWS** whenever possible  
2. Move applications closer to the data → reduces egress  
   - Example: querying DB from AWS EC2 instead of on-premises reduces cost  
3. **Direct Connect** → choose co-located AWS region for lower egress  

### S3 Data Transfer
- **Upload to S3** → free  
- **Download from S3 to internet** → ~$0.09/GB  
- **S3 Transfer Acceleration** → +$0.04–$0.08/GB  
- **S3 → CloudFront** → free  
- **CloudFront → Internet** → ~$0.085/GB  
  - Requests via CloudFront cheaper than direct S3 requests (~7x cheaper)  
- **Cross-region S3 replication** → $0.02/GB  

### NAT Gateway vs VPC Endpoint (Gateway)
- **NAT Gateway**:  
  - $0.045/hour + $0.045/GB processed + $0.09/GB for cross-region egress  
- **VPC Endpoint (Gateway)**:  
  - Direct private access to S3  
  - ~$0.01/GB in/out (same region)  
💡 **Tip:** Using VPC Endpoints can drastically reduce network costs compared to NAT Gateway.  

### Takeaways
- Prefer **private IP** and **same AZ** for inter-EC2 communication  
- Minimize **egress traffic** outside AWS  
- Use **VPC Endpoints** for private service access  
- Use **CloudFront** to lower S3 request & egress costs  
- Consider **Direct Connect** wisely for large outbound transfers  

✅ Networking cost depends on AZ, region, and path; plan architecture to balance cost vs. high availability.

---
## AWS Network Protection 🔐

### Existing Controls
- **NACLs**: subnet-level, stateless  
- **Security Groups**: instance-level, stateful  
- **AWS WAF**: protects HTTP/HTTPS apps  
- **AWS Shield / Shield Advanced**: DDoS protection  
- **AWS Firewall Manager**: central rule management across accounts  

### AWS Network Firewall
- **Managed firewall at VPC level**
- Protects **Layer 3 to Layer 7**
- Inspects traffic:
  - VPC ↔ Internet
  - VPC ↔ VPC (peering / TGW)
  - VPC ↔ Direct Connect
  - VPC ↔ Site-to-Site VPN

### How It Works
- Uses **Gateway Load Balancer** internally
- No third-party appliances
- Rules centrally managed with **Firewall Manager**

### Capabilities
- Thousands of rules per VPC
- Filtering by:
  - IP ranges
  - Ports
  - Protocols (e.g. block SMB)
  - Domains
  - Regex patterns
- Actions: **allow, drop, alert**
- **Stateful inspection & intrusion prevention**
- Logs to **S3, CloudWatch Logs, Kinesis Firehose**

### Key Takeaway
- **AWS Network Firewall = full VPC-wide network protection**
- Centralized, scalable, deeply inspect traffic
- Think **VPC-level firewall**, not subnet or instance
