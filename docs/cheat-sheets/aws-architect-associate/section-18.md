
# IAM Advanced

- [IAM Advanced](#iam-advanced)
  - [AWS Organizations](#aws-organizations)
  - [IAM Conditions](#iam-conditions)
  - [IAM Roles vs Resource-Based Policies](#iam-roles-vs-resource-based-policies)
  - [IAM Permission Boundaries](#iam-permission-boundaries)
  - [AWS IAM Identity Center (SSO)](#aws-iam-identity-center-sso)
  - [AWS Directory Services \& Microsoft AD](#aws-directory-services--microsoft-ad)
  - [AWS Service Catalog](#aws-service-catalog)
  - [AWS Control Tower](#aws-control-tower)
  - [AWS Resource Access Manager (RAM)](#aws-resource-access-manager-ram)

## AWS Organizations

### 🌍 Basics
- Global, multi-account management
- **Management Account** + **Member Accounts**
- Account = member of **one org only**

### 💰 Billing
- Consolidated billing
- Usage aggregated → discounts
- RI & Savings Plans shared 💸

### 🗂️ OUs
- Root → nested OUs
- Organize by **env / BU / project**
- Keep management acct in Root (best practice)

### 🔐 Governance
- Strong isolation (accounts > VPCs)
- Central CloudTrail & CloudWatch logs
- Cross-account admin roles

### 🚫 SCP (Key Exam Topic)
- Org-level **permission guardrails**
- Apply to OUs / accounts
- **Never affect management account**
- Explicit **Allow needed**
- Explicit **Deny always wins** ❌
- Inherited Root → OU → Account

### 🏷️ Tag Policies
- Enforce tag keys & values
- Cost allocation + ABAC
- Find non-compliance (EventBridge)

### ⭐ Exam Tips
- SCPs restrict, IAM grants
- No SCP allow = no access
- Use Organizations for security + billing

---
## IAM Conditions

### 🔐 Basics
- Used in **IAM policies**, **resource policies**, **SCPs**, **endpoint policies**
- Add fine-grained access control via `Condition`

### 🌐 Network & Location
- **aws:SourceIP**  
  - Restrict API calls by CIDR  
  - Common: allow only corporate network
- **aws:RequestedRegion**  
  - Allow/Deny services in specific regions  
  - Often used in **SCPs**

### 🏷️ Tag-Based Access (ABAC)
- **ec2:ResourceTag/**key  
  - Control actions based on EC2 tags
- **aws:PrincipalTag/**key  
  - Control access based on user/role tags
- Resource tag + Principal tag = ABAC pattern

### 🔑 Authentication
- **aws:MultiFactorAuthPresent**  
  - Enforce MFA for sensitive actions
  - Common deny if `false`

### 🪣 S3 Policy Gotchas
- **ListBucket** → bucket ARN  
  - `arn:aws:s3:::bucket`
- **Get/Put/DeleteObject** → object ARN  
  - `arn:aws:s3:::bucket/*`

### 🏢 Organizations
- **aws:PrincipalOrgID**  
  - Restrict resource access to org members only
  - Common in S3 bucket policies

### ⭐ Exam Tips
- Conditions = **extra security layer**
- Region restriction → `aws:RequestedRegion`
- Corporate IP restriction → `aws:SourceIP`
- Org-only access → `aws:PrincipalOrgID`
- ABAC = tags + conditions

---
## IAM Roles vs Resource-Based Policies

### 🔄 Cross-Account Access
Two valid models:
- **Assume IAM Role**
- **Resource-Based Policy** (e.g., S3 bucket policy)

### 🎭 IAM Roles
- Principal **assumes role**
- Original permissions ❌ dropped
- Role permissions ✅ gained
- Best when full context switch is OK

### 🪣 Resource-Based Policies
- Attached to the **resource**
- Principal keeps original permissions ✅
- Ideal for multi-resource workflows

### 🧠 Key Use Case (Exam Favorite)
- Read DynamoDB (Acct A)  
- Write S3 (Acct B)  
➡️ **Use resource-based policy** (no role switch)

### 📦 Services Supporting Resource Policies
- S3 🪣
- SNS
- SQS
- Lambda
- API Gateway

### ⚡ EventBridge Integration
- **Resource-based policy targets**:
  - Lambda, SNS, SQS, S3, API Gateway
- **IAM role targets**:
  - Kinesis Data Streams*
  - EC2 Auto Scaling
  - ECS tasks
  - SSM Run Command
- \*Kinesis supports resource policies, but **EventBridge uses IAM role**

### ⭐ Exam Tips
- Role = lose old perms, gain new
- Resource policy = keep existing perms
- EventBridge choice depends on target type
- Prefer resource-based policy when possible

---
## IAM Permission Boundaries

### 🔒 What They Are
- Define **max permissions** an IAM user/role can have
- Apply to **users & roles only** (❌ not groups)
- Look like IAM policies

### ⚙️ How They Work
- **Effective permissions = IAM policy ∩ Permission Boundary**
- Outside boundary = **implicitly denied**
- Boundary always restricts, never grants

### 🧠 Key Example
- Policy: `AdministratorAccess`
- Boundary: `AmazonS3FullAccess`
➡️ User can **only access S3**

### 🏗️ Common Use Cases
- Delegate admin tasks safely
- Prevent privilege escalation
- Restrict one user (vs org-wide SCP)

### 🧩 Works With
- **Organizations SCP** (account-level)
- **Identity policies** (user/role)
- Final access = intersection of all

### 🔍 IAM Policy Evaluation Order (Simplified)
1. Explicit **Deny** ❌ (always wins)
2. Organizations **SCP**
3. Resource-based policy
4. Identity-based policy
5. **Permission Boundary**
6. Session policy

### ❗ Deny Rules (Exam Critical)
- Explicit Deny > Allow
- No Allow = Implicit Deny
- Deny cannot be overridden

### ⭐ Exam Tips
- Boundaries = “guardrails for IAM users”
- Use when SCP is too broad
- Admin policy ≠ admin access (boundary may limit)

---
## AWS IAM Identity Center (SSO)

### 🔑 What It Is
- Successor to **AWS SSO**
- **One login** for:
  - Multiple AWS accounts (Organizations)
  - Business apps (SAML 2.0)
  - Windows EC2 instances
- **Very common exam topic**

### 👤 Identity Sources
- Built-in Identity Store
- External IdP:
  - Active Directory (on-prem / cloud)
  - Okta, OneLogin, etc.

### 🔐 How Access Works
- Users sign in once → SSO portal
- Choose AWS account / app
- No separate console logins

### 🧩 Permission Sets (Key Concept)
- Collection of IAM policies
- Assigned to:
  - Users or Groups
  - Specific AWS accounts
- Automatically creates IAM roles per account

### 🏗️ Multi-Account Access
- Same permission set → many accounts
- Example:
  - **Admin** on Dev accounts
  - **ReadOnly** on Prod accounts

### 📦 Supported Access
- AWS accounts
- Business SaaS apps
- Custom SAML 2.0 apps

### 🏷️ ABAC (Advanced)
- Use user attributes (tags)
- Control access by:
  - Department
  - Cost center
  - Region
- Change attributes → permissions update automatically

### ⭐ Exam Tips
- “One login to many AWS accounts” → **IAM Identity Center**
- Permissions = **Permission Sets**
- Works only with **AWS Organizations**
- Users assume roles automatically

---
## AWS Directory Services & Microsoft AD

### 🪟 Microsoft Active Directory (AD)
- Central user & resource directory
- Users, groups, computers, printers
- Domain → Tree → Forest
- Used for Windows authentication

### ☁️ AWS Directory Services (3 Types)

#### 1️⃣ AWS Managed Microsoft AD ⭐
- Full **Microsoft AD** in AWS
- Manage users in AWS
- Supports **MFA**
- **Two-way trust** with on-prem AD
- Best for hybrid setups

#### 2️⃣ AD Connector
- **Proxy** to on-prem AD
- No users stored in AWS
- Supports MFA
- Users managed **only on-prem**
- Best for simple authentication

#### 3️⃣ Simple AD
- AD-compatible (not Microsoft AD)
- Standalone, **no on-prem trust**
- No MFA
- Best when **no existing AD**

### 🖥️ Common Use Case
- Windows EC2 instances join domain
- Centralized login & credentials

### 🔐 IAM Identity Center Integration
- With AWS Managed AD → native integration
- With on-prem AD:
  - Option 1: Managed AD + trust
  - Option 2: AD Connector (proxy)

### ⭐ Exam Decision Guide
- Hybrid AD + MFA → **AWS Managed Microsoft AD**
- On-prem only, proxy auth → **AD Connector**
- No AD at all → **Simple AD**

---
## AWS Service Catalog

### 🧠 Overview
- Centralized **catalog of approved AWS resources**
- Enables **self-service provisioning**
- Enforces governance & compliance

### 🧩 Core Concepts
- **Product**: CloudFormation template ⭐
- **Portfolio**: group of products
- **Versioning**: multiple product versions
- **Constraints**: rules applied to products

### 🔐 Access Control
- **IAM roles & users**
- Share portfolios **across accounts**
- Integrates with **AWS Organizations**

### ⚙️ Constraints (Key Types)
- **Launch constraint** ⭐ (IAM role)
- **Template constraint**
- **Tag update constraint**
- **Notification constraint**

### 🏗️ Common Use Cases
- Standardized EC2, RDS, VPC provisioning
- Controlled self-service for dev teams
- Multi-account governance

### 🆚 Service Catalog vs CloudFormation
- CFN → free-form templates
- Service Catalog → **approved, controlled CFN**

### 🎯 When to Use
- Need **governance + self-service**
- Large teams / enterprises
- Reduce misconfigurations

### 🧪 Exam Tips ⭐
- Service Catalog uses **CloudFormation**
- Products ≠ resources
- Launch constraint = execution role
- Ideal for **standardization**

---
## AWS Control Tower

### 🧠 Overview
- **Landing zone** for multi-account AWS
- Automated **account governance**
- Built on **AWS Organizations**, **AWS Service Catalog** and **AWS IAM Identity Center**

### 🧩 Core Concepts
- **Landing Zone** ⭐
- **Accounts**: management, log archive, audit
- **OUs** (Organizational Units)
- **Account Factory** (account provisioning)

### 🔐 Guardrails
- **Preventive** (SCPs) ⭐
- **Detective** (AWS Config rules)
- Enforce security & compliance

### 📜 Logging & Audit
- Centralized logs
- **CloudTrail**
- **AWS Config**
- Stored in log archive account

### 🏗️ Common Use Cases
- Secure multi-account setup
- Enterprise governance
- Rapid account creation

### 🆚 Control Tower vs Organizations
- Orgs → structure only
- Control Tower → **structure + governance**

### 🎯 When to Use
- New multi-account environments
- Strong security baseline
- Limited manual setup

### 🧪 Exam Tips ⭐
- Control Tower uses **Organizations + SCPs**
- Guardrails ≠ IAM policies
- Account Factory = standardized accounts
- Best for **enterprise-scale AWS**

---
## AWS Resource Access Manager (RAM)

### 🧠 Overview
- Share AWS resources **across accounts**
- Avoid duplication
- Works with **AWS Organizations**

### 🔗 Shareable Resources
- **VPC subnets** ⭐
- **Transit Gateway**
- **Route 53 Resolver rules**
- **License Manager configs**
- **Outposts resources**
- Service-dependent support

### 🧩 Core Concepts
- **Resource share**
- **Owner account** vs **consumer account**
- Same-region only (most cases)

### 🏢 Organizations
- Org-based sharing = **no acceptance required**
- External accounts = **invite + accept**
- Centralized network architectures

### 🔐 Security
- IAM permissions required
- No resource ownership transfer
- Consumer account = limited actions

### 🏗️ Common Use Cases
- **Shared VPC** ⭐
- Hub-and-spoke networking
- Centralized services (DNS, TGW)

### 🆚 RAM vs VPC Peering
- RAM shares **subnets**
- Peering connects **VPCs**
- RAM scales better for orgs

### 🧪 Exam Tips ⭐
- RAM ≠ cross-region replication
- RAM ≠ data sharing
- Use RAM for **multi-account networking**
- Shared subnets stay in owner account
