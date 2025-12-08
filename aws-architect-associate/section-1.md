# AWS Fundamentals & IAM

Prompt to use:
Please summarize the following transcript into a very compact AWS Solutions Architect Associate (SAA) revision cheat sheet.
Format it in raw Markdown (inside a code block), with no separators.
Use short bullet points, minimal wording, and highlight only SAA-relevant concepts, AWS services, rules, exam tips, and best practices.
Use simple icons to make key concepts easier to scan and memorize when relevant, do not use too many.
Keep it extremely concise and easy to memorize. Here's the transcript:

## Regions, AZs and Edge locations

**Global Infrastructure**
- **Regions:** clusters of AZs, named (e.g., US-east-1, EU-west-3)  
- **Availability Zones (AZs):** 3–6 per region, isolated, redundant power/network  
- **Edge Locations / Points of Presence:** 400+ globally in 90+ cities over 40+ countries, low-latency content delivery  

**Region Selection Factors**
- Compliance (data residency)  
- Latency (close to users)  
- Service availability (not all regions have all services)  
- Pricing (varies per region)  

**Global vs Regional Services**
- **Global:** IAM, Route 53, CloudFront, WAF  
- **Regional:** EC2, Elastic Beanstalk, Lambda, Rekognition  
- Check region table for service availability  

## 🔐 IAM – Identity & Access Management

### 📌 Key Concepts

- Global service

**IAM Overview**
- 👤 **Users:** map to real people, each with console password  
- 👥 **Groups:** assign permissions collectively via policies  
- 🎭 **Roles:** for AWS services (EC2, Lambda), not humans  
- 🔑 **Access Keys:** for CLI/SDK access, keep secret  
- 🔒 **Security:** enable MFA, enforce strong password policy  

**Management Tools**
- CLI: manage AWS via commands  
- SDK: manage AWS programmatically  
- Credentials Report: audit user accounts  
- Access Advisor: review user permissions  

**Best Practices**
- 🚫 Avoid using root account except at setup  
- One user = one physical person  
- Assign permissions at group level where possible  
- Always enforce MFA and strong passwords  
- Use roles for services, not sharing your access keys  
- Audit regularly with credentials report & Access Advisor  

### IAM Password Policy & MFA

**IAM Password Policy**
- Minimum length, required character types  
- Allow/deny user password changes  
- Force rotation (e.g., 90 days)  
- Prevent password reuse  
- Mitigates brute-force attacks  

**MFA Basics**
- Password + device = stronger authentication  
- Mandatory for root, recommended for all IAM users  
- Protects even if password is stolen  

**MFA Device Types**
- Virtual: Google Authenticator, Authy (multi-token)  
- U2F security key: YubiKey (physical, 3rd party)  
- Hardware key fob: Gemalto  
- GovCloud key fob: SurePassID  

### AWS Access Key, CLI & SDK

**AWS Access Methods**
- Console: web UI, uses username/password + MFA  
- CLI: local tool, uses access keys (ID + secret)  
- SDK: code libraries to call AWS APIs programmatically  

**Access Keys**
- Generated in IAM console by each user (personal)  
- Secret Access Key = password → never share  
- Required for CLI and SDK authentication  

**CLI (Command Line Interface)**
- Interact with AWS via commands (`aws s3 cp ...`)  
- Calls AWS public APIs directly  
- Enables automation/scripts  
- Open-source on GitHub  
- Alternative to console  

**SDK (Software Development Kit)**
- Used inside applications, not terminal  
- Language-specific libraries: Python (Boto3), JS, Java, Go, .NET, Ruby, C++, Node.js  
- Also mobile SDK (iOS/Android) & IoT SDK  
- CLI itself is built on Boto3 (Python SDK)  

**SAA Exam Tips**
- Console = human use; CLI/SDK = programmatic access  
- Access keys must be protected and NOT shared  
- CLI & SDK both authenticate using the same access keys  

### CloudShell

**CloudShell Basics**
- Browser-based AWS-managed terminal  
- Free to use  
- AWS CLI pre-installed (v2)  
- Uses your console credentials (no local access keys needed)  
- Default region = region of CloudShell session  

**Region Availability**
- Not available in all regions  
- Must switch to a supported region to use it  

**Features**
- Persistent storage for created files  
- Upload/download files directly from the UI  
- Customizable (font size, theme, tabs, split view)  

**Usage**
- Run AWS CLI commands directly (`aws iam list-users`, etc.)  
- Behaves like local CLI but hosted in AWS  
- Good alternative when local terminal setup is not needed  

**SAA Exam Tips**
- CloudShell = no need to manage local credentials  
- Region availability matters  
- Persistent file storage inside CloudShell environment  

### IAM Roles

**IAM Roles**
- 👤 Like users, but for AWS services, not people  
- Assign permissions to AWS entities (EC2, Lambda, CloudFormation, etc.)  
- Roles are assumed by services to perform actions on your account  

**Creating a Role**
- Choose **AWS service** (e.g., EC2)  
- Attach **policies** (e.g., IAM read-only)  
- Name the role and define **trusted entities** (which service can assume it)  
- Verify permissions  

**SAA Exam Tips**
- Roles enable **secure, service-based access**  
- Common roles: EC2 Instance Role, Lambda Function Role  
- Policies define **what the service can do**  

### IAM Security Tools

- 📄 **Credentials Report:** account-level CSV of all users  
  - Shows: creation date, password status, rotation, MFA, access keys  
  - Helps identify unused or outdated credentials  
- 🔍 **Access Advisor:** user-level tool  
  - Shows service permissions & last accessed date  
  - Helps enforce **least privilege**  

**SAA Exam Tips**
- Use credentials report to monitor user security  
- Use Access Advisor to remove unused permissions  
- Principle: give users only permissions they need  

### 🧠 Important Notes

- Always use **least privilege principle**
- Never use root user for daily tasks
- Use **MFA** everywhere
    - MFA: password you know + device you own
    - Virtual MFA device: Google auth / Authy
    - Universal 2nd Facto (U2F): Yubikey by yubiko (USB stick)
    - Hardware Key fob MFA Device: Gemalto (physical code generator)
    - Hardware Key fob MFA Device for AWS GovCloud: SurePassID (physical code generator)
- Roles are used instead of access keys on EC2

### 📝 Example policies ideas / exam concepts

- Inline vs Managed policies
- Trust policy vs permissions policy
- Instance role vs access key
- Temporary creds via STS
- Password policy: length, characters, rotation, allow update by users on their own, prevent re use

---

### ❓Common Exam Questions

| Question topic | Answer |
|------|------|
| How should EC2 access S3 securely? | Using IAM Role |
| Best practice for admin user? | No root – use IAM + MFA |
| Temporary access? | STS, AssumeRole |

---
