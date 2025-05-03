
# 🧪 Kubernetes Lab Setup for Beginners (Kind-based)

This guide will help you set up a Kubernetes lab on your **laptop** using **Kind** (Kubernetes in Docker). It includes instructions for **Windows (with WSL2)**, **macOS**, and **Linux** systems.

---

## ✅ System Requirements

- OS:
  - Windows 10 or 11 with WSL2
  - macOS
  - Linux (Ubuntu/Debian recommended)
- RAM: 8GB minimum
- CPU: 4+ cores
- Internet access

---

# ⚙️ Part 1: Setup for Windows Users (WSL2)

## 🪟 Step 1: Install WSL2

Open PowerShell as Administrator:
```powershell
wsl --install
```
Reboot if prompted. Ubuntu will install by default.

---

## 🐳 Step 2: Install Docker Desktop for Windows

Download and install from: https://www.docker.com/products/docker-desktop/

- Enable **WSL2 integration** in Docker settings
- Ensure your Ubuntu distro is selected under "Resources > WSL Integration"

---

## 🧰 Step 3: Install Tools in Ubuntu Terminal

Open Ubuntu (WSL) and run:
```bash
sudo apt update && sudo apt install -y curl docker.io
sudo usermod -aG docker $USER
newgrp docker  # or close and reopen the terminal
```

Install kubectl:
```bash
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin/
```

Install Kind:
```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind
```

---

# 🐧 Part 2: Setup for Linux/macOS Users

## 🐳 Step 1: Install Docker

### Linux:
```bash
sudo apt update
sudo apt install docker.io -y
sudo systemctl enable docker --now
sudo usermod -aG docker $USER
```

### macOS:
Install Docker Desktop from https://www.docker.com/products/docker-desktop/

---

## 🧰 Step 2: Install kubectl and Kind

Install kubectl:
```bash
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/$(uname | tr '[:upper:]' '[:lower:]')/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

Install Kind:
```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-$(uname)-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

---

# 🚀 Part 3: Kubernetes Lab Setup (Same for All OS)

## 🌱 Step 1: Create Cluster
```bash
kind create cluster --name k8s-lab
```

## 🔍 Step 2: Verify Cluster
```bash
kubectl cluster-info --context kind-k8s-lab
kubectl get nodes
```

## 🌐 Step 3: Deploy Sample App (NGINX)
```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=NodePort
kubectl get svc
```

Visit: http://localhost:<NodePort> (e.g., 30000)

---

## 📺 Step 4: Optional Dashboard (K9s)

### macOS:
```bash
brew install k9s
```

### Linux:
```bash
sudo snap install k9s
```

Or download from: https://github.com/derailed/k9s/releases

Run:
```bash
k9s
```

---

## 🧹 Step 5: Clean Up
```bash
kind delete cluster --name k8s-lab
```

---

## 📝 Summary Table

| Step | Action                                | Tool        |
|------|----------------------------------------|-------------|
| 1    | Install Docker                         | docker      |
| 2    | Install kubectl                        | kubectl     |
| 3    | Install Kind                           | kind        |
| 4    | Create a cluster                       | kind        |
| 5    | Deploy NGINX app                       | kubectl     |
| 6    | View with browser or K9s               | NodePort    |
| 7    | Delete cluster when done               | kind        |

---

# 📺 Part 4: Optional Kubernetes Dashboards

## 🧮 Option 1: K9s (Terminal-Based Dashboard)

### ✅ Works on:
- Linux
- macOS
- Windows (via WSL2 or Git Bash)

### 🔧 Install on WSL2 Ubuntu:
```bash
curl -LO https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz
tar -xzf k9s_Linux_amd64.tar.gz
sudo mv k9s /usr/local/bin/
```

### ▶️ Run:
```bash
k9s
```

---

## 🧑‍💻 Option 2: Kubernetes Web Dashboard

### ✅ Works on:
- Linux
- macOS
- Windows (Docker Desktop or WSL2)

### 🔧 Deploy the Dashboard:
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

### 🔐 Start Proxy:
```bash
kubectl proxy
```

### 🌐 Open in browser:
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

---

> For Docker Desktop users on Windows, make sure Kubernetes is enabled in Docker Desktop settings and your context is set to `docker-desktop`.

---

## ✅ Summary of Dashboard Support

| Dashboard Type       | WSL2 + Kind | Docker Desktop Only | Native Windows CLI |
|----------------------|-------------|----------------------|---------------------|
| K9s (terminal)       | ✅ Yes      | ⚠️ With Git Bash     | ❌ Not directly     |
| Web Dashboard        | ✅ Yes      | ✅ Yes               | ✅ Yes (if kubectl works) |
