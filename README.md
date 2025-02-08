# 🔍 Bug Hunting Setup Scripts  

Welcome to **Bug Hunting Setup Scripts**! 🧕‍♂️ This repository contains automated scripts to quickly set up **bug bounty** and **penetration testing** environments. I created it for my use cases, maybe they will be of some use to you... 


---

## 🛠️ **Scripts Available**  

### 1️⃣ `install-go.sh` - Install & Configure Go  
📌 This script **installs Go (Golang)** manually (not via `apt`) and configures your Go environment for bug bounty tools.  
✅ Checks if Go is installed.  
✅ If Go is present, asks if you want to **reinstall** it.  
✅ Sets up `$GOPATH` and `$PATH`.  

🔹 **Run it:**  
```bash
chmod +x install-go.sh
./install-go.sh
```

---

### 2️⃣ `setup-recon-tools.sh` - Install Reconnaissance Tools  
📌 This script **installs essential recon tools** for discovering subdomains, gathering intelligence, and mapping out targets.  
🧕‍♂️ **Tools Installed:**  
- 🔎 **Amass** - Subdomain enumeration & OSINT.  
- 🌍 **Subfinder** - Passive subdomain discovery.  
- 🏴‍☠️ **Findomain** - Fast subdomain enumeration.  
- 💜 **Waybackurls** - Fetch historical URLs from the Wayback Machine.  
- 📱 **Assetfinder** - Discover related assets of a domain.  
- 🌐 **Gau (GetAllURLs)** - Fetch URLs from various sources.  
- 🔄 **Httpx** - Probe HTTP servers for status codes, technologies, and headers.  
- ⚡ **Nuclei** - Fast vulnerability scanning based on templates.
- 🌍 **Dnsx** - Fast DNS resolver and probe tool.

**& More** 

🔹 **Run it:**  
```bash
chmod +x setup-recon-tools.sh
./setup-recon-tools.sh
```

---

### 3️⃣ `setup-wordlists.sh` - Download Seclists   

📌 This script **downloads wordlists** for fuzzing hidden directories and subdomain enumeration.  

🔹 **Run it:**  
```bash
chmod +x setup-worldlists.sh
./setup-wordlists.sh
```
---

## 🚀 **How to Use These Scripts?**  

1️⃣ **Clone this repo** 👅  
```bash
git clone https://github.com/zuhaibullahbaig/bug-hunting-setup.git
cd bug-hunting-setup
```

2️⃣ **Give execute permissions** 🔑  
```bash
chmod +x install-go.sh setup-recon-tools.sh setup-wordlists.sh
```

3️⃣ **Run the scripts** 🏃  
```bash
./install-go.sh    # Install Go  
./setup-recon-tools.sh   # Install recon tools  
./setup-wordlists.sh # Download wordlists
```

---

### 💡 **Happy Bug Hunting & Recon! 🧕‍♂️🔍**

