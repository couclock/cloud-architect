# Security

## Table of Contents

- [Security](#security)
  - [Table of Contents](#table-of-contents)
  - [Encryption Fundamentals](#encryption-fundamentals)
  - [Envelope Encryption](#envelope-encryption)
  - [Hardware Security Modules (HSMs)](#hardware-security-modules-hsms)
  - [Hashing](#hashing)
  - [Digital Signatures](#digital-signatures)

## Encryption Fundamentals

### Approaches
- **At Rest**: protects stored data (disk/cloud); uses a secret key/password  
- **In Transit**: protects data in motion; creates encrypted tunnel between systems  

### Core Concepts
- **Plaintext**: unencrypted data  
- **Ciphertext**: encrypted data  
- **Algorithm**: encryption method (e.g., AES, DES)  
- **Key**: secret used by algorithm  
- **Encryption**: plaintext + key → ciphertext  
- **Decryption**: ciphertext + key → plaintext  

### Symmetric Encryption
- One **shared key** (encrypt + decrypt)  
- Fast, low overhead  
- **Challenge**: secure key exchange  
- Best for: local storage (files/disks)  

### Asymmetric Encryption
- **Key pair**: public (encrypt), private (decrypt)  
- No prior key exchange needed  
- Slower than symmetric  
- Used in: TLS/SSL, SSH, PGP  

### Hybrid Model
- Asymmetric → exchange symmetric key  
- Symmetric → bulk data encryption  

### Signing
- Private key **signs**, public key **verifies**  
- Ensures **authenticity + integrity**  
- Encryption alone does not prove identity  

### Steganography
- Hides data inside other data (e.g., images)  
- Provides **deniability**  
- Often combined: encrypt → hide → send  

### Key Takeaways
- Encryption = confidentiality  
- Symmetric = fast, key sharing issue  
- Asymmetric = secure exchange, slower  
- Signing = identity verification  
- Steganography = hides existence of data

---
## Envelope Encryption

### Definition
- Encrypt **data** with a **DEK**, then encrypt that DEK with a **KEK**

### Keys
- **DEK (Data Encryption Key)**: encrypts the object/data, usually symmetric  
- **KEK (Key Encryption Key)**: encrypts the DEK, managed by **KMS**  

### Encrypt Flow
1. KMS generates:
   - plaintext **DEK**
   - encrypted (**wrapped**) DEK  
2. Service uses plaintext DEK to encrypt data  
3. Plaintext DEK is discarded  
4. Wrapped DEK is stored with the encrypted object  

### Decrypt Flow
1. Retrieve encrypted object + wrapped DEK  
2. Send wrapped DEK to KMS  
3. KMS returns plaintext DEK (if allowed)  
4. Use DEK to decrypt data  
5. Discard plaintext DEK  

### Benefits
- **Fast**: data encrypted with symmetric DEKs  
- **Scalable**: one KEK can protect millions of DEKs  
- **Safer**: each object can use a unique DEK  
- **Secure**: storage access alone is not enough; KMS permissions also required  

### Key Takeaway
- **DEK encrypts data**
- **KEK protects DEK**
- Common AWS pattern: **S3 + KMS**

---
## Hardware Security Modules (HSMs)

### Definition
- Dedicated device that **stores keys** and performs **cryptographic operations**
- Keys are generated, used, and usually kept **inside the HSM**

### Why HSMs Matter
- Without HSMs, keys may exist in:
  - apps
  - OS
  - hypervisor
  - memory/storage
  - backups
- This increases risk of **leakage or theft**

### How HSMs Work
- Applications send **data/requests** to the HSM
- HSM performs encryption, decryption, signing, etc.
- HSM returns the **result**, not the key

### Security Benefits
- Keys **never leave** the device
- Isolated **blast radius**
- Separate internal authentication
- Hardened against **physical and logical tampering**
- Often supports strict **role separation**

### Access Model
- Access is tightly controlled
- Operations exposed via standard APIs, e.g.:
  - **PKCS#11**
  - **JCE**
  - **CryptoNG**

### Common Uses
- **SSL/TLS offload**
- **Private PKI / certificate signing**
- Secure enterprise key management

### Key Takeaway
- HSMs create a secure **cryptographic island**
- They improve **key protection, control, and trust**

---
## Hashing

### Basics
- **Hashing** = data → **fixed-length fingerprint**
- **One-way**: not reversible
- **Deterministic**: same input = same hash
- Tiny change in input = very different hash

### Rules
- ✅ Same data → same hash
- ✅ Different data → different hash
- ❌ No reverse recovery
- ❌ No collisions

### Algorithms
- ❌ **MD5** = weak, collision-prone
- ✅ **SHA-256** = preferred

### Uses
- Password storage
- File integrity checks
- Digital signatures
- TLS / certificates
- Malware fingerprints

### Passwords
- Store **hash**, not plaintext
- Login = hash entered password, compare with stored hash

### Exam Tip ⚠️
- **Hashing ≠ Encryption**
- **Hashing** = integrity / verification
- **Encryption** = confidentiality / reversible with key

### Integrity Check
- Download file
- Generate local hash
- Compare with published hash
- Match = likely unchanged

### Best Practice 🔐
- Use **modern algorithms**
- Avoid **legacy crypto**
- For trust, use **hash + digital signature**

### Memory Aids
- **Hash = fingerprint**
- **MD5 bad**
- **SHA-256 good**
- **Integrity = compare hashes**

---
## Digital Signatures

### Core
- **Digital signature** proves:
  - **Integrity** = unchanged
  - **Authenticity** = trusted sender

### Keys
- **Private key** = secret, used to **sign**
- **Public key** = shared, used to **verify**

### Process
- Hash document
- Sign **hash** with **private key**
- Send document + signature

### Verify
- Hash received document
- Verify signature with **public key**
- Compare hashes

### Result
- ✅ Hashes match = not modified
- ✅ Signature valid = sender is authentic

### Exam Tip ⚠️
- **Hashing** = integrity
- **Signing** = authenticity
- **Encryption** = confidentiality

### AWS / Real Uses
- **TLS/SSL certificates**
- **DNSSEC**
- Signed software / updates

### Best Practice 🔐
- Use **hash + signature**
- For secrecy too: **encrypt + sign**

### Memory Aids
- **Private signs**
- **Public verifies**
- **Hash = what**
- **Signature = who**