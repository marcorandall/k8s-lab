
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

## 🤖 GitHub Actions CI (Optional)

Located in `.github/workflows/ci.yml`, this action:
- Validates Terraform (`fmt`, `validate`)
- Installs and lints Ansible

---

## 🗺️ Visual: Kubernetes Lab Flow

![Kubernetes Lab Setup Flowchart](./A_flowchart_in_the_digital_2D_illustration_visuall.png)
