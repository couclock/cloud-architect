# 📘 How to Run a Well-Architected Framework Review (WAFR)

---

# 1️⃣ What Is a Well-Architected Framework Review (WAFR)?

A **Well-Architected Framework Review (WAFR)** is a:

- Structured evaluation of a workload
- Measurement against AWS best practices
- Risk identification exercise
- Continuous improvement mechanism

🎯 Outcome:
- Identified **High-Risk Issues (HRI)**
- Identified **Medium-Risk Issues (MRI)**
- Concrete **improvement plan**
- Better alignment with the six pillars

---

# 2️⃣ Continuous Improvement Mechanism

WAFR follows a 3-step loop:

## 📘 1. Learn
- Study AWS best practices
- Understand pillar design principles
- Review applicable lenses

## 📊 2. Measure
- Use AWS Well-Architected Tool (WA Tool)
- Answer pillar questions
- Apply relevant lenses
- Identify risks

## 🔧 3. Improve
- Prioritize risks
- Create remediation plan
- Implement improvements
- Track progress

🔁 Apply this cycle to **every workload**

---

# 3️⃣ Intent of a Review

A review is:

- A conversation (NOT an audit)
- Lightweight (hours, not days)
- Blame-free
- Collaborative
- Continuous

Key mindset:
> Reviews should happen early and often — not just before production.

---

# 4️⃣ Key Learnings from Thousands of Reviews

- Review early in lifecycle (cheaper fixes)
- Most problems are neglected decisions, not bad decisions
- Most workloads contain HRIs
- Finding risks is good — they already exist
- Addressing risks reduces business exposure

---

# 5️⃣ Common Use Cases

## 📚 Learn Cloud Best Practices
Teams understand architectural trade-offs.

## 🏛 Technology Governance
Ensure workloads are production-ready.
Create consistency across teams.

## 📊 Portfolio Management
- Central registry of workloads
- Visibility into risks
- Identify organizational trends
- Inform investment decisions

The AWS WA Tool provides:
- Portfolio-level visibility
- Metadata tracking (account, Region, production status)
- Risk trend analysis

---

# 6️⃣ The Three Review Phases

1. Prepare  
2. Review  
3. Improve  

---

# 🔹 Phase 1: Prepare

## ✔ Define the Workload

A workload:
- Delivers business value
- Can include technology, infrastructure, process, team

Example:
- E-commerce website
- Internal analytics platform

---

## ✔ Identify Core Team

Includes:
- Pillar subject matter experts
- Workload owner
- Sponsor (owns improvement plan)

---

## ✔ Hold Scoping Session

- Confirm workload definition
- Select pillars & lenses
- Identify SMEs
- Define review format
- Gather existing data (don’t create new)

---

## 📅 Suggested Timeline

**~3 weeks before**
- Select workload
- Identify core team

**~16 days before**
- Scoping meeting
- Select questions/lenses
- Assign SMEs

**~5 days before**
- Confirm scope
- Reminder to bring relevant info

---

# 🔹 Phase 2: Review

Conduct review using AWS WA Tool.

## ✔ Best Practices During Review

- Moderator manages scope & time
- Separate note taker
- Only one person updates tool
- Avoid tool conflicts (no dynamic merging)
- Use AWS WA Tool to capture risks

Optional:
- Use Amazon S3 bucket to store diagrams & documentation
- Use naming convention (account + workload)

---

## 🎯 Review Output

- High-Risk Issues (HRI)
- Medium-Risk Issues (MRI)
- Improvement recommendations
- Current architecture state documentation

---

# 🔹 Phase 3: Improve

Now translate risks into action.

---

# 7️⃣ Risk Prioritization

## 🔎 What is Risk Prioritization?

Ranking risks based on:
- Likelihood
- Business impact

Impact examples:
- Lost revenue
- Brand damage
- Legal exposure
- Security breach
- Market share loss
- Delayed time-to-market

---

## Risk Levels in WA Framework

- 🔴 High Risk (HRI)  
  Significant potential negative impact

- 🟡 Medium Risk (MRI)  
  Moderate potential impact

---

# 8️⃣ Improvement Workflow

## Step 1: Identify Risks
From WAFR review results.

## Step 2: Determine Prescriptive Solutions
Address:
- Highest impact
- Reasonable implementation effort
- Multiple risks at once (if possible)

## Step 3: Prioritize Business-Wise
What matters most to the organization?

## Step 4: Implement Solutions
Execute remediation plan.

## Step 5: Track Progress
Ensure improvements achieve desired outcomes.

---

# 9️⃣ What Improvements May Involve

Best practices span:

- 👥 People (training, ownership)
- ⚙ Processes (runbooks, governance)
- 🛠 Technology (architecture changes)

Successful improvement often requires:
- Internal teams
- AWS account teams
- AWS Partners
- Well-Architected Labs

---

# 🔟 Key Concepts for Exam

- WAFR = Continuous improvement mechanism
- 3 phases: Prepare → Review → Improve
- HRIs must be prioritized
- Reviews are conversations, not audits
- Portfolio visibility is a major benefit
- Risk = likelihood × impact
- Reviews should happen early in lifecycle

---

# 🧠 Mental Model

Well-Architected Framework Review =

Learn best practices  
+ Measure workload  
+ Identify risks  
+ Prioritize impact  
+ Implement improvements  
+ Repeat continuously  

---

# 📌 One-Sentence Summary

A Well-Architected Framework Review is a structured, repeatable, and collaborative process used to measure workloads against AWS best practices, identify architectural risks, and continuously improve cloud architectures.
