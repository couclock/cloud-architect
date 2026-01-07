
# White papers and architectures

- [White papers and architectures](#white-papers-and-architectures)
  - [AWS Well-Architected Framework](#aws-well-architected-framework)
  - [AWS Trusted Advisor](#aws-trusted-advisor)
  - [AWS Architecture Resources](#aws-architecture-resources)


[AWS Well-architected Framework](https://aws.amazon.com/architecture/well-architected/)

[Disaster Recovery white papers](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-workloads-on-aws.html)

## AWS Well-Architected Framework

### What It Is 🧭

- AWS **best-practice framework + review tool**  
- Helps design **secure, reliable, efficient** workloads

### Core Principles

- Don’t guess capacity → **Auto Scaling**  
- Test at **production scale**  
- **Automate** everything (IaC)  
- Enable **evolutionary architectures**  
- Design with **data-driven decisions**  
- Improve via **game days**

### The 6 Pillars ⭐

- **Operational Excellence**  
- **Security**  
- **Reliability**  
- **Performance Efficiency**  
- **Cost Optimization**  
- **Sustainability**

### Key Concept

- Pillars are **synergistic**, not trade-offs

### Well-Architected Tool 🛠️

- Review workloads against pillars  
- Answer guided questions  
- Get **risk findings & recommendations**  
- Dashboards, reports, improvement plans

### Lenses

- Well-Architected (default)  
- Serverless  
- SaaS  
- FTR  
- Custom lenses

### Exam Tips 🧠

- Know the **6 pillar names**  
- Tool = architecture **assessment & guidance**  
- Used to identify **high-risk issues**

---
## AWS Trusted Advisor

### What It Is 🔍

- **Account assessment service**  
- No setup required  
- Provides **best-practice recommendations**

### Check Categories ⭐

- **Cost Optimization**  
- **Performance**  
- **Security**  
- **Fault Tolerance**  
- **Service Limits**  
- **Operational Excellence**

### Core vs Full Checks

- **Core checks**: available to all accounts  
- **Full checks**: require **Business or Enterprise Support**

### Common Checks

- Public **S3 / EBS / RDS snapshots**  
- Open **security group ports**  
- Root account usage  
- Service limits monitoring

### Support Plan Benefits 🧠

- Business / Enterprise:  
  - Full Trusted Advisor checks  
  - **AWS Support API** (programmatic access)

### Exam Tips ⭐

- Trusted Advisor = **high-level account review**  
- Focus on **security & cost optimization**  
- Full features require **paid support plans**

---
## AWS Architecture Resources

### Why It Matters 🏗️

- Real **solution architectures** = key SAA skill  
- Covers classic + serverless designs

### AWS Architecture Center 📐

[https://aws.amazon.com/architecture/](https://aws.amazon.com/architecture/) 

- **2,000+ reference architectures**  
- Diagrams + deep explanations  
- Use cases: DR, WordPress, databases, etc.  
- Formats: **PDF / HTML**  
- Includes best practices & templates

### AWS Solutions Library 🧩

[https://aws.amazon.com/solutions/](https://aws.amazon.com/solutions/)

- **Production-ready AWS solutions**  
- Vetted architectures for business & technical use cases  
- Includes:  
  - Architecture diagrams  
  - **CloudFormation templates**  
  - Implementation guides  
  - GitHub source code

### Browsing Options

- By industry  
- By technology (e.g. serverless)  
- By organization type

### Exam Tips 🧠

- Architecture Center = **reference designs**  
- Solutions Library = **deployable solutions**  
- Know where to find **official AWS architectures**