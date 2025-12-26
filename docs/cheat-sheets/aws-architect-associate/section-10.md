# Decoupling applications: SQS, SNS, Kinesis & ActiveMQ

Prompt to use:

Please summarize the following transcript into a very compact AWS Solutions Architect Associate (SAA) revision cheat sheet. Include a second-level Markdown title (##) at the top using the section’s main topic. Format the rest in raw Markdown inside a code block, with no separators. Use short bullet points, minimal wording, and highlight only SAA-relevant concepts, AWS services, rules, exam tips, and best practices. Use simple icons when relevant, but keep them limited. Keep the cheat sheet extremely concise and easy to memorize. Here’s the transcript:

## Integration & Messaging

### ⚡ Communication Patterns

- Synchronous: direct service→service, tight coupling, failure ripple risk  
- Asynchronous: middleware between services, decoupled, resilient, scalable

### 📨 Why Async?

- Absorbs spikes \+ unpredictability  
- Prevents downstream overload  
- Independent scaling  
- Better reliability \+ durability

### 📦 Core AWS Services

- SQS: queue | pull | decouple | buffer | scalable  
- SNS: pub/sub | push | fan-out to multiple subscribers  
- Kinesis: real-time streaming | big data | multiple consumers

### 🧠 Exam Notes

- Use async when unpredictable burst traffic → decouple\!  
- Synchronous \= simple but fragile  
- Middleware absorbs load \+ isolates failures  
- Each service scales independently

### ✅ Best Practices

- Prefer loose coupling  
- Queue background processing  
- Use SNS for broadcast events  
- Use Kinesis for continuous data streams

---
## Amazon SQS

### 🧵 Core Concept

- Queue-based async decoupling between apps  
- Producers send ➜ Consumers poll \+ process \+ delete  
- Buffering layer prevents overload  
- Fully managed, highly scalable

### 🚀 Key Features

- Unlimited throughput \+ unlimited messages  
- Message retention: default 4 days | max 14 days  
- Low latency (\<10ms send/receive)  
- Max size: 256 KB (standard)  
- Delivery: at-least-once ✔️ | best-effort ordering  
- Multiple producers \+ multiple consumers  
- Horizontal scaling of consumers

### 🛠️ APIs & Behavior

- SendMessage → store → Consumer receives → DeleteMessage  
- Consumers poll (can get up to 10 msgs/batch)  
- Messages may reappear if not deleted  
- Supports EC2, Lambda, on-prem consumers

### 📈 Scaling Pattern (Exam 🔥)

- Use Auto Scaling Group on consumers  
- Scale using CloudWatch metric:  
  - ApproximateNumberOfMessages  
  - Also age of oldest message  
- Classic exam architecture: decouple app tiers (frontend ➜ SQS ➜ backend)

### 🔐 Security

- In-flight encryption: HTTPS  
- At-rest:  
  - SSE-SQS default managed key  
  - SSE-KMS (CMK, reuse period)  
- IAM policies control API access  
- SQS Access Policy for cross-account \+ service integration (SNS, S3)

### 🧪 FIFO vs Standard (Context)

- Standard: best-effort order \+ possible duplicates  
- FIFO (covered later) fixes ordering \+ dedupe

### 🧰 Operations / UI Notes

- Visibility timeout, delay, wait time  
- Purge queue (deletes all msgs) ⚠️ not prod  
- Dead-letter queue supported  
- Monitoring: queue length \+ age of oldest msg

### ✅ Exam Tips

- “Decouple applications” → think SQS  
- “Handle burst traffic / buffer / spikes” → SQS  
- “At least once delivery” → app must handle duplicates  
- Scale consumers, not queue

---
## Amazon SQS – Key SAA Exam Concepts

### ⏳ Visibility Timeout

- Default 30s (0s–12h)  
- Message invisible after ReceiveMessage  
- If not deleted → reappears → possible double processing  
- Use `ChangeMessageVisibility` to extend  
- Set reasonable value (too long \= stuck, too short \= duplicates)

### ⏰ Long Polling

- Waits 1–20s (prefer 20s)  
- Fewer API calls \+ lower latency  
- Enable queue-level or API `WaitTimeSeconds`  
- Prefer long polling over short polling

### 📦 FIFO Queues

- Guarantees order (First-In-First-Out)  
- Throughput: 300 msg/s | 3000 msg/s (batch)  
- Exactly-once send via Deduplication ID (5 min)  
- Queue name must end with `.fifo`  
- Ordering per **Message Group ID**  
- Optional content-based deduplication

### ⚙️ Scaling & Monitoring

- Works with Auto Scaling Groups  
- Scale on CloudWatch metric:  
  - `ApproximateNumberOfMessagesVisible`  
- Scale out on backlog ↑ ; scale in when ↓

### 🧱 Common Architectures

- Decouple application tiers ✔️  
- Buffer DB writes (RDS/Aurora/DynamoDB) ✔️  
- Prevent overload & ensure durability  
- Expect duplicates → design idempotent consumers

### 📝 SAA Exam Triggers

- “Message processed twice?” → adjust visibility / ChangeMessageVisibility  
- “Need ordering \+ exactly once?” → FIFO  
- “Lower cost \+ latency?” → Long polling  
- “Traffic spikes / async / decouple?” → SQS

---
## Amazon SNS

### 📢 Pub/Sub Basics

- Publisher → SNS Topic → multiple subscribers  
- Fully decoupled, scalable fan-out  
- Subscribers receive all messages (unless filtered)  
- Millions of subscriptions; many topics supported  
- Common subscriber types: Email, SMS, HTTP(S), Lambda, SQS, KDF

### 🧩 Integrations (Exam-Relevant)

- Publish from: CloudWatch Alarms, ASG, S3 events, CFN, Budgets, RDS, DynamoDB, etc.  
- Deliver to: Email / SMS / Mobile push / HTTP(S) / Lambda / **SQS** / **Kinesis Firehose → S3/Redshift**  
- Mobile direct publish supported (APNS, GCM, ADM)

### 🔐 Security & Access

- In-transit encryption default; at-rest via KMS  
- Optional client-side encryption  
- IAM policies control API access  
- SNS Access Policies (like S3 bucket policies)  
- Needed for cross-account \+ S3/SQS write permissions

### 🧨 Fan-Out Pattern (SNS \+ SQS)

- Publish once → deliver to many SQS queues  
- Reliable delivery, no data loss, retry \+ persistence  
- Easily add more subscriber queues  
- Requires SQS queue access policy to allow SNS write  
- Supports cross-region delivery

### 🗂️ S3 → Multiple Destinations

- S3 event limitation: 1 rule per event+prefix  
- Use SNS fan-out to forward to multiple SQS / Lambda / email

### 🧭 FIFO SNS Topics

- Ordering \+ deduplication  
- Subscription must be **SQS FIFO only**  
- Requires `.fifo` suffix  
- Throughput similar to FIFO SQS (limited)  
- Supports message group ID \+ deduplication ID  
- Use when you need: **fan-out \+ ordering \+ exactly-once**

### 🎯 Message Filtering

- JSON filter policy per subscription  
- No filter → receives all messages  
- Route different message types to different subscribers  
- Typical filters: order status, event type, attributes

### 📝 Topic Types (Exam Tip)

- **Standard SNS**  
  - Best-effort order  
  - At-least-once delivery  
  - Highest throughput  
- **FIFO SNS**  
  - Strict order  
  - Exactly-once delivery  
  - Lower throughput

---
## Kinesis Data Streams

### Key Concept

- Real-time streaming & processing

### Examples

- Clickstream, IoT, logs, app events

### Producers

- SDK, **Kinesis Agent**, **KPL**

### Consumers

- Lambda, Firehose, Analytics/Flink, **KCL**

### Features

- Retention: 1–365 days  
- Replay supported  
- Max record 1 MB  
- Ordering: Partition Key  
- Security: KMS/HTTPS

### Provisioned

- Shards manual  
- 1 shard \= 1 MB/s write, 2 MB/s read  
- Pay per shard/hour

### On-Demand

- Auto scale  
- 4 MB/s write, 4k rec/s baseline  
- Pay per throughput

### Ordering

- Partition Key → shard  
- Same key \= ordered

### Libraries

- **KPL** → producers  
- **KCL** → consumers

### Monitoring

- CloudWatch: in/out bytes, iterator age, throttling

### CLI

- `put-record`, `describe-stream`, `get-shard-iterator`, `get-records`  
- Base64 decode

### Limits

- Record ≤ 1 MB, retention ≤ 365 days  
- Ordering per partition key  
- Enhanced Fan-Out 2 MB/s per consumer

### Use Cases

- Analytics, dashboards, logs, IoT, streaming pipelines

---
## **Amazon Data Firehose (Kinesis Data Firehose)**

### ⚡ Purpose

- Stream → targets (S3, Redshift, OpenSearch, 3rd-party, HTTP)  
- Near real-time (buffered)

### 🛠 Sources

- Apps, SDK, Kinesis Agents, CloudWatch, IoT, EventBridge  
- Pull: KDS, CloudWatch, IoT

### 🔄 Transformation

- Optional Lambda: CSV→JSON, format convert, filter

### 📦 Buffer

- Accumulate → flush by size/time  
- Default: 5MB / 300s, min 60s  
- Speed vs efficiency trade-off

### 🎯 Destinations

- AWS: S3, Redshift, OpenSearch  
- 3rd-party: Splunk, Datadog, New Relic, MongoDB  
- Custom HTTP endpoint  
- Backup to S3 (all/failed records)

### 🗃 Data & Compression

- Formats: CSV, JSON, Parquet, Avro, text, binary  
- Convert: Parquet, ORC  
- Compress: gzip, snappy, zip

### ⚙️ Features

- Fully managed, serverless, auto-scale, pay-per-use  
- No storage, no replay

### 🔀 KDS vs Firehose

- **KDS:** real-time, custom code, replay, retention 1yr, provisioned/on-demand  
- **Firehose:** load → targets, fully managed, near real-time, no replay

### 🚀 Setup

- Source: KDS / PUT / AWS / SDK  
- Transform: Lambda (optional)  
- Destination: S3 / Redshift / OpenSearch / HTTP / 3rd-party  
- Buffer, compression, encryption  
- IAM role auto-created (write/read)

### 📊 Monitoring

- CloudWatch: data in/out, success/fail

### ✅ Best Practices

- Adjust buffer for speed vs efficiency  
- Compress → save cost  
- Lambda for custom transform  
- Delete streams post-test

### 📝 Exam Tip

- Near real-time → Firehose  
- Key targets: **S3, Redshift, OpenSearch**

---
## SQS vs SNS vs Kinesis

### 📨 SQS (Simple Queue Service)

- Pull model: consumers request messages  
- Delete after processing → no other consumer reads it  
- Multiple consumers possible → work in parallel  
- Fully managed, auto-scale, no throughput provisioning  
- FIFO queues → ordering guarantee  
- Delay per message possible (e.g., 30s)  
- Use case: decoupled workloads, reliable message queue

### 📣 SNS (Simple Notification Service)

- Push / Pub-Sub model → multiple subscribers receive a copy  
- Up to 12,500,000 subscribers/topic  
- No persistence → undelivered messages can be lost  
- Auto-scale, no throughput provisioning  
- Fan-out pattern: SNS → SQS for durable delivery  
- SNS FIFO topics → pair with SQS FIFO queues

### 🔗 Kinesis Data Streams

- Two consumption modes:  
  - Standard → consumers pull (2 MB/s/shard)  
  - Enhanced Fan-Out → push to consumers (2 MB/s/shard/consumer)  
- Data persists → replay possible  
- Use case: real-time big data, analytics, ETL  
- Ordering: shard-level  
- Scaling: must provision shards (provisioned mode) or auto-scale (on-demand mode)  
- Retention: 1–365 days  
- Throughput depends on shards → manage shard count carefully

### ⚡ Exam Tips

- SQS \= reliable queue, pull, delete → decoupled workloads  
- SNS \= push, fan-out, ephemeral → many subscribers  
- Kinesis \= streaming, replay, shard scaling → analytics/ETL

---
## **Amazon MQ**

### 🖥 Purpose

- Managed message broker → RabbitMQ & ActiveMQ  
- Supports open protocols: MQTT, AMQP, STOMP, OpenWire, WSS  
- Useful for migrating on-prem apps without re-engineering for SQS/SNS

### ⚡ Features

- Queue (like SQS) \+ Topic (like SNS) in one broker  
- Multi-AZ for high availability → active \+ standby  
- Backend storage: Amazon EFS → ensures data persistence during failover  
- Runs on servers → less scalable than SQS/SNS  
- Failover: standby broker uses EFS → data consistency

### 🔑 Exam Tips

- Use Amazon MQ when you need open protocols  
- Supports RabbitMQ & ActiveMQ  
- SQS/SNS \= cloud-native → Amazon MQ \= managed traditional broker  
- Multi-AZ \+ EFS → HA & data safety
