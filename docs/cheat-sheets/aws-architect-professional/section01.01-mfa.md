## AWS MFA (Multi-Factor Authentication)

### 🔐 Authentication Basics
- **Single-factor auth**: username + password (knowledge)
- **MFA**: requires **≥2 authentication factors**
- Improves security if credentials leak

### 🧩 Authentication Factors
- **Knowledge** → something you know (password, PIN)
- **Possession** → something you have (MFA device/app)
- **Inherence** → something you are (fingerprint, face)
- **Location** → where you are (network/GPS)

### ☁️ MFA in AWS
- Adds **second factor** during login
- Used with **IAM users & root account**
- Requires:
  - Username + password
  - **MFA one-time code**

### 📱 MFA Device Types
- **Virtual MFA** (most common)
  - Apps like authenticator apps
  - Runs on phone/device
- **Hardware MFA**
  - Physical key-fob device

### ⚙️ MFA Setup Flow
1. Enable MFA for user (IAM/root)
2. AWS generates **secret key**
3. Secret encoded in **QR code**
4. Scan QR in authenticator app
5. App generates **rotating OTP codes**

### 🔁 Login Process with MFA
- Step 1: Enter **username + password**
- Step 2: Enter **current MFA code**
- Code changes **periodically (OTP)**

### 🧠 Exam Tips
- **Always enable MFA for root account**
- **MFA protects against credential compromise**
- **Virtual MFA commonly used for IAM users**
- MFA = **knowledge + possession factors**
- Losing password **or** MFA alone ≠ access

### ✅ Security Best Practices
- Enable **MFA on privileged IAM users**
- Protect **root account with MFA**
- Use **authenticator apps for scalability**
- Balance **security vs usability**