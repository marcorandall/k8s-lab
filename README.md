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

---

### For Windows (WSL2 with Ubuntu):

1. Install WSL2:
```powershell
wsl --install
```

2. Install Docker Desktop and enable WSL2 integration.

3. In Ubuntu shell:
```bash
sudo apt update && sudo apt install -y curl docker.io
sudo usermod -aG docker $USER
newgrp docker
```

4. Install kubectl:
```bash
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin/
```

5. Install Kind:
```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind
```

# 🧪 Kubernetes Lab Setup for Beginners (Kind-based)

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