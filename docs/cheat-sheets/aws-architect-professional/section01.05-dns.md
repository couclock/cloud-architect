# DNS & DNSSEC

## Table of Contents

- [DNS \& DNSSEC](#dns--dnssec)
  - [Table of Contents](#table-of-contents)
  - [DNS](#dns)
  - [DNSSEC](#dnssec)

## DNS

### What DNS Does
- 🌐 Translates **names → IPs**
- Humans use **DNS names**; networks use **IP addresses**
- Critical dependency: if DNS fails, **apps/services fail**
- Think of DNS as a **global distributed database**

### Why DNS Is Distributed
- ❌ One DNS server = single point of failure
- ❌ Small DNS cluster = poor **scale**, **risk**, **data volume**
- ✅ DNS is **hierarchical** and **delegated**
- Benefits:
  - Better **availability**
  - Better **scalability**
  - Shared **management responsibility**
  - Reduced **query scope/load**

### Core DNS Terms
- **Zone** = portion of DNS namespace (e.g. `netflix.com`)
- **Zone file** = stored records for a zone
- **Name Server (NS)** = server hosting one/more zones
- **Authoritative** = source of truth for a zone
- **Non-authoritative** = cached answer
- **Resolver** = DNS server that queries on behalf of clients
- **Hosts file** = static local override before DNS

### DNS Hierarchy
- **Root (`.`)** → knows **TLD** name servers
- **TLD** (e.g. `.com`, `.io`, `.uk`) → knows **domain** name servers
- **Domain zone** (e.g. `netflix.com`) → contains actual records
- Query path:
  - Root → `.com`
  - `.com` → `netflix.com`
  - `netflix.com` → `www.netflix.com` answer

### Root & TLD Facts
- Root = trusted **starting point**
- Root zone contains **TLD delegation info**
- **IANA** manages **root zone contents**
- **ICANN + operators** manage root server infrastructure
- Root uses **13 IP addresses** (implemented globally with **Anycast**)
- TLDs delegated to **registries**
  - Example: `.com` → **Verisign**

### How DNS Resolution Works
- 1️⃣ Check **Hosts file**
- 2️⃣ Check **local DNS cache**
- 3️⃣ Query **resolver**
- 4️⃣ Resolver checks **its cache**
- 5️⃣ Resolver queries **Root**
- 6️⃣ Root returns **TLD NS**
- 7️⃣ Resolver queries **TLD NS**
- 8️⃣ TLD returns **domain NS**
- 9️⃣ Resolver queries **authoritative NS**
- 🔟 Returns answer + caches it

### Key Resolution Concepts
- **Walking the tree** = iterative resolution path
- No single DNS server has **all answers**
- Each DNS layer moves query **closer to answer**
- Cached responses improve **speed**
- Only authoritative NS gives **authoritative response**

### Record Behavior / Performance
- DNS answers may return:
  - **IP directly**
  - **Another DNS name** via **CNAME**
- CNAME may trigger **extra lookups**
- ⚠️ More DNS lookups = more **latency**
- Exam angle: DNS design affects **app performance**

### Domain Registration Flow
- Roles:
  - **Registrant** = buyer
  - **Registrar** = sells/registers domain
  - **DNS hosting provider** = hosts zone on NS
  - **Registry** = manages TLD
- Flow:
  - Buy domain via **registrar**
  - Create/host DNS **zone**
  - Registrar sends NS info to **registry**
  - Registry updates **TLD zone**
  - Domain becomes **live**

### Registrar vs DNS Hosting (Important)
- **Registrar** = domain purchase/registration
- **DNS hosting provider** = zone + records + NS hosting
- Same company can do both, but they are **different functions**
- 🔥 Common exam confusion point

### AWS Route 53 Mapping
- **Registered Domains** = **Registrar** function
- **Hosted Zones** = **DNS hosting** function
- Route 53 can do:
  - Domain registration
  - DNS hosting
  - Authoritative DNS

### SAP-C02 / SAA Exam Tips
- Know **authoritative vs cached**
- Know **resolver vs NS vs registrar**
- Know **Root → TLD → Domain** delegation chain
- Know **Route 53 hosted zone** ≠ **domain registration**
- Expect scenarios on:
  - **High availability DNS**
  - **Delegation**
  - **Latency / caching**
  - **CNAME extra lookup behavior**

### Best Practices
- ✅ Use **distributed authoritative DNS**
- ✅ Design for **DNS resilience**
- ✅ Understand **delegation boundaries**
- ✅ Minimize unnecessary DNS lookups
- ✅ Use caching wisely for performance

---
## DNSSEC

### What DNSSEC Is
- 🔐 **DNS security extension**
- **Adds to DNS**, does **not replace** it
- Normal DNS still works = **backward compatible**
- DNSSEC-aware clients get:
  - normal **DNS answers**
  - extra **DNSSEC validation data**

### Why DNSSEC Exists
- DNS by itself is **not secure**
- Main risks:
  - **Cache poisoning**
  - **Forged responses**
  - **Tampered records**
  - **Traffic redirection**
- DNSSEC lets clients detect:
  - **wrong source**
  - **modified data**

### What DNSSEC Protects
- ✅ **Data origin authentication**
  - “Did this data come from the real zone?”
- ✅ **Data integrity**
  - “Was this data altered?”
- ❌ Does **not encrypt**
- ❌ Does **not hide data**
- ❌ Does **not fix wrong answers**
- ❌ Only tells you **trust / don’t trust**

### Core DNSSEC Concepts
- **RRSET** = records with same **name + type**
- DNSSEC signs **RRSETs**, not individual records
- Example:
  - 4 MX records for same name = **1 RRSET**

### Main DNSSEC Records
- **RRSIG** = digital signature of an RRSET
- **DNSKEY** = stores public keys for a zone
- **DS** = parent zone trust record for child zone
- Normal DNS clients ignore these
- DNSSEC clients use them for validation

### DNSSEC Keys
- **ZSK** = Zone Signing Key
  - Signs **RRSETs** in the zone
- **KSK** = Key Signing Key
  - Signs the **DNSKEY RRSET**
- Private keys stay protected/offline/HSM-backed
- Public keys are published in **DNSKEY**

### Validation Inside a Zone
- RRSET + matching **RRSIG**
- Resolver uses **public ZSK** from **DNSKEY**
- If valid:
  - RRSET is trusted
  - data has not changed
- If RRSET changes, signature becomes invalid

### Why Two Keys (ZSK + KSK)
- **ZSK** changes more often
- **KSK** is more stable / higher trust anchor inside zone
- Benefit:
  - Rotate **ZSK** without updating parent zone
- Exam angle:
  - **Operational separation**
  - **Easier key rollover**

### Parent → Child Trust
- Parent zone contains:
  - **NS records** → normal DNS delegation
  - **DS record** → DNSSEC trust delegation
- **DS record = hash of child zone KSK**
- This means:
  - parent explicitly trusts child’s **KSK**

### DNSSEC Chain of Trust
- 🔗 Validation path:
  - **Root**
  - → **TLD** (e.g. `.org`)
  - → **Domain** (e.g. `icann.org`)
  - → **RRSET**
- At each level:
  - Parent validates child via **DS**
  - Child validates records via **DNSKEY + RRSIG**

### Trust Anchor
- Root has **no parent**
- So root KSK is **explicitly trusted**
- This is the **trust anchor**
- DNSSEC resolvers trust it by default
- Everything else chains down from it

### Root Signing Ceremony
- 🔐 Protects **root KSK**
- Root KSK is the **most trusted key in DNSSEC**
- Stored in secure facilities + **HSMs**
- Access requires:
  - multiple people
  - strict process
  - physical security
- Ceremony signs **root ZSK**
- Happens periodically for secure root operations

### Security Meaning of the Ceremony
- Root KSK too sensitive for day-to-day use
- So:
  - **KSK signs ZSK**
  - **ZSK signs root zone data**
- This bootstraps trust for:
  - Root
  - TLDs
  - Domains
  - DNS records

### DNSSEC Query Behavior
- Standard DNS query:
  - gets only DNS answers
- DNSSEC query:
  - gets DNS answers **plus**
  - **RRSIG / DNSKEY / DS** as needed
- Example:
  - `dig +dnssec`
- Resolver validates before trusting result

### Attack DNSSEC Helps Prevent
- **DNS cache poisoning**
- Fake resolver/server responses
- Redirecting users to malicious IPs
- Record tampering in transit/cache

### AWS / Route 53 Relevance
- **Amazon Route 53** supports **DNSSEC for hosted zones**
- Exam themes:
  - secure public DNS
  - domain trust validation
  - protecting authoritative records
- Route 53 + DNSSEC = better protection against:
  - spoofing
  - tampering
  - poisoning

### SAP-C02 / SAA Exam Tips
- Know:
  - **RRSIG**
  - **DNSKEY**
  - **DS**
  - **ZSK vs KSK**
  - **trust anchor**
- Memorize:
  - **ZSK signs zone data**
  - **KSK signs DNSKEY**
  - **Parent DS trusts child KSK**
- DNSSEC is about:
  - **authenticity**
  - **integrity**
- Not about:
  - **confidentiality**

### Best Practices
- ✅ Enable DNSSEC for important public zones
- ✅ Protect signing keys securely
- ✅ Separate **KSK** and **ZSK**
- ✅ Rotate keys safely
- ✅ Validate from trusted resolvers
- ✅ Understand root → TLD → domain trust flow