# OSI Netwwork model

## OSI Layer 1 (Physical Layer)

### 🔌 Core Concept
- **Layer 1 = physical transmission of bits (0/1)**
- Moves **raw data over medium** (no logic/intelligence)
- Works with **signals, not frames/packets**

### 🌐 Physical Media Types
- **Copper** → electrical signals ⚡
- **Fiber** → light signals 💡
- **Wireless (WiFi)** → radio waves 📡

### ⚙️ Layer 1 Standards
- Define:
  - Voltage levels (0/1)
  - Timing & data rates
  - Distance limits
  - Modulation methods
  - Cable/connectors
- Ensures devices **share same signaling rules**

### 💻 Devices & Components
- **NIC (Network Interface Card)** = Layer 1 endpoint
- **Cables / WiFi medium**
- **Hub (Layer 1 device)**:
  - Broadcasts to **all ports**
  - No filtering, no intelligence

### 🔁 Communication Model
- **Point-to-point** (2 devices) or **shared medium**
- Data = **broadcast to all devices**
- No targeting → no device awareness

### ⚠️ Key Limitations
- ❌ No addressing (no MAC/IP)
- ❌ No access control (any device can send)
- ❌ No collision detection/prevention
- ❌ No error handling

### 💥 Collisions
- Multiple transmissions = **collision**
- Data becomes **corrupted**
- More devices → **more collisions**
- Only **1 device should transmit at a time**

### 📡 Network Behavior
- **1 Broadcast domain**
- **1 Collision domain**
- Poor scalability with hubs

### 🧠 Exam Tips
- Layer 1 = **"dumb layer" (signals only)**
- **Hub = Layer 1 (broadcasts everything)**
- No MAC/IP → handled at **Layer 2+**
- Layer X device supports **all lower layers**

### ✅ Key Takeaways
- Foundation of networking
- Enables **physical connectivity only**
- Higher layers (L2+) add **intelligence & control**

---
## OSI Layer 2 (Data Link)

### 🔗 Core
- **Device-to-device comms**
- Runs on **Layer 1**
- Uses **frames**

### 🆔 MAC
- **48-bit hardware address**
- **OUI + NIC-specific**
- Enables **unicast/broadcast**

### 📦 Frame
- Dest MAC | Src MAC | EtherType | Payload | FCS
- **Encapsulation**: L3 → L2 ⚠️

### 🚦 Control (CSMA/CD)
- **Sense → Send → Detect collision**
- **Jam + backoff + retry**

### 🔌 Devices
- **Hub (L1)** → broadcast, collisions ❌
- **Switch (L2)** → MAC table, smart forwarding ✅

### 🧠 Switch Logic
- Learn MACs per port
- Unknown → **flood**
- Known → **forward**
- Each port = **1 collision domain**

### ⚠️ Key Points
- Adds **addressing + control**
- Reduces collisions vs L1
- Foundation for **Layer 3**

### 🎯 Exam Tips
- **Switch > Hub**
- MAC ≠ IP
- **Encapsulation = critical**

---
## OSI Layer 3 (Network Layer)

### 🌍 Core
- **End-to-end communication (across networks)**
- Uses **IP + routing**
- Runs on **multiple L2 networks**

### 📦 Packet
- Src IP | Dest IP | Protocol | TTL | Data
- **Packet stays same**, frames change (encapsulation) ⚠️

### 🆔 IP Addressing
- **IPv4 = 32-bit (x.x.x.x)**
- Split:
  - **Network**
  - **Host**
- Same network → direct  
- Different → use **router**

### 🎭 Subnet Mask
- Defines **network vs host**
- Example:
  - `/16` = first 16 bits = network
- Used to decide:
  - **Local vs remote**

### 🚪 Default Gateway
- Router IP on local network
- Used when destination is **remote**

### 🔁 Routing
- **Routers = Layer 3 devices**
- Move packets **hop-by-hop**
- Use **route tables**

### 🗺️ Route Table
- **Destination → Next hop**
- Longest match wins
- `0.0.0.0/0` = **default route**

### 🔗 ARP
- Maps **IP → MAC**
- Needed to send packet via L2
- Uses **broadcast**

### ⚙️ Encapsulation Flow
- L4 data → **packet (L3)**
- Packet → **frame (L2)** → sent
- Frame changes per network, **packet stays**

### ⚠️ Limitations
- No ordering guarantee
- No sessions (handled in L4)
- Best-effort delivery only

### 🎯 Exam Tips
- L3 = **IP + Routing + Routers**
- **Packet ≠ Frame**
- Default route = **fallback**
- ARP = **IP → MAC bridge**

### ✅ Key Takeaway
- Enables the **Internet itself**
- Connects multiple L2 networks into one system

---
## OSI Layer 4 (Transport) + L5 (Session)

### 🚀 Core
- **Process-to-process communication**
- Builds on **Layer 3 (IP)**
- Uses **ports + segments**

### 🔧 Protocols
- **TCP** → reliable, ordered, connection-based ✅  
- **UDP** → fast, no reliability ❌  

### 🔌 Ports
- Identify **applications**
- Connection = **Src IP + Src Port + Dest IP + Dest Port**
- **Well-known ports** (e.g. 443 HTTPS)
- **Ephemeral ports** (client-side, temporary)

### 📦 TCP Segment
- Src Port | Dest Port  
- Sequence + Acknowledgement  
- Flags (SYN, ACK, FIN)  
- Window (flow control)  
- Checksum  

### 🔁 Key Features (TCP)
- **Ordering** → sequence numbers  
- **Reliability** → ACK + retransmission  
- **Flow control** → window size  
- **Error detection**

### 🤝 3-Way Handshake
1. **SYN** → start connection  
2. **SYN-ACK** → acknowledge + respond  
3. **ACK** → connection established  

### 🔄 Data Flow
- Segments → inside **IP packets** (encapsulation) ⚠️  
- Bidirectional communication (client ↔ server)

### ⚠️ L3 Limitations (Solved by L4)
- ❌ No ordering  
- ❌ Packet loss  
- ❌ No app separation  
- ❌ No flow control  

### 🔐 Stateful vs Stateless
- **Stateless (NACL)**:
  - Needs **2 rules** (request + response)
- **Stateful (Security Group)**:
  - **1 rule** (response auto allowed)

### 🧠 Session (L5 concept)
- Logical **connection tracking**
- Built on TCP communication

### 🎯 Exam Tips
- TCP = **reliable + handshake**
- UDP = **fast + no guarantees**
- Ports = **app-level separation**
- **Stateful vs stateless = very important**

### ✅ Key Takeaway
- Layer 4 makes the internet **usable & reliable**
- Enables **multiple apps + stable communication**