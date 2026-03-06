# 📘 Deep Dive on the Security Pillar

---

# 1️⃣ Learning Objectives

In this module, you learn:

- What the **Security Pillar** is
- The **Security design principles**
- The **7 best practice areas**
- How to operate workloads securely on AWS
- How to prepare for and respond to security events

---

# 3️⃣ What Is the Security Pillar?

The **Security Pillar** focuses on:

> Protecting data, systems, and assets in the cloud while enabling business value.

To operate securely in the cloud:
- Apply security best practices across all layers
- Align to governance and compliance requirements
- Automate controls wherever possible
- Continuously improve your security posture

---

# 4️⃣ Security Design Principles (7)

---

## 1️⃣ Implement a Strong Identity Foundation

- Apply **least privilege**
- Enforce separation of duties
- Centralize identity management
- Eliminate long-term static credentials
- Prefer temporary credentials

---

## 2️⃣ Enable Traceability

- Monitor actions in real time
- Log changes and access
- Alert on suspicious activity
- Integrate logs with automated investigation systems

---

## 3️⃣ Apply Security at All Layers (Defense in Depth)

Secure:
- Network edge
- VPC
- Load balancers
- Compute
- Operating systems
- Applications
- Code

Adopt **Zero Trust** principles.

---

## 4️⃣ Automate Security Best Practices

- Manage security controls as code
- Use version-controlled templates
- Automate enforcement & validation
- Reduce human error
- Scale securely

---

## 5️⃣ Protect Data in Transit and at Rest

- Classify data by sensitivity
- Encrypt appropriately
- Control access
- Use tokenization where required

---

## 6️⃣ Keep People Away from Data

- Reduce manual handling
- Automate processing
- Limit direct system access
- Minimize human error exposure

---

## 7️⃣ Prepare for Security Events

- Define incident response plans
- Run simulations (game days)
- Automate detection and response
- Align to organizational requirements

---

# 5️⃣ Security Best Practice Areas (7 Domains)

The Security Pillar is structured into:

1️⃣ Security Foundations  
2️⃣ Identity & Access Management  
3️⃣ Detection  
4️⃣ Infrastructure Protection  
5️⃣ Data Protection  
6️⃣ Incident Response  
7️⃣ Application Security  

---

# 6️⃣ Security Foundations

---

## 🔐 Shared Responsibility Model

Security is shared between AWS and the customer:

### AWS → Security **OF** the Cloud
- Physical infrastructure
- Hardware
- Networking
- Facilities
- Hypervisor
- Managed service infrastructure

### Customer → Security **IN** the Cloud
- Data
- Identity & access
- Guest OS (for EC2)
- Applications
- Configuration
- Encryption choices

Example:

- With EC2 → You manage OS + patches
- With managed services → AWS manages more layers

---

## 🏢 Multi-Account Strategy

Best practice:

- Separate environments:
  - Production
  - Development
  - Test
- Use accounts as security boundaries
- Apply centralized governance
- Establish guardrails

---

## 🔑 Root User Protection

The root user:
- Has full administrative privileges
- Cannot always be restricted

Best practices:
- Avoid routine use
- Disable programmatic access
- Enable strong authentication
- Protect credentials securely

---

## 🔄 Operate Securely

To operate securely:

- Define control objectives
- Maintain threat models
- Stay updated with threat intelligence
- Automate validation of controls
- Continuously reassess risks

---

# 7️⃣ Identity & Access Management (IAM)

Two identity types:

---

## 👤 Human Identities

Examples:
- Admins
- Developers
- Operators
- External collaborators

Best practices:
- Use centralized identity provider
- Enforce MFA
- Rotate credentials
- Use strong password policies
- Organize users into groups

---

## 🤖 Machine Identities

Examples:
- EC2 instances
- Lambda functions
- Applications
- External systems

Best practices:
- Use temporary credentials
- Avoid embedded secrets
- Store secrets securely
- Automate rotation

---

## 🔐 Permissions Management

Permissions control:
- Who can access
- What resource
- What action
- Under what conditions

Best practices:

- Grant least privilege
- Use groups instead of individual policies
- Define permission guardrails
- Monitor public & cross-account access
- Remove unused permissions
- Enable just-in-time emergency access
- Integrate access with lifecycle processes

---

# 8️⃣ Detection

Detection includes:

1️⃣ Detect unwanted configuration changes  
2️⃣ Detect unexpected behavior  

---

## 🔎 Detection Best Practices

- Enable service & application logging
- Retain logs securely
- Analyze logs centrally
- Automate response workflows
- Create actionable alerts
- Associate each alert with a runbook/playbook

Detection supports:
- Compliance
- Governance
- Threat identification
- Incident response

---

# 9️⃣ Infrastructure Protection

Goal:
Protect systems from unauthorized access and vulnerabilities.

---

## 🌐 Network Protection

Best practices:

- Create network layers
- Control traffic at all layers
- Implement Zero Trust
- Automate protection mechanisms
- Inspect and filter traffic
- Use intelligent threat detection

---

## 💻 Compute Protection

Applies to:
- EC2
- Containers
- Serverless
- Databases
- IoT devices

Best practices:

- Perform vulnerability scanning
- Patch regularly
- Reduce attack surface
- Harden OS configurations
- Prefer managed services
- Automate protection
- Avoid interactive access where possible
- Implement code signing

---

# 🔟 Data Protection

---

## 🗂 Data Classification

- Identify sensitive data
- Determine owners
- Map legal requirements
- Define lifecycle policies
- Automate classification where possible

---

## 🔐 Protect Data at Rest

Best practices:

- Enforce encryption
- Secure key management
- Rotate keys
- Enforce strict access control
- Prevent public access
- Use isolation & versioning
- Minimize direct human access

---

## 🔒 Protect Data in Transit

Best practices:

- Use encrypted protocols (TLS, IPsec)
- Enforce encryption policies
- Rotate certificates
- Authenticate communications
- Detect unauthorized data movement
- Automate boundary enforcement

---

# 1️⃣1️⃣ Incident Response

Even strong controls cannot prevent all incidents.

Prepare to:

- Contain
- Mitigate
- Recover
- Preserve forensic evidence

---

## 🎯 Cloud Response Design Goals

- Establish response objectives
- Document response plans
- Preserve logs and evidence
- Use redeployment for remediation
- Automate recurring responses
- Scale response mechanisms
- Learn and improve

---

## 🛠 Prepare & Simulate

- Identify key stakeholders
- Pre-provision access for responders
- Prepare forensic tools
- Automate containment
- Run incident-response game days
- Continuously iterate and improve

---

# 1️⃣2️⃣ Educate & Improve

Security teams must:

- Develop programming skills
- Understand automation & CI/CD
- Stay current on AWS services
- Maintain workload awareness
- Train entire organization on security awareness

Game days = practice + continuous improvement.

---

# 1️⃣3️⃣ Application Security

Security must be embedded in development.

---

## 🧑‍💻 Secure Development Practices

- Train builders
- Adopt secure coding standards
- Embed security ownership in teams

---

## 🤖 Automate Testing

- Security testing in CI/CD
- Static analysis
- Dependency scanning
- Infrastructure testing

---

## 🔎 Manual & Advanced Testing

- Manual code reviews
- Penetration testing
- Validate pipeline security
- Protect build infrastructure

---

## 📦 Centralized Dependency Management

- Validate packages centrally
- Prevent malicious libraries
- Maintain traceability

---

## 🚀 Programmatic Deployments
