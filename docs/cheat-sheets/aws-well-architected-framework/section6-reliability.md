# 📘 Reliability Pillar

---

## 1️⃣ What is the Reliability Pillar?

**Reliability** = The ability of a workload to perform its required function  
**correctly and consistently over time**, including during failures and changes.

Includes:
- Handling failures
- Automatic recovery
- Scaling with demand
- Meeting RTO & RPO
- Operating across the full lifecycle

Within AWS Well-Architected Framework, Reliability is one of six pillars.

---

# 🧠 Reliability Design Principles (Exam Critical)

### 1. Automatically recover from failure
- Monitor business KPIs (not just CPU)
- Trigger automation on threshold breach
- Replace/restart unhealthy resources
- Anticipate failures proactively

---

### 2. Test recovery procedures
- Simulate failures (chaos engineering)
- Validate failover
- Reduce real-world risk

---

### 3. Scale horizontally
- Replace 1 large resource with many small ones
- Remove single points of failure
- Distribute load across instances/AZs

---

### 4. Stop guessing capacity
- Monitor demand
- Use Auto Scaling
- Avoid over/under-provisioning
- Manage quotas

---

### 5. Manage change through automation
- Infrastructure as Code (IaC)
- Automated deployments
- Version control everything

---

# 🏗 Reliability Best Practice Areas

1. Foundations  
2. Workload Architecture  
3. Change Management  
4. Failure Management  

---

# 1️⃣ Foundations

## ✔ Manage Service Quotas & Constraints

- Quotas exist per account (usually per Region)
- Protect services from abuse

Best practices:
- Track quotas in ALL environments (prod + non-prod)
- Request increases early
- Monitor usage
- Keep headroom for failover
- Automate quota management

⚠ During failover, failed resources may still count toward quotas.

---

## ✔ Plan Network Topology

Plan for:
- Multi-AZ architecture
- Multi-Region (if required)
- Non-overlapping IP ranges
- Subnet expansion
- Public/private connectivity

Prefer:
- Hub-and-spoke over mesh
- Redundant connectivity
- Highly available DNS and load balancing

---

# 2️⃣ Workload Architecture

## ✔ Design Service Architecture

Avoid monoliths.

Use:
- Service-Oriented Architecture (SOA)
- Microservices

Principles:
- Stateless services
- Domain-focused services
- API contracts
- Versioning

Benefits:
- Independent scaling
- Failure isolation
- Faster recovery

---

## ✔ Prevent Failures in Distributed Systems

Distributed systems fail due to:
- Latency
- Packet loss
- Overload

Best practices:

### • Loose coupling
Use queues, streaming, workflows

### • Idempotency
Same request → same result  
Use idempotency tokens

### • Constant work
Avoid sudden spikes in system behavior

### • Identify system type
- Hard real-time
- Soft real-time
- Offline/batch

---

## ✔ Mitigate / Withstand Failures (Improve MTTR)

Patterns:
- Graceful degradation
- Throttling
- Exponential backoff + jitter
- Limit retries
- Fail fast
- Control queue length
- Proper client timeouts
- Stateless services
- Emergency levers

---

# 3️⃣ Change Management

Changes include:
- Traffic spikes
- Deployments
- Patches
- Infrastructure updates

---

## ✔ Monitor Workload Resources

Monitor:
- Metrics
- Logs
- Traces
- Business KPIs

Best practices:
- Monitor ALL components
- Automate remediation
- Analyze trends
- Review monitoring regularly

---

## ✔ Design for Demand Changes

Elastic workloads:
- Scale automatically
- Replace impaired resources
- Reactive scaling (restore availability)
- Proactive scaling (avoid impact)
- Load testing

---

## ✔ Implement Change Safely

- Use runbooks
- Automate deployments
- Functional testing in pipeline
- Resiliency testing (chaos)
- Immutable infrastructure
- Game days

---

# 4️⃣ Failure Management

Cloud reduces hardware failure risk  
But resilience must be architected.

---

## ✔ Backup Strategy

Back up:
- Data
- Applications
- Configuration

Meet:
- RTO → Max acceptable downtime
- RPO → Max acceptable data loss

Best practices:
- Encrypt backups
- Automate backups
- Periodic restore tests
- Validate RTO/RPO compliance

---

## ✔ Fault Isolation (Limit Blast Radius)

Deploy across:
- Multiple Availability Zones
- Multiple Regions (if needed)

Patterns:
- Bulkheads (cells/partitions)
- Multi-AZ deployments
- Automated rebuild capability

---

## ✔ Withstand Component Failures

- Continuous monitoring
- Automatic failover
- Automated healing
- Prefer data plane over control plane
- Static stability (avoid bimodal behavior)

Example:
Pre-provision capacity in each AZ  
Shift traffic via load balancing + health checks

---

## ✔ Test Reliability

Testing is mandatory.

Test types:
- Unit tests
- Integration tests
- Load tests
- Chaos engineering
- Game days

Also:
- Use playbooks
- Perform post-incident analysis
- Improve continuously

---

# 🚨 Disaster Recovery (DR)

Availability ≠ Disaster Recovery

Availability:
- Component-level resilience

Disaster Recovery:
- Entire workload recovery

---

## Recovery Objectives

RTO → Maximum acceptable downtime  
RPO → Maximum acceptable data loss  

---

## DR Strategies (Least → Most expensive)

1. Backup & Restore
2. Pilot Light
3. Warm Standby
4. Active-Active (Multi-Region)

Best practices:
- Regular failover testing
- Manage configuration drift
- Automate traffic routing
- Keep quotas updated in DR Region

---

# 📊 Key Metrics

MTBF → Mean Time Between Failures  
MTTR → Mean Time To Recovery  
RTO → Recovery Time Objective  
RPO → Recovery Point Objective  

---

# 🎯 Mental Model for Exam

Reliability =

Design for failure  
+ Automate recovery  
+ Isolate blast radius  
+ Test continuously  
+ Monitor business KPIs  
+ Plan disaster recovery  
