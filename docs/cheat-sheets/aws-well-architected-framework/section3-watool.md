# 📘 Deep Dive on the AWS Well-Architected Tool (WA Tool)

---

# 1️⃣ Learning Objectives

In this module you learn:

- Components of the AWS Well-Architected Tool
- Key features of the tool
- How to perform a Well-Architected Framework Review (WAFR)
- How to track improvements over time
- Where to find additional resources

---

# 2️⃣ Continuous Improvement Mechanism (Tool-Centric View)

The WA Tool supports the 3-step lifecycle:

## 📘 1. Learn
- Study framework best practices
- Use AWS lenses
- Use custom lenses for org-specific rules

## 📊 2. Measure
- Create workload in WA Tool
- Answer pillar questions
- Identify High-Risk Issues (HRI) & Medium-Risk Issues (MRI)

## 🔧 3. Improve
- Use improvement plans
- Use Well-Architected Labs
- Work with AWS Solutions Architects
- Work with AWS Partners
- Track progress via milestones

🔁 This must be applied to **every workload**

---

# 3️⃣ Framework Components (Recap)

The AWS Well-Architected Framework includes:

## 📚 Content
- Pillars
- Design principles
- Questions
- Best practices
- Lenses

## 🛠 Tool
- AWS Well-Architected Tool (console + API)

## 📊 Data
- Answers from reviews
- Identified risks
- Milestones
- Portfolio-level insights

The Tool operationalizes the framework.

---

# 4️⃣ What Is the AWS Well-Architected Tool?

The AWS Well-Architected Tool:

- Central place to run WAFRs
- Stores workload reviews securely in your AWS account
- Follows least-privilege access
- Supports console + API access
- Enables collaboration via sharing

You can:
- Review workloads
- Apply AWS lenses
- Apply custom lenses
- Track risks
- Generate reports
- Share workloads
- Track progress over time

---

# 5️⃣ Dashboard Overview

When opening the tool in the console:

You see:
- Workloads in selected Region
- Number of questions answered
- Number of risks identified
- Available lens upgrades

If a workload uses an outdated lens version:
👉 You can upgrade it.

You can:
- View all workloads (per account & Region)
- Filter / search
- Create a new workload

---

# 6️⃣ Creating a New Workload

When defining a workload, required fields include:

## Mandatory Fields

- ✔ Workload Name (unique, descriptive)
- ✔ Description (scope + purpose)
- ✔ Review Owner (responsible person)
- ✔ Environment:
  - Production
  - Pre-production
- ✔ Regions (used for filtering/searching)

Important:
A workload is a **customer-defined concept** — synthetic grouping of components delivering business value.

---

## Additional Fields

### Account IDs
- Optional multiple accounts
- No default IAM permissions required
- May need IAM adjustments for API or partner tools

### Architecture URL (Optional)
- Link to design documentation
- Useful for AWS SA or Partner collaboration

### Industry Type & Industry
- Used for sorting/filtering

---

# 7️⃣ Workload Details Page

After creation, you can:

- Edit workload details
- Delete workload
- View questions answered vs total
- View identified risks
- Save milestones

---

## Additional Sections

### 📝 Notes
- Open-ended tracking
- Launch plans
- Important updates

### 🔍 Lenses Applied
- AWS lenses
- Custom lenses

### 📊 Pillar Priority
Default order reflects common approach:
1. Operational Excellence
2. Security
3. Reliability
4. Performance Efficiency
5. Cost Optimization
6. Sustainability

You can change priority:
- Reorders questions
- Reorders recommendations

⚠ No pillar is "more important" — this is workflow prioritization.

---

# 8️⃣ Milestones (Progress Tracking)

Milestones allow:

- Snapshot of review state at a point in time
- Tracking improvements
- Comparing progress

Typical workflow:

1. Complete initial review
2. Identify risks
3. Implement improvements
4. Update answers
5. Save new milestone

You can:
- Generate report per milestone
- View milestone history

This enables measurable improvement over time.

---

# 9️⃣ Sharing Workloads

You can share workloads with:

- IAM users
- AWS accounts
- AWS Organizations
- AWS Solutions Architects
- AWS Partners

You can view:
- Share status (Pending / Accepted)
- Principal type
- Granted permissions

This supports collaborative reviews.

---

# 🔟 Inside a Question (Tool Content Structure)

Each question contains:

## Top Section
- Pillar
- Question number
- Key concept
- Explanation

Example:
Cost Optimization → Rightsizing  
Supports design principle: Adopt a consumption model

---

## Middle Section
- Checkboxes = Best practices

If not selected:
→ May trigger HRI or MRI

---

## Left Detail Pane
- Explanation per best practice
- Implementation guidance
- Helpful resources

The Tool connects:
Design Principle → Concept → Best Practices → Risk Level

---

# 1️⃣1️⃣ Custom Lenses

You can create your own lens including:

- Custom pillars
- Custom questions
- Custom answer choices
- Risk rules (HRI / MRI)
- Improvement plans
- Helpful resources

How:
1. Download JSON template
2. Customize
3. Upload into WA Tool
4. Apply to workload

Custom lenses can be:
- Shared across accounts
- Shared with AWS SA / partners

Purpose:
👉 Enforce organizational standards consistently.

---

# 1️⃣2️⃣ Major Enhancements

## 🌱 Sustainability Pillar
Introduced at re:Invent 2021  
Available in tool since March 2022  
Helps reduce environmental impact.

---

## 🔗 AWS re:Post Integration
Direct access to community Q&A.
Includes Well-Architected community topics.

---

## 🏢 AWS Organizations Integration (June 2022)
- Share workloads across org
- Share custom lenses
- Improve governance at scale

---

## 🏛 AWS GovCloud (US) Support (Aug 2022)
- Available in GovCloud Regions
- Supports regulated workloads
- Enables self-service reviews

---

## 🛡 AWS Trusted Advisor Integration
Automatically surfaces:
- Trusted Advisor findings
- Resource checks

Benefit:
- Faster validation
- More accurate answers
- Less manual verification

---

## 📦 AWS Service Catalog AppRegistry Integration

AppRegistry:
- Stores applications
- Tracks associated resources

Integration Benefit:
- Visibility into workload-resource relationships
- Faster review preparation
- Better organization

---

# 1️⃣3️⃣ Key Exam Concepts

- WA Tool operationalizes the framework
- Workloads are customer-defined constructs
- Milestones track improvement over time
- Sharing enables collaboration
- Custom lenses enforce org-specific standards
- Trusted Advisor integration improves review accuracy
- Organizations integration enables cross-account governance
- Sustainability is the 6th pillar

---

# 🧠 Mental Model

AWS Well-Architected Tool =

Workload Registry  
+ Structured Reviews  
+ Risk Identification  
+ Milestone Tracking  
+ Lens Management  
+ Sharing & Governance  
+ Continuous Improvement Engine  

---

# 📌 One-Sentence Summary

The AWS Well-Architected Tool is the operational engine of the Well-Architected Framework, enabling customers to measure, track, share, and continuously improve workloads against AWS and organization-specific best practices.
