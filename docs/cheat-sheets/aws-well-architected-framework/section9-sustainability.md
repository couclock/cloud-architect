# 📘 Deep Dive on the Sustainability Pillar

---

# 1️⃣ Learning Objectives

In this module you learn:

- What the **Sustainability Pillar** is
- The **design principles** of sustainability
- The **best practice areas**
- How to reduce **energy consumption** and **environmental impact** of AWS workloads

---

# 2️⃣ Sustainability Pillar Overview

The **Sustainability Pillar** is the **most recent pillar**, introduced in **2021**.

Its goal is to help organizations:

- Measure sustainability impact
- Improve efficiency
- Reduce environmental footprint of workloads

---

# 3️⃣ What Is the Sustainability Pillar?

The **Sustainability Pillar** provides a framework to:

- Measure architectures against sustainability best practices
- Identify areas for improvement
- Reduce **energy consumption** of cloud workloads

It helps evaluate:

- Workload **design**
- **Architecture**
- **Implementation**

The focus is primarily on:

- **Energy efficiency**
- **Resource usage reduction**

---

# 4️⃣ Sustainability Best Practices Approach

The pillar focuses on three core practices:

### 1️⃣ Understand
Understand the impact of the services and resources used.

### 2️⃣ Quantify
Measure the environmental impact throughout the **entire workload lifecycle**.

### 3️⃣ Apply
Apply architectural best practices to **reduce environmental impact**.

---

# 5️⃣ Sustainability and the Shared Responsibility Model

Sustainability in AWS follows the **shared responsibility model**.

### AWS Responsibility
AWS is responsible for:

- Sustainable data centers
- Efficient infrastructure
- Renewable energy usage

### Customer Responsibility
Customers are responsible for:

- Designing **efficient architectures**
- Using **best practices**
- Reducing workload resource usage

---

# 6️⃣ Why Sustainability Matters

Organizations consider sustainability because of:

- Customer demand
- Government regulations
- Employee expectations
- Impact investing
- Competitive advantage

Sustainability can also influence **brand reputation and long-term strategy**.

---

# 7️⃣ Sustainability Design Principles (6)

---

## 1️⃣ Understand Your Impact

Measure the environmental impact of workloads.

Consider:

- Compute usage
- Storage usage
- Networking
- Lifecycle impact

Include impacts from:

- User interaction
- Resource creation
- Resource retirement

---

### Establish Sustainability KPIs

Examples:

- Compute resources per transaction
- Storage used per user
- Energy consumed per workload

Use metrics to:

- Track improvements
- Detect regressions
- Evaluate proposed changes

---

### Plan for Growth

Design workloads so that:

Growth results in **lower impact per unit of work**

Examples:

- Per transaction
- Per request
- Per user

---

## 2️⃣ Maximize Utilization

Increase efficiency by using resources effectively.

Example:

Two servers at **30% utilization** are less efficient than one server at **60% utilization**.

Best practices:

- Rightsize resources
- Eliminate idle resources
- Remove unused storage
- Avoid unnecessary processing

---

## 3️⃣ Anticipate and Adopt Efficient Technologies

Continuously monitor for:

- New instance types
- Improved hardware
- Efficient software architectures

Adopting new technologies can significantly reduce resource consumption.

---

## 4️⃣ Use Managed Services

Managed services increase efficiency by sharing infrastructure.

Examples:

- Serverless compute
- Managed databases
- Container services

Shared infrastructure allows AWS to operate at **large scale efficiency**.

---

### Example Efficiency Improvements

Examples include:

- Automatically moving infrequently accessed data to cold storage
- Auto-scaling compute capacity based on demand

These reduce unnecessary energy usage.

---

## 5️⃣ Reduce Downstream Impact

Design workloads that minimize impact on **customer devices**.

Examples:

- Optimize network payload size
- Reduce processing requirements on devices
- Avoid forcing hardware upgrades

Testing can be performed using device farms to evaluate impact.

---

## 6️⃣ Optimize End-to-End Efficiency

Focus on efficiency across the entire system:

- Infrastructure
- Software
- Data handling
- User interaction

Improving any part of the system can reduce the overall environmental footprint.

---

# 8️⃣ Sustainability Best Practice Areas (6)

The pillar organizes sustainability practices into six areas:

1️⃣ Region Selection  
2️⃣ Alignment to Demand  
3️⃣ Software and Architecture Patterns  
4️⃣ Data Patterns  
5️⃣ Hardware and Services  
6️⃣ Process and Culture  

---

# 9️⃣ Region Selection

Choosing the right **AWS Region** impacts:

- Performance
- Cost
- Carbon footprint

Regions may vary in:

- Energy efficiency
- Renewable energy usage
- Infrastructure efficiency

Select Regions based on:

- Business requirements
- Sustainability goals

---

# 🔟 Alignment to Demand

Cloud elasticity helps match **resource supply to workload demand**.

Goal:

Avoid **overprovisioning resources**.

---

### Best Practices

- Use auto scaling
- Dynamically adjust capacity
- Scale infrastructure based on load

---

### Align SLAs with Sustainability

Review service level agreements to ensure they:

- Meet business requirements
- Avoid excessive resource provisioning

---

### Remove Unused Assets

Decommission resources that are no longer needed.

Examples:

- Old environments
- Idle servers
- Unused storage

This reduces waste and energy usage.

---

### Optimize Geographic Placement

Reduce network traffic distance by placing workloads closer to users.

Benefits:

- Reduced latency
- Reduced network resource usage
- Improved efficiency

---

### Smooth Demand

Flatten demand spikes using:

- Queues
- Buffers
- Throttling

This reduces peak infrastructure requirements.

---

# 1️⃣1️⃣ Software and Architecture Patterns

Architecture design has a strong impact on sustainability.

---

### Use Efficient Architecture Patterns

Examples:

- Event-driven systems
- Queue-based processing
- Asynchronous processing

These improve resource utilization.

---

### Remove Unused Components

Eliminate components that:

- Have little usage
- Provide no business value

---

### Optimize Resource-Intensive Code

Focus optimization on code sections that:

- Consume most CPU
- Consume most memory
- Run most frequently

Improving these areas reduces overall resource usage.

---

### Optimize Customer Device Usage

Understand how applications interact with:

- Customer hardware
- Mobile devices
- End-user infrastructure

Reduce device resource consumption when possible.

---

### Optimize Data Access Patterns

Use architectures that support efficient data usage.

Examples:

- Efficient caching
- Optimized storage access
- Reduced data transfers

---

# 1️⃣2️⃣ Data Patterns

Data storage and movement strongly affect sustainability.

---

## Implement Data Classification

Classify data based on:

- Importance
- Business value
- Access frequency

Then store data using the **most efficient storage tier**.

---

## Implement Data Lifecycle Policies

Automate lifecycle management to:

- Archive old data
- Delete obsolete datasets

This reduces total storage requirements.

---

## Use Elastic Storage

Expand storage **only when needed**.

Avoid provisioning large unused storage capacity.

---

## Remove Redundant Data

Delete:

- Duplicate datasets
- Obsolete data
- Temporary files

Shared storage systems can also reduce duplication.

---

## Minimize Data Movement

Reduce data transfer across networks.

Techniques include:

- Shared storage
- Object storage
- Local data processing

---

## Optimize Backup Policies

Only back up data that:

- Has business value
- Is required for compliance

Exclude temporary or ephemeral storage.

---

# 1️⃣3️⃣ Hardware and Services

Hardware choices directly impact sustainability.

---

## Use Minimal Hardware

Provision only the hardware required to support workloads.

Avoid unnecessary infrastructure.

---

## Use Efficient Instance Types

New instance types often provide:

- Better performance
- Higher energy efficiency

Regularly evaluate newer instance generations.

---

## Use Managed Services

Managed services allow AWS to optimize hardware utilization across many customers.

This reduces total infrastructure requirements.

---

## Use Hardware Accelerators

Accelerators such as specialized processors can reduce:

- Execution time
- Infrastructure needs

This improves overall efficiency.

---

# 1️⃣4️⃣ Process and Culture

Sustainability should be integrated into organizational practices.

---

## Improve Development Practices

Adopt development processes that:

- Test sustainability improvements
- Reduce unnecessary testing infrastructure
- Deliver incremental improvements

---

## Keep Workloads Updated

Use updated software versions to benefit from:

- Performance improvements
- Efficiency enhancements
- Bug fixes

---

## Increase Resource Utilization

Improve utilization of resources used for:

- Development
- Testing
- Build pipelines

Shared environments can improve efficiency.

---

## Use Device Farms for Testing

Managed device farms allow testing across many hardware devices efficiently without maintaining physical infrastructure.

---

# 📌 Mental Model

Sustainability in AWS =

Understand Impact  
+ Measure Environmental Cost  
+ Optimize Resource Usage  
+ Use Efficient Architectures  
+ Reduce Waste  
+ Continuously Improve

---

# 🧠 One-Sentence Summary

The Sustainability Pillar helps organizations design cloud architectures that reduce environmental impact by improving energy efficiency, minimizing resource usage, and continuously optimizing workloads across infrastructure, software, data, and operational processes.