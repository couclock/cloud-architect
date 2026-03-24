# Other networking stuff

## Table of Contents

- [Other networking stuff](#other-networking-stuff)
  - [Table of Contents](#table-of-contents)
  - [NAT (Network Address Translation)](#nat-network-address-translation)
  - [IP Addressing \& Subnetting](#ip-addressing--subnetting)
  - [DDoS Attacks](#ddos-attacks)
  - [VLANs, Trunking \& Q-in-Q](#vlans-trunking--q-in-q)
  - [Binary \& IPv4](#binary--ipv4)
  - [SSL/TLS](#ssltls)
  - [BGP](#bgp)
  - [Firewalls](#firewalls)
  - [Jumbo Frames](#jumbo-frames)
  - [Layer 7 Firewalls](#layer-7-firewalls)
  - [IPsec VPN](#ipsec-vpn)
  - [Fiber Optics](#fiber-optics)

## NAT (Network Address Translation)

### 🌍 Core
- **Private → Public IP translation**
- Solves **IPv4 shortage**
- Enables **internet access for private subnets**

### 🔒 Benefits
- **Hides internal IPs** (basic security)
- Conserves **public IPs**

### 🧠 Key Rule
- Outbound: **Src IP translated**
- Inbound: **Dest IP translated**
- Uses **NAT table (state tracking)** ⚠️

### 🧩 NAT Types

#### 1️⃣ Static NAT
- **1:1 mapping (private ↔ public)**
- Persistent public IP
- **Bidirectional**
- AWS: **Internet Gateway (public IP)**

#### 2️⃣ Dynamic NAT
- **Pool of public IPs**
- Allocated **temporarily**
- Can **run out of IPs** ❌
- Many → few (not simultaneous)

#### 3️⃣ PAT (Port Address Translation) ⭐
- **Many → 1 public IP**
- Uses **ports to differentiate**
- AKA: **NAT Overload**
- AWS: **NAT Gateway / NAT Instance**

### 🔢 PAT Logic
- Tracks: **Private IP + Port → Public IP + Port**
- Uses **ephemeral ports**
- Enables **multiple simultaneous connections**

### ⚠️ Limitations
- ❌ No inbound (no NAT table entry)
- ❌ Breaks end-to-end addressing
- ❌ Port exhaustion possible

### 🌐 IPv6
- ❌ **No NAT needed**
- Huge address space

### ☁️ AWS Mapping
- **Internet Gateway** → Static NAT (1:1 public IP)
- **NAT Gateway** → PAT (private → internet only)
- Private subnets → **egress via NAT**

### 🎯 Exam Tips
- **PAT = most common**
- NAT GW = **outbound only**
- Public EC2 = **IGW (not NAT)**
- Private EC2 → **NAT for internet**
- No inbound → use **ALB / Bastion**

### ✅ Key Takeaway
- NAT = **critical for AWS VPC design**
- Know **types + AWS mapping**

---
## IP Addressing & Subnetting

### IPv4 Basics 🌐
- 32-bit → ~4.3B addresses (0.0.0.0 → 255.255.255.255)
- Public IPs = allocated (IANA → regional bodies)
- ❗ Scarcity → key driver for AWS design choices
- Private IPs used in VPCs (not internet routable)

### Private IP Ranges (RFC1918) 🔒
- 10.0.0.0/8 → large (AWS common)
- 172.16.0.0–172.31.255.255 (/12) → AWS default VPC = 172.31.0.0/16
- 192.168.0.0/16 → small networks
- ♻️ Reusable but MUST avoid overlap (peering/VPN issues)

### NAT (Exam Favorite) 🔁
- Private → Public translation
- Required for internet access from private subnets
- AWS: NAT Gateway / NAT Instance

### IPv4 Classes (Legacy – know basics) 🧠
- Class A → /8 (large orgs)
- Class B → /16
- Class C → /24
- Class D → multicast
- Class E → reserved
- ❗ Replaced by CIDR in AWS

### CIDR & Prefix 🧩
- Format: x.x.x.x/**/n**
- n = network bits
- 🔑 Larger prefix = smaller network
- Examples:
  - /8 → large
  - /16 → medium
  - /24 → small
  - /32 → single IP
- 0.0.0.0/0 = all internet (default route)

### Subnetting 🔀
- Split network → smaller subnets
- Each split:
  - Prefix +1
  - Size ÷2
- Example:
  - /16 → two /17
  - /17 → two /18
- Used in AWS VPC subnet design

### AWS VPC Design Tips ☁️
- Use private ranges (RFC1918)
- Plan **non-overlapping CIDRs** (VPC Peering, TGW)
- Start large → subnet later (flexibility)
- Typical subnet sizes:
  - /24 (common)
  - /28 (small, limited IPs)

### Exam Key Rules ⚠️
- Overlapping CIDR = ❌ connectivity failure
- Larger CIDR block = more IPs
- Subnets cannot overlap within VPC
- AWS reserves 5 IPs per subnet
- Think in powers of 2 (subnet splits)

### IPv6 Basics 🚀
- 128-bit → massive space (~340 undecillion)
- No scarcity → no NAT needed
- Used in modern AWS architectures
- Simplifies addressing, global uniqueness

### Mental Models 🧠
- Subnetting = “divide by 2”
- Prefix ↑ → size ↓
- Always design for future growth

---
## DDoS Attacks

### DDoS Overview 🌐
- Goal: overwhelm app/network → deny service
- Uses massive distributed traffic (botnets)
- ❗ Hard to block (millions of IPs, legit-looking traffic)

### Botnets 🤖
- Compromised devices (malware infected)
- Controlled by attacker
- Distributed globally → hard to filter

### DDoS Categories 🧠

#### 1. Application Layer (L7) 🔥
- Example: HTTP floods
- Exploit: request cheap, response expensive
- Impact:
  - CPU exhaustion
  - App crashes / slow responses
- ❗ Looks like real user traffic

#### 2. Protocol Attacks (L3/L4) ⚙️
- Example: SYN flood
- Exploit: TCP 3-way handshake
  - Fake SYN → server waits (SYN-ACK never completed)
- Impact:
  - Connection table exhaustion
  - Blocks legit connections

#### 3. Volumetric / Amplification 🌊
- Example: DNS amplification
- Exploit: small request → large response
- Uses spoofed IP (victim)
- Impact:
  - Bandwidth saturation
  - Network link overwhelmed

### Key Attack Concepts ⚠️
- IP spoofing = fake source IP
- Amplification = attacker uses others (e.g., DNS)
- Traffic often indistinguishable from legit
- ❗ Blocking single IPs ineffective

### Normal Architecture vs Attack 🏗️
- Normal:
  - Users → Internet → App (HTTPS 443)
  - Scaled servers + limited bandwidth
- Under attack:
  - Botnet floods traffic
  - Exhausts:
    - CPU (L7)
    - Connections (L4)
    - Bandwidth (L3)

### AWS Protection Services ☁️
- AWS Shield:
  - Standard (auto, free)
  - Advanced (enhanced protection, cost)
- AWS WAF:
  - Filter L7 (HTTP/HTTPS)
- CloudFront:
  - Edge protection + caching
- Route 53:
  - Highly resilient DNS

### AWS Mitigation Strategies 🛡️
- Use CloudFront (edge absorbs traffic)
- Enable WAF rules (rate limiting, filtering)
- Use Shield Advanced for critical apps
- Auto Scaling → absorb spikes
- Use ALB/NLB (managed scaling)

### Exam Tips 🎯
- L7 attack → use WAF
- L3/L4 attack → Shield
- Global apps → CloudFront + Route53
- ❗ DDoS ≠ firewall problem (needs managed services)
- Always design for **absorption + distribution**

### Mental Models 🧠
- L7 = CPU problem
- L4 = connection problem
- L3 = bandwidth problem
- Best defense = **scale + distribute + filter**

---
## VLANs, Trunking & Q-in-Q

### VLAN 🧩
- L2 logical segmentation → **isolated broadcast domains**
- Same physical net → multiple virtual nets
- ❗ No inter-VLAN comms (needs L3)

### Why 📌
- Reduce broadcast
- Improve isolation/security
- Logical grouping (no rewiring)

### 802.1Q 🏷️
- VLAN tag in frame (12-bit ID)
- ~4094 VLANs
- ❗ Used in Direct Connect (VIFs)

### Ports 🔀
- Access: 1 VLAN, untagged (devices)
- Trunk: many VLANs, tagged (switch↔switch)

### Traffic 📦
- Broadcast = VLAN only
- Access: strip tag
- Trunk: keep tag

### Q-in-Q 🧱
- 802.1ad = VLAN stacking
- C-TAG (customer) + S-TAG (provider)
- Used by service providers

### AWS ☁️
- VPC ≈ VLAN concept (isolation)
- Direct Connect uses VLAN tagging

### Exam ⚠️
- VLAN = broadcast isolation
- No L3 = no inter-VLAN routing
- 802.1Q = standard VLAN
- Q-in-Q = nested VLANs

### Mental 🧠
- VLAN = “virtual network”
- Trunk = “multi-VLAN link”

---
## Binary & IPv4

### IPv4 🌐
- 32-bit = 4 octets (0–255)
- ❗ Binary used for CIDR/subnetting

### Binary Table 🧠
- 128 64 32 16 8 4 2 1

### Dec → Bin 🔀
- ≥ value → 1 (subtract)
- < value → 0
- Ex:
  - 133 → 10000101
  - 33 → 00100001

### Bin → Dec 🔁
- Sum bits = 1
- Ex:
  - 10000101 → 128+4+1=133

### Patterns ⚡
- 255 → 11111111
- 0 → 00000000

### AWS ☁️
- CIDR = binary mask
- Subnetting = bit split

### Exam 🎯
- Per octet
- Memorize table
- ❗ Binary = key for VPC design

---
## SSL/TLS

### Basics 🔐
- TLS = modern SSL
- Provides:
  - Encryption (privacy)
  - Authentication (identity)
  - Integrity (no tampering)

### Encryption Flow 🔁
- Start: **Asymmetric** (public key)
- Then: **Symmetric** (faster)
- ❗ TLS = hybrid encryption

### TLS Handshake 🤝
1. Client Hello (cipher list)
2. Server Hello (+ certificate)
3. Auth (verify cert via CA)
4. Key exchange → session keys

### Certificates 📜
- Contains: public key + domain
- Signed by **CA (trusted)**
- Client verifies:
  - CA trust
  - Expiry/revocation
  - Domain match

### Keys 🔑
- Public key → encrypt to server
- Private key → decrypt on server
- Shared secret → symmetric keys

### AWS ☁️
- HTTPS = TLS (ALB, CloudFront, API GW)
- ACM = cert management
- End-to-end encryption best practice

### Exam 🎯
- TLS > SSL (use TLS)
- Asymmetric → symmetric switch
- CA = trust model
- ❗ HTTPS = TLS over TCP (443)

### Mental 🧠
- TLS = “secure tunnel”
- Handshake = “trust + key setup”

---
## BGP

### 🌐 Basics
- Routing protocol (inter-network)
- Internet = **Autonomous Systems (AS)**
- AS = single admin domain (black box)
- ID = **ASN**

### 🔢 ASN
- 16-bit (0–65535)
- Private: 64512–65534
- Assigned by IANA

### ⚙️ BGP
- Path vector → **best path only**
- Uses TCP 179
- ❗ Manual peering

### 🔗 Peering
- Exchange routes between AS
- Learned routes → re-advertised

### 🧭 Path Selection
- Based on **AS-PATH length**
- ✅ Shortest path wins
- ❌ Ignores latency/bandwidth

### 🔀 IBGP vs EBGP
- IBGP: inside AS
- EBGP: between AS (AWS use case)

### 🔁 Behavior
- Advertises **best route only**
- Backup paths kept → HA

### 🎯 Control
- **AS Path Prepending** → longer path = less preferred
- Used for traffic engineering

### ☁️ AWS
- Used in:
  - Direct Connect
  - Site-to-Site VPN (dynamic)

### 🧠 Exam Tips
- Policy-based routing
- Shortest AS path rule
- Prepending = key trick
- EBGP in hybrid AWS
- No auto peering

---
## Firewalls

### 🌐 TCP Flow
- Conn = **request + response**
- Client → **ephemeral port (1024–65535)**
- Server → **well-known port (e.g. 443)**
- Response = **reverse path**

### 🚫 Stateless
- ❌ No state tracking
- **Req + Resp = separate**
- → **2 rules (in/out)**
- Must allow **ephemeral ports (wide range)** ❗
- 🔴 Complex / error-prone

### ✅ Stateful
- ✔ Tracks connections
- **Only request rule needed**
- Response = **auto allowed**
- No ephemeral port config

### ☁️ AWS
- SG → 🟢 Stateful
- NACL → 🔴 Stateless

### 🧠 Exam
- Stateless = 2 rules
- Stateful = 1 rule
- Start with **request direction**
- Ephemeral ports = key trap

---
## Jumbo Frames

### 🌐 Basics
- Standard frame = **1500 bytes**
- Jumbo frame = **~9000 bytes**
- Frame = **overhead + payload**

### ⚡ Why Jumbo Frames
- ✔ More payload / frame
- ✔ Less overhead ratio
- ✔ Fewer frames → less gaps
- ✔ Better throughput (high data workloads)

### ⚠️ Constraints
- ❗ End-to-end support required
- ❗ Otherwise → **fragmentation**
- Not all AWS services support it

### ☁️ AWS Support
- ✅ Same VPC → supported
- ✅ Same-region VPC peering → supported
- ✅ Direct Connect → supported
- ⚠️ Transit Gateway → up to **8500 bytes**

- ❌ Internet Gateway
- ❌ VPN
- ❌ Inter-region peering

### 🧠 Exam Tips
- Jumbo = **efficiency gain**
- Requires **full path compatibility**
- Fragmentation = key risk
- DX supports, VPN/IGW don’t

---
## Layer 7 Firewalls

### 🌐 Layers Recap
- L3/4 → IP + ports
- L5 → sessions (stateful)
- ❌ No visibility into **application data**

### 🚫 L3–L5 Limits
- See traffic as **packets/flows only**
- ❌ Cannot inspect:
  - HTTP headers
  - content / payload
- Malware = normal traffic ❗

### 🤖 Layer 7 Firewall
- ✔ Understands **app protocols (HTTP, SMTP…)**
- ✔ Sees:
  - headers
  - URLs / DNS
  - content

### 🔍 Deep Inspection
- HTTPS → **terminated at firewall**
- Decrypt → inspect → re-encrypt
- Enables:
  - allow / block / modify traffic

### 🎯 Capabilities
- Content filtering (malware, spam)
- App control (block apps)
- Data leak prevention
- Rate limiting / behavior analysis

### ⚡ Key Advantage
- ✔ Context-aware security (not just IP/port)
- ✔ Granular control at **application level**

### ☁️ AWS (concept)
- L7 = advanced filtering (e.g. HTTP-based)
- Complements SG/NACL (L3/4)

### 🧠 Exam Tips
- L3/4 = **network-level only**
- L7 = **application-aware**
- HTTPS inspection = **decrypt + inspect**
- Enables **fine-grained security**
  
---
## IPsec VPN

### 🌐 Basics
- IPsec = **secure tunnels over internet**
- Connects **peers (routers/networks)**
- ✔ Encryption + Authentication

### 🔐 Encryption Logic
- Asymmetric → **key exchange**
- Symmetric → **data encryption (fast)**

### ⚙️ Phases
#### Phase 1 (IKE)
- Auth (PSK / cert)
- Diffie-Hellman (DH)
- Creates **IKE SA (secure channel)**

#### Phase 2 (IPsec)
- Uses Phase 1
- Negotiates encryption
- Creates **IPsec SA (data tunnel)**

### 🔁 Traffic Flow
- Only **“interesting traffic”** enters tunnel
- Tunnel:
  - created on demand
  - torn down when idle

### 🔑 Key Concepts
- SA = Security Association
- 2 SAs → **bi-directional traffic**
- Phase 1 persists, Phase 2 dynamic

### 🔀 VPN Types
- **Route-based**
  - Prefix-based
  - 1 tunnel / network
  - ✔ Simple

- **Policy-based**
  - Rule-based (traffic type)
  - Multiple tunnels
  - ✔ Flexible

### ☁️ AWS
- Site-to-Site VPN = IPsec
- Used for hybrid connectivity

### 🧠 Exam Tips
- IPsec = **secure tunnel over public internet**
- Phase 1 = setup, Phase 2 = data
- DH = key exchange method
- Route-based = default/simple
- Policy-based = granular control

---
## Fiber Optics

### 🌐 Basics
- Fiber = **light over glass/plastic**
- vs Copper = electrical signals
- ✔ Higher speed + longer distance
- ✔ Immune to EMI

### ⚙️ Structure
- Core → carries light
- Cladding → keeps light inside (reflection)
- Buffer/Jacket → protection
- Format: **X/Y = core/cladding (microns)**

### ⚡ Performance
- ✔ Less overhead, high throughput
- ✔ Tbps possible
- ✔ Stable over long distance

### 🔀 Types
#### Single Mode (SMF)
- Small core (~9µm)
- Laser optics
- ✔ Long distance (km)
- ✔ High speed (10G+)
- ❗ Expensive optics

#### Multi Mode (MMF)
- Larger core
- LED optics
- ✔ Short distance
- ✔ Cheaper
- ❗ More distortion

### 🔌 Transceivers
- **SFP (mini-GBIC)**
- Convert: data ↔ light
- Must match cable type (SMF/MMF)

### ☁️ AWS (Direct Connect)
- Uses fiber + SFP
- Common:
  - 1000BASE-LX
  - 10GBASE-LR
  - 100GBASE-LR4

### 🧠 Exam Tips
- Fiber > copper (speed + distance)
- SMF = long distance
- MMF = short + cheaper
- SFP = required for fiber ports
- DX = fiber-based