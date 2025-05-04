# Kubernetes Lab Guide


---

## 🧹 Cleaning Up and Rebuilding the Lab

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
