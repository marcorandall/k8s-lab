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

## 🐳 Docker + Tools Installation

### For Linux/macOS:

```bash
sudo apt update
sudo apt install docker.io -y
sudo systemctl enable docker --now
sudo usermod -aG docker $USER
```

```bash
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/$(uname | tr '[:upper:]' '[:lower:]')/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-$(uname)-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
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


# 🧪 Kubernetes Lab: Local Cluster + App Deployments

This guide walks you through setting up a Kubernetes lab using Kind, deploying apps (NGINX and Flask), validating them, and optionally managing resources with Terraform and Ansible.

---

## ✅ Prerequisites

- Docker installed
- Kind installed (`kind`)
- kubectl installed
- Optional: Terraform, Ansible, and Make

---

## 🌱 Step 1: Create the Cluster

```bash
kind create cluster --name bsides-training --config - <<EOF 
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 30080
        hostPort: 30080
        protocol: TCP
  - role: worker
  - role: worker
EOF
```

### ✅ Verify Cluster
```bash
kubectl get nodes
```
You should see 3 nodes (1 control-plane, 2 workers).

---

## 🌐 Step 2: Deploy NGINX Web Server

```bash
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
            - containerPort: 80
EOF
```

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30080
EOF
```

### ✅ Verify NGINX
```bash
kubectl get pods -l app=nginx
kubectl get svc nginx-service
curl http://localhost:30080
```

---

## 🧪 Step 3: Deploy Flask App

```bash
make flask
```

### ✅ Verify Flask App
```bash
kubectl get pods -l app=flask-app
kubectl get svc flask-service
curl http://localhost:30081
```

---

## 🧹 Step 4: Clean and Rebuild the Lab

To clean:
```bash
make clean
```

To rebuild:
```bash
make rebuild
```

### ✅ Verify Cleanup
```bash
kubectl get nodes
```
Should return an error or “no resources found.”

---

To **destroy** the Kubernetes lab created with Kind and start fresh:

### 🗑️ Delete the Kind Cluster
```bash
kind delete cluster --name bsides-training
```

This will:
- Stop and remove the cluster's Docker containers
- Clean up kubeconfig context entries
- Free up host ports (e.g., 30080)

---

### 🧼 Optional: Clean Docker Resources
```bash
docker system prune -f
```

This removes unused containers, images, networks, and volumes.

---

### 🔁 Rebuild the Lab

You can re-deploy everything with:

```bash
bash scripts/deploy_bsides_lab.sh
```

Or if using the Makefile:

```bash
make deploy
```


---

## 🗺️ Visual: Kubernetes Lab Setup Flow

This diagram shows the high-level steps involved in setting up your local Kubernetes lab.

![Kubernetes Lab Setup Flowchart](./A_flowchart_in_the_digital_2D_illustration_visuall.png)

---

## 🧪 Optional: Add a Functional Container (Flask App)

### ✅ Verify Flask App
```bash
kubectl get pods -l app=flask-app
kubectl get svc flask-service
```
✅ Flask pod should be Running and service should be exposed on NodePort 30081

```bash
curl http://localhost:30081
```
✅ You should see a "Hello World" response.


You can deploy a simple Python-based Flask application to test app functionality inside your Kind cluster.

### 📝 Manifest: `manifests/flask-app.yaml`

This manifest deploys a prebuilt Flask container and exposes it on port 30081.

### ▶️ Deploy the App

```bash
make flask
```

Then open:

```
http://localhost:30081
```

You should see a basic Flask web app served from your cluster.

---

## ✅ Lab Verification Steps

Use these steps to confirm your Kubernetes lab is set up correctly.

### 🔧 1. Verify Cluster Is Running
```bash
kubectl get nodes
```
✅ Expected: 3 nodes (1 control-plane, 2 workers)

---

### 🌐 2. Verify NGINX Deployment
```bash
kubectl get pods -l app=nginx
kubectl get svc nginx-service
```
✅ Pod should be `Running`, and service should expose NodePort `30080`

```bash
curl http://localhost:30080
```
✅ Should return NGINX welcome HTML

---

### 🧪 3. Verify Flask App
```bash
kubectl get pods -l app=flask-app
kubectl get svc flask-service
```
✅ Pod should be `Running`, and service on NodePort `30081`

```bash
curl http://localhost:30081
```
✅ Should return Flask Hello World response

---

### 🛠 4. Verify Clean/Delete
```bash
make clean
```
Then:
```bash
kubectl get nodes
```
❌ Should return error or no cluster found

## 🧩 Optional: Manage Resources with Terraform

```hcl
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-bsides-training"
}

resource "kubernetes_namespace" "demo" {
  metadata {
    name = "demo"
  }
}
```

```bash
cd terraform
terraform init
terraform apply
```

---

## 🧩 Optional: Manage Resources with Ansible

```yaml
- name: Deploy to Kind cluster
  hosts: localhost
  gather_facts: no
  tasks:
    - name: Create namespace
      kubernetes.core.k8s:
        kubeconfig: ~/.kube/config
        context: kind-bsides-training
        definition:
          apiVersion: v1
          kind: Namespace
          metadata:
            name: demo
```

```bash
cd ansible
ansible-playbook playbook.yml
```

---

## 🗺️ Visual: Kubernetes Lab Flow

![Kubernetes Lab Setup Flowchart](./A_flowchart_in_the_digital_2D_illustration_visuall.png)
