# 🚀 Automated Nginx Deployment with Terraform & Docker

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![DigitalOcean](https://img.shields.io/badge/DigitalOcean-0080FF?style=for-the-badge&logo=digitalocean&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

> A fully automated, one-click cloud infrastructure deployment system built with production-grade DevOps practices.

---

## 📋 Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Security](#security)
- [How It Works](#how-it-works)
- [Cleanup](#cleanup)
- [What I Learned](#what-i-learned)

---

## 🎯 Overview

This project provisions a complete cloud web server infrastructure using a **single command**. It automatically:

1. Creates a Virtual Machine on DigitalOcean
2. Configures SSH key authentication
3. Sets up IP-whitelisted firewall rules
4. Installs Docker via Cloud-Init
5. Deploys Nginx inside a Docker container
6. Makes the server accessible from the internet

**Total deployment time: under 3 minutes** ⚡

---

## 🏗️ Architecture
```
Developer Machine (WSL2 Ubuntu)
         │
         │  terraform apply
         ▼
┌─────────────────────┐
│      Terraform       │
│  Infrastructure as   │
│       Code           │
└─────────┬───────────┘
          │
          │ DigitalOcean API
          ▼
┌─────────────────────────────────────┐
│         DigitalOcean Cloud          │
│                                     │
│  ┌─────────────────────────────┐   │
│  │      Cloud Firewall          │   │
│  │  ✅ SSH (22): Home IP only   │   │
│  │  ✅ HTTP (80): Home IP only  │   │
│  │  ✅ Outbound: All allowed    │   │
│  └──────────────┬──────────────┘   │
│                 │                   │
│  ┌──────────────▼──────────────┐   │
│  │     Ubuntu 22.04 Droplet    │   │
│  │                             │   │
│  │  ┌───────────────────────┐  │   │
│  │  │    Docker Engine      │  │   │
│  │  │  ┌─────────────────┐  │  │   │
│  │  │  │  Nginx Container │  │  │   │
│  │  │  │   Port 80:80     │  │  │   │
│  │  │  └─────────────────┘  │  │   │
│  │  └───────────────────────┘  │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

## ✨ Features

- 🤖 **Fully Automated** - One command deploys everything
- 🔒 **IP Whitelisting** - Only your home IP can access the server
- 🐳 **Containerized** - Nginx runs inside Docker
- 📝 **Infrastructure as Code** - Entire infrastructure in version control
- 💰 **Cost Optimized** - Uses smallest DigitalOcean droplet (~$6/month)
- 🔑 **SSH Key Auth** - No passwords, key-based authentication only
- 🧹 **Easy Cleanup** - One command destroys everything

---

## 📦 Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) v1.7.0+
- [DigitalOcean Account](https://www.digitalocean.com/) with API token
- SSH key pair generated
- WSL2 Ubuntu (Windows) or Linux/Mac terminal
- curl installed

---

## 📁 Project Structure
```
devops-nginx-project/
│
├── 📄 README.md                    # You are here!
├── 📄 .gitignore                   # Protects secrets from Git
│
├── 📂 terraform/
│   ├── main.tf                     # Core infrastructure config
│   ├── variables.tf                # Input variable definitions
│   ├── outputs.tf                  # Output values after deploy
│   ├── cloud-init.yaml             # Automated server setup script
│   └── terraform.tfvars            # Your values (gitignored)
│
└── 📂 scripts/
    ├── deploy.sh                   # One-click deployment
    └── destroy.sh                  # One-click cleanup
```

---

## ⚡ Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/danish07/devops-nginx-project.git
cd devops-nginx-project
```

### 2. Generate SSH Keys
```bash
ssh-keygen -t ed25519 -C "devops-project" -f ~/.ssh/digitalocean_key
chmod 600 ~/.ssh/digitalocean_key
```

### 3. Configure Your Variables
```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
# Edit terraform.tfvars with your values
```

### 4. Add Your API Token
```bash
mkdir -p secrets
echo "DO_TOKEN=your_token_here" > secrets/secrets.txt
```

### 5. Deploy! 🚀
```bash
bash scripts/deploy.sh
```

### 6. Visit Your Server
```
http://YOUR_DROPLET_IP
```

---

## 🔒 Security

This project implements several security best practices:

| Feature | Implementation |
|---------|---------------|
| SSH Authentication | Ed25519 key pairs only |
| Firewall | IP whitelist - only home IP allowed |
| Secrets Management | API tokens never committed to Git |
| Port Access | Only ports 22 and 80 open |
| Container Isolation | Nginx runs in Docker container |

### ⚠️ Never commit these files:
- `terraform/terraform.tfvars` (contains your IP)
- `secrets/secrets.txt` (contains API token)
- `~/.ssh/digitalocean_key` (private key)

---

## ⚙️ How It Works

### 1. Terraform Creates Infrastructure
```hcl
# Creates VM, uploads SSH key, configures firewall
terraform apply
```

### 2. Cloud-Init Configures the Server
On first boot, the server automatically:
- Updates all packages
- Installs Docker
- Pulls Nginx image
- Starts Nginx container on port 80

### 3. Firewall Protects Everything
Only your home IP can reach the server:
```
Inbound: SSH (22) → Your IP only
Inbound: HTTP (80) → Your IP only
Outbound: All → Allowed
```

---

## 🧹 Cleanup

Destroy all resources with one command:
```bash
bash scripts/destroy.sh
```

This removes:
- DigitalOcean Droplet
- Cloud Firewall
- SSH Key

**No hidden charges after destroy!** 💰

---

## 🎓 What I Learned

Building this project taught me:

- **Linux** - Command line navigation, file permissions, bash scripting
- **Git** - Version control, .gitignore, meaningful commits
- **SSH** - Key generation, secure authentication, file permissions
- **Terraform** - Infrastructure as Code, providers, state management
- **Cloud Computing** - VMs, firewalls, networking, APIs
- **Docker** - Containers, images, port mapping
- **Nginx** - Web servers, reverse proxies
- **Cloud-Init** - Automated VM configuration
- **Security** - IP whitelisting, least privilege, secrets management
- **DevOps** - Automation, IaC, deployment pipelines

---

## 📚 Resources

- [Terraform Docs](https://developer.hashicorp.com/terraform/docs)
- [DigitalOcean Docs](https://docs.digitalocean.com/)
- [Docker Docs](https://docs.docker.com/)
- [Nginx Docs](https://nginx.org/en/docs/)
- [Cloud-Init Docs](https://cloudinit.readthedocs.io/)

---

## 👨‍💻 Author

**Danish** - [@danish07](https://github.com/danish07)

*Built as part of a DevOps learning journey - from zero command line experience to production-grade cloud infrastructure!*

---

⭐ **If you found this helpful, please star the repository!**
