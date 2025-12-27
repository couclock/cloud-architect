# Containers: ECS, Fargate, ECR & EKS

Prompt to use:

Please summarize the following transcript into a very compact AWS Solutions Architect Associate (SAA) revision cheat sheet using markdown format in a code block. 
- Include a second-level Markdown title as the cheat sheet title (##). 
- In your markdown: no separators. 
- Use 3rd level titles (###), short bullet points, minimal wording, and highlight only SAA-relevant concepts, AWS services, rules, exam tips, and best practices. 
- Use simple icons when relevant, but keep them limited. 
- Keep the cheat sheet extremely concise and easy to memorize. 
Here’s the transcript:

## Amazon ECS

## Amazon ECS – SAA Revision Cheat Sheet

### ECS Basics
- 🐳 ECS = Elastic Container Service
- Containers run as **ECS Tasks** inside an **ECS Cluster**
- Defined via **Task Definitions** (CPU, RAM, IAM role, image)

### Launch Types
- **EC2 Launch Type**
  - You provision & manage EC2 instances
  - EC2 instances must run **ECS Agent**
  - You manage scaling, patching, capacity
- **Fargate Launch Type** ⭐
  - Serverless (no EC2 management)
  - AWS manages infrastructure
  - Scale by increasing task count
  - Exam favorite → simpler & managed

### IAM Roles
- **EC2 Instance Profile** (EC2 launch only)
  - Used by ECS Agent
  - Pull images from ECR
  - Send logs to CloudWatch
  - Access SSM / Secrets Manager
- **ECS Task Role** ⭐
  - Used by containers themselves
  - Defined in task definition
  - Fine-grained permissions per task
  - Works for EC2 + Fargate

### Load Balancer Integration
- **Application Load Balancer (ALB)** ⭐
  - HTTP/HTTPS
  - Works with EC2 & Fargate
  - Most common choice
- **Network Load Balancer (NLB)**
  - High throughput / low latency
  - Needed for PrivateLink
- **Classic Load Balancer**
  - Legacy, not recommended
  - ❌ Not supported with Fargate

### Persistent Storage
- Containers are ephemeral by default
- **Amazon EFS** ⭐
  - Shared, persistent storage
  - Works with EC2 & Fargate
  - Multi-AZ access
  - Ideal for shared state/data
- Best combo: **Fargate + EFS**
  - Fully serverless
  - Pay-as-you-go
  - Multi-AZ shared filesystem

### Exam Tips
- Prefer **Fargate** unless EC2 control is required
- Use **Task Roles**, not EC2 roles, for app permissions
- Use **ALB** for ECS web apps
- Use **EFS** for persistent/shared container storage

---
## ECS Hands-On

### Cluster Creation
- Enable **New ECS Experience**
- Create **Cluster**: name, namespace
- **Infrastructure options**
  - **Fargate**: serverless, AWS manages compute
  - **EC2**: self-managed instances
  - **ECS Anywhere**: on-premises/external instances
- **EC2 setup**: ASG, OS (Amazon Linux 2/2023), instance type, capacity, VPC, subnets, SG, public IP
- ECS Cluster auto-creates **Auto Scaling Group** for EC2 capacity

### Capacity Providers
- **FARGATE**: serverless tasks
- **FARGATE_SPOT**: cheaper, spot-based tasks
- **ASGProvider**: EC2 instances via ASG
- Tasks can run on any provider depending on strategy

### Task Definitions
- Define container: name, image, ports
- Assign **Task Role** for AWS API access
- Specify **compute requirements** (vCPU, memory)
- **Task Execution Role**: auto-created if missing
- Ephemeral storage by default (Fargate)

### Services
- Create **ECS Service**:
  - Link task definition
  - Select **capacity provider** (Fargate or EC2)
  - Deployment type: **replica**, number of tasks
  - AZ rebalancing: optional
- Networking: subnets, SG, public IP
- Load Balancing: **ALB + target group**, map container port to LB
- Service manages task lifecycle (start/stop/scale)

### Scaling
- Increase **desired task count** → ECS auto-provisions resources (Fargate) or uses EC2 capacity
- Decrease to zero → stops containers, keeps service
- Load balancer distributes traffic across tasks

### Exam Tips
- **Fargate** = default for simplicity & serverless
- **ALB** required for HTTP/HTTPS access
- **Task Role** for AWS API permissions
- Multi-AZ support via Fargate or EC2 ASG
- Easy scaling up/down via service updates

---
## ECS Service Auto Scaling & Architectures – SAA Revision Cheat Sheet

### Service Auto Scaling
- Use **AWS Application Auto Scaling**
- Scale ECS tasks on:
  - CPU Utilization
  - Memory Utilization
  - ALB Request Count per Target
- Scaling types:
  - **Target Tracking** (preferred)
  - Step Scaling
  - Scheduled Scaling
- **Fargate** = easiest, fully serverless
- **EC2 Launch Type**:
  - Scale EC2 via **ASG Scaling** or **ECS Cluster Capacity Provider** ⭐
  - Capacity Provider = smarter, auto-scales ASG when tasks need CPU/RAM

### Scaling Workflow
- CloudWatch monitors service metrics → triggers alarm → scales ECS tasks
- For EC2, Capacity Provider adjusts underlying EC2 instances automatically
- ECS Service scaling ≠ ECS Cluster scaling (task vs instance level)

### Serverless Architectures
- **Event-Driven ECS Tasks**
  - **EventBridge + S3** → ECS tasks process objects → write results to DynamoDB
  - **EventBridge Schedule** → periodic ECS tasks (batch jobs)
  - **SQS Queue** → ECS service pulls messages → auto-scale tasks based on queue depth
- **EventBridge Task State Events**
  - Monitor ECS lifecycle events (start/stop)
  - Trigger notifications via **SNS** or automate actions

### Exam Tips
- Prefer **Fargate** for auto-scaling simplicity
- Always define **ECS Task Roles** for AWS API access
- Auto Scaling metrics = CPU, memory, ALB request count
- Use **Capacity Providers** for EC2-backed clusters
- EventBridge + ECS → serverless event-driven architectures

---
## Amazon ECR – SAA Revision Cheat Sheet

### ECR Basics
- **ECR = Elastic Container Registry**
- Store & manage Docker images on AWS
- Fully integrated with **ECS**
- Images stored in **S3** behind the scenes

### Repository Types
- **Private**: account-only access
- **Public**: Amazon ECR Public Gallery

### Access & Permissions
- Pull images via **IAM roles**
- Assign role to **EC2 instance or Fargate task**
- IAM controls all access → check policies if pull fails

### Features
- Image **versioning** & **tags**
- **Vulnerability scanning**
- **Lifecycle policies** to manage old images

### Exam Tips
- Think **ECR = storing Docker images**
- Always consider **IAM role permissions** for ECS/ECR
- Public vs private repository = account access

---
## Amazon EKS – SAA Revision Cheat Sheet

### EKS Basics
- **EKS = Elastic Kubernetes Service**
- Runs **Kubernetes clusters** on AWS
- Alternative to ECS, open-source, cloud-agnostic
- Supports **EC2 worker nodes** or **Fargate serverless pods**
- **Pods = container units** in Kubernetes (like ECS tasks)
- Nodes can be **managed or self-managed**, supports On-Demand & Spot

### Node Management
- **Managed Node Groups**: AWS creates & manages EC2 nodes, auto-scaling built-in
- **Self-Managed Nodes**: you create EC2 instances & register to EKS cluster, manage ASG
- **Fargate Profiles**: no nodes, fully serverless

### Networking & Access
- Deploy in **VPC**, multiple AZs, public/private subnets
- Control **cluster API access** (public/private)
- Security Groups apply to nodes & pods
- Use **IAM roles**:
  - **EKS Cluster Role**: manages cluster operations
  - **EKS Node Role**: worker node permissions + ECR access

### Storage
- Persistent volumes via **StorageClass + CSI drivers**
- Supports: **EBS**, **EFS** (Fargate only), **FSx Lustre**, **FSx NetApp ONTAP**
- Attach to pods via Kubernetes manifests

### Exam Tips
- **EKS = Kubernetes on AWS**
- Pods = ECS tasks equivalence
- Node types: Managed, Self-Managed, Fargate
- Use **Fargate** for serverless workloads
- Storage requires **CSI drivers** for EBS/EFS/FSx
- IAM roles needed for cluster & node operations

---
## AWS App Runner

### App Runner Basics
- Fully managed **web app & API deployment**
- Input: **Source code** (GitHub) or **Docker image** (ECR / ECR Public)
- No infrastructure management required
- Auto-provisions: containers, **load balancer**, scaling, domain

### Key Features
- **Auto Scaling**: min → max instances, concurrent request limits
- **vCPU & memory** configuration per service
- **Health checks** built-in
- **Security & VPC access** optional
- Observability: logs, metrics, tracing (AWS X-Ray)
- Public domain access by default, can use **custom domain**

### Use Cases
- Quick deployment of **web apps**, **APIs**, **microservices**
- Serverless container hosting with **production best practices**
- Supports container images from **ECR / Public ECR** or code repo

### Exam Tips
- Think: **App Runner = easiest way to run containers & APIs** without managing servers
- Built-in **load balancing, scaling, high availability**
- Can integrate with VPC to access databases, caches, message queues
- Manual vs automatic deployment options

---
## AWS App2Container (A2C)

### A2C Basics
- **CLI tool** to migrate & modernize Java/.NET web apps
- Lift-and-shift **legacy apps → Docker containers**
- No code changes required
- Generates **CloudFormation templates** for compute, network, and ECS/EKS/App Runner deployment

### Workflow
1. **Discover & analyze** apps for migration
2. **Containerize** applications
3. Generate **deployment artifacts**:
   - ECS Task / EKS Pod definitions
   - CI/CD pipelines (optional)
   - Infrastructure templates
4. **Store Docker images** in **ECR**
5. Deploy to **ECS, EKS, or App Runner**

### Exam Tips
- Think: **A2C = lift-and-shift migration to AWS containers**
- Supports **Java & .NET web applications**
- Works with **ECR + ECS/EKS/App Runner**
- Simplifies modernization without changing code
