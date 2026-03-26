# Misc stuff

## Table of Contents

- [Misc stuff](#misc-stuff)
  - [Table of Contents](#table-of-contents)
  - [Kubernetes introduction](#kubernetes-introduction)
  - [RPO vs RTO](#rpo-vs-rto)
  - [Cloud Fundamentals](#cloud-fundamentals)

## Kubernetes introduction

### What Kubernetes Is
- ☸️ Open-source **container orchestration**
- Automates:
  - **deployment**
  - **scaling**
  - **healing**
  - **management**
- Runs containers reliably across many hosts
- Cloud-agnostic: on-prem or cloud

### AWS Exam Mapping
- AWS managed Kubernetes = **Amazon EKS**
- Use EKS when you need:
  - Kubernetes ecosystem/tools
  - container orchestration
  - portability / standard K8s APIs
- Compare with:
  - **ECS** = AWS-native orchestration
  - **Fargate** = serverless compute for containers

### Kubernetes Cluster Basics
- **Cluster** = control plane + worker nodes
- **Control plane** = brains / orchestration
- **Nodes** = compute that runs workloads
- Designed for:
  - **HA**
  - **scaling**
  - **self-healing**

### Core Building Blocks
- **Node** = VM/physical worker server
- **Pod** = smallest deployable unit
- **Container** runs **inside a pod**
- Usually:
  - **1 container = 1 pod**
- Think in **pods**, not raw containers

### Pods
- Pods are:
  - **temporary**
  - **replaceable**
  - **non-permanent**
- Pods may be:
  - deleted
  - evicted
  - rescheduled
- ⚠️ Do **not** treat pods as permanent servers

### Control Plane Components
- **kube-apiserver**
  - front door / API for cluster
- **etcd**
  - cluster state database (key-value store)
- **kube-scheduler**
  - places pods onto nodes
- **kube-controller-manager**
  - runs cluster control loops
- **cloud-controller-manager**
  - optional cloud integration (e.g. AWS)

### Scheduler Placement Logic
- Scheduler places pods based on:
  - CPU / memory
  - affinity / anti-affinity
  - locality
  - constraints / policies
- Exam angle:
  - K8s automatically decides **where workloads run**

### Node Components
- **container runtime**
  - e.g. `containerd`
- **kubelet**
  - node agent
  - talks to control plane
- **kube-proxy**
  - pod/service networking
  - traffic routing rules

### Services
- **Service** = stable abstraction in front of pods
- Pods change; **service endpoint stays consistent**
- Services help expose app functionality reliably
- Think:
  - pods are ephemeral
  - services are stable

### Endpoints
- Service maps to one/more pod endpoints
- Controller updates endpoint mappings automatically
- Lets traffic reach healthy pods only

### Jobs
- **Job** = run-to-completion task
- Creates pod(s), retries if needed, then ends
- Good for:
  - batch work
  - one-off processing
  - async background tasks

### Ingress
- **Ingress** = external access into cluster services
- Common for:
  - HTTP / HTTPS routing
  - path/host-based app access
- Flow:
  - User → Ingress → Service → Pod

### Ingress Controller
- Software that implements ingress behavior
- AWS examples:
  - **AWS Load Balancer Controller**
- Can provision:
  - **ALB**
  - **NLB**
- Also common:
  - **NGINX Ingress Controller**

### Stateful vs Stateless (Very Important)
- ✅ Best practice: design pods/apps as **stateless**
- Why:
  - pods are replaceable / movable
- ❌ Don’t store important app state only in pod local storage

### Storage in Kubernetes
- Default pod/node storage = **ephemeral**
- If pod moves or node fails → local data may be lost
- Similar AWS concept:
  - **EC2 instance store**
- For persistent data use:
  - **Persistent Volumes (PV)**

### Persistent Storage
- **PV** = storage lifecycle independent of pod
- Use for:
  - databases
  - uploads
  - durable application state
- Exam angle:
  - ephemeral pod storage ≠ durable app storage

### EKS Architecture Thinking
- In AWS:
  - **EKS** manages Kubernetes control plane
  - You manage or choose worker compute:
    - **EC2**
    - **Fargate**
- Common integrations:
  - **ALB/NLB**
  - **EBS/EFS**
  - **IAM**
  - **CloudWatch**

### SAP-C02 / SAA Exam Tips
- Know:
  - **Pod** = smallest deployable unit
  - **Node** = worker compute
  - **Service** = stable access abstraction
  - **Ingress** = external access
  - **PV** = persistent storage
- Memorize:
  - Pods are **ephemeral**
  - Services are **stable**
  - Stateful workloads need **persistent storage**
- EKS questions often test:
  - architecture fit
  - networking exposure
  - scaling
  - storage persistence
  - managed vs self-managed responsibility

### Best Practices
- ✅ Use **services** instead of pod IPs
- ✅ Keep apps **stateless** where possible
- ✅ Use **PVs** for durable state
- ✅ Use **Ingress + LB** for external access
- ✅ Design for **pod/node replacement**
- ✅ Use **EKS** when you need managed Kubernetes

---
## RPO vs RTO

### RPO
- **Max data loss** ⏪
- Measured in **time**
- Think: **"How much data can we lose?"**
- Worst case = **time between good backups**
- Example: backup every **6h** → RPO = **6h max**

### Lower RPO
- More frequent backups / replication
- Higher cost
- Backup interval **≤ required RPO**

### AWS for RPO
- **AWS Backup**
- **EBS Snapshots**
- **RDS PITR / backups**
- **S3 Versioning**
- **CRR**
- **Multi-AZ / replication**

### RTO
- **Max downtime** ⏱️
- Think: **"How fast must it recover?"**
- Starts at **failure**
- Ends at **restored + tested + handed over**

### RTO Includes
- Detection
- Alerting
- Investigation
- Restore
- Testing / handover

### Lower RTO
- Automation
- Monitoring
- Runbooks
- Trained staff
- Prebuilt failover env

### AWS for RTO
- **EC2 AMIs**
- **CloudFormation**
- **Auto Scaling**
- **ELB**
- **Multi-AZ**
- **Route 53 failover**
- **AWS DRS**
- **Pilot Light / Warm Standby / Multi-Site**

### Exam Triggers
- **Less data loss** → **RPO**
- **Faster recovery** → **RTO**
- **Backups** help **RPO**
- **Failover / replication** help **RTO** (often both)

### Exam Tip
- **Low RPO** = protect **data**
- **Low RTO** = restore **service fast**
- More critical app = **lower RPO/RTO**
- Best answer = **meets business need at lowest cost** ✅

---
## Cloud Fundamentals

### 5 Cloud Characteristics (NIST)
- **On-demand self-service** → provision instantly, no human
- **Broad network access** → standard network/protocols
- **Resource pooling** → multi-tenant, abstracted infra
- **Rapid elasticity** → scale out/in fast
- **Measured service** → metered, pay-per-use 💰

### Exam Triggers
- **Cloud = all 5**
- If manual provisioning / fixed hardware / upfront buying → **not true cloud**
- Key benefits: **agility, elasticity, OpEx, abstraction**

### Public / Private / Multi / Hybrid
- **Public cloud** → AWS / Azure / GCP
- **Private cloud** → cloud on-prem (must still meet all 5)
- **Multi-cloud** → multiple **public** clouds
- **Hybrid cloud** → **private + public cloud**
- **Hybrid environment/network** ≠ hybrid cloud
  - just on-prem connected to AWS

### AWS Examples
- **Public cloud** → AWS
- **Private cloud** → **AWS Outposts**
- Hybrid env clue → **VPN / Direct Connect to on-prem**

### Multi-Cloud Exam Tip
- Use for:
  - vendor resilience
  - regulatory / location needs
- Tradeoff:
  - more complexity
  - less feature depth if abstracted
- Avoid “single pane of glass” trap in questions

### Service Models
- **IaaS** → consume **VM / OS**
- **PaaS** → consume **runtime/platform**
- **SaaS** → consume **application**
- More managed = less control, less ops

### Responsibility by Model
- **On-prem** → you manage **everything**
- **IaaS** → vendor manages infra, **you manage OS+**
- **PaaS** → you manage **app + data**
- **SaaS** → vendor manages **almost all**

### AWS Mapping
- **IaaS** → **EC2**
- **PaaS** → think managed app/runtime services
- **SaaS** → end-user software services
- Also know:
  - **FaaS** → Lambda
  - **DBaaS** → RDS / DynamoDB
  - **CaaS** → ECS / EKS

### Exam Memory Hooks
- **IaaS** = “I manage OS”
- **PaaS** = “I deploy code”
- **SaaS** = “I just use it”
- **FaaS** = “I upload function”

### SAP-C02 Design Mindset
- Prefer **managed services**
- Reduce:
  - ops overhead
  - patching
  - scaling effort
  - infrastructure risk
- Best answer often = **most managed AWS service** ✅