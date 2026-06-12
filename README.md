# 🐉 AutoPWN Environment (APE)

<p align="center">
  <img src="https://img.shields.io/badge/version-1.7-red?style=for-the-badge" alt="Version">
  <img src="https://img.shields.io/badge/license-MIT-green?style=for-the-badge" alt="License">
  <img src="https://img.shields.io/badge/OS-Linux-blue?style=for-the-badge" alt="OS">
  <img src="https://img.shields.io/badge/made%20in-Indonesia-ff69b4?style=for-the-badge" alt="Made in Indonesia">
</p>

<p align="center">
  <em>"The only secure system is the one that's powered off."</em><br>
  <strong>— Lutfifakee</strong>
</p>

---

## 📖 Overview

**AutoPWN Environment (APE)** is a lightweight Linux-based security testing workspace designed to operate entirely in RAM. It provides a temporary environment for running tools, performing assessments, and automatically cleaning up artifacts when the session ends.

---

## ⚡ One-Line Installation

```bash
curl -sSL https://raw.githubusercontent.com/Lutfifakee-Project/autopwn-env/main/ape.sh | bash
```

### Permanent Alias Installation

```bash
echo "alias ape='source <(curl -sSL https://raw.githubusercontent.com/Lutfifakee-Project/autopwn-env/main/ape.sh)'" >> ~/.bashrc
source ~/.bashrc
ape
```

---

## 🎯 Features

| Feature | Description |
|----------|-------------|
| 🚀 RAM-Only Workspace | Everything runs inside `/dev/shm/` with no persistent storage |
| 🧹 Auto Cleanup | Session artifacts are automatically removed on exit |
| 🛡️ Security Software Detection | Detects common endpoint monitoring and security products |
| 📦 Binary Downloader | Download commonly used utilities on demand |
| 🔍 LinPEAS Integration | Convenience wrapper for privilege escalation auditing |
| 👀 pspy Integration | Real-time process monitoring |
| 🔄 PTY Auto-Upgrade | Automatically upgrades basic shells to interactive TTYs |
| 🎨 Custom Prompt | Dragon-themed shell prompt |
| 🇮🇩 Made in Indonesia | Developed by an Indonesian security enthusiast |

---

## 📜 Available Commands

| Command | Description |
|----------|-------------|
| `linpeas` | Run LinPEAS (auto-download) |
| `pspy` | Run pspy process monitor (auto-download) |
| `getbin <name>` | Download supported binaries |
| `fastscan <target>` | Quick port scan (requires Nmap) |
| `webscan <target>` | Basic web service enumeration |
| `nclisten <port>` | Start a Netcat listener |
| `bypass403 <url>` | Test alternative HTTP header combinations |
| `help` / `xhelp` | Display help menu |
| `exit` | Clean up and terminate session |

---

## 🚀 Quick Start

### 1. Launch APE

```bash
./ape.sh
```

### 2. Download Tools

```bash
getbin nmap
getbin ffuf
```

### 3. Scan a Target

```bash
fastscan 192.168.1.1
webscan example.com
```

### 4. Run Privilege Escalation Checks

```bash
linpeas
```

### 5. Monitor Processes

```bash
pspy
```

### 6. Start a Listener

```bash
nclisten 4444
```

### 7. Exit and Clean Up

```bash
exit
```

---

## 🛡️ Security Software Detection

APE can identify the presence of several commonly deployed security solutions:

- CrowdStrike Falcon
- Splunk Forwarder
- SentinelOne
- Carbon Black
- Trend Micro
- McAfee
- Symantec
- Sophos

---

## 📂 Workspace Design

All operations occur within a temporary RAM-based directory:

```text
/dev/shm/.ape_<username>_<PID>
```

### Benefits

- ✅ No files written to persistent storage
- ✅ Automatic cleanup on exit
- ✅ No Bash history retention
- ✅ Temporary files removed automatically
- ✅ Reduced forensic footprint

---

## 🔧 Requirements

- Bash 4.0+
- Linux Operating System
  - Kali Linux
  - Ubuntu
  - Debian
  - CentOS
  - WSL2
- `curl`
- Internet connection (for downloading utilities)

---

## 📋 Usage Examples

### Example 1: Basic Network Scan

```bash
./ape.sh
getbin nmap
fastscan 192.168.1.0/24
exit
```

### Example 2: Web Application Testing

```bash
./ape.sh
getbin ffuf
ffuf -w wordlist.txt -u https://target.com/FUZZ
bypass403 https://target.com/admin
exit
```

### Example 3: Reverse Shell Listener

```bash
./ape.sh
nclisten 4444
```

### Example 4: Privilege Escalation Assessment

```bash
./ape.sh
linpeas
exit
```

---

## 🗂️ Available Binaries

| Binary | Command | Purpose |
|----------|----------|----------|
| Nmap | `getbin nmap` | Network scanner |
| FFUF | `getbin ffuf` | Web content discovery |
| SQLMap | `getbin sqlmap` | SQL injection testing |
| Netcat | `getbin nc` | Network utility |
| Socat | `getbin socat` | Advanced networking |
| Chisel | `getbin chisel` | Tunneling and port forwarding |

---

## 🧹 Cleanup Process

Upon exiting, APE automatically performs cleanup actions:

- ✅ Deletes workspace directory
- ✅ Removes downloaded binaries
- ✅ Clears shell history
- ✅ Unsets sensitive environment variables
- ✅ Removes temporary files

---

## ⚠️ Disclaimer

This project is intended solely for:

- Security research
- Educational purposes
- Authorized penetration testing
- Defensive security assessments

Users are responsible for ensuring compliance with all applicable laws, regulations, and authorization requirements.

The author and contributors assume **no liability** for misuse, damages, illegal activities, or consequences resulting from the use of this software.

**Use responsibly and only on systems you own or have explicit permission to assess.**

---

## 📄 License

Released under the MIT License.

See the [LICENSE](LICENSE) file for details.
