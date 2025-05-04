# Kubernetes Lab Guide


---

## 🧹 Cleaning Up and Rebuilding the Lab

### ✅ Verify Cleanup
After running:
```bash
make clean
```

Run:
```bash
kubectl get nodes
```

❌ You should see an error like "No resources found" — meaning the lab was successfully destroyed.


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

You now have a repeatable lab cycle: **deploy → test → destroy → rebuild**.


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
