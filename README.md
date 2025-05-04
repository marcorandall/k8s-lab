# 🧪 Kubernetes Lab with Optional Terraform and Ansible Integrations

This project sets up a local Kubernetes lab using Kind, and optionally integrates Terraform and Ansible for managing resources.

---

## 🧩 Optional Tasks: Integrate Terraform and Ansible Locally

These optional tasks allow you to manage your local Kind-based Kubernetes lab using Terraform and Ansible.

---

### ⚙️ Terraform Integration

**Use Case**: Manage Kubernetes resources (e.g., namespaces, deployments) directly with Terraform.

<details>
<summary><strong>📝 Example: Create a Namespace with Terraform</strong></summary>

**1. Install Terraform**  
[Download Terraform](https://developer.hashicorp.com/terraform/downloads)

**2. Create a file named `main.tf`**:
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

**3. Initialize and Apply**:
```bash
terraform init
terraform apply
```

</details>

---

### ⚙️ Ansible Integration

**Use Case**: Apply Kubernetes manifests, manage objects, or run commands in containers.

<details>
<summary><strong>📝 Example: Create a Namespace with Ansible</strong></summary>

**1. Install Ansible**:
```bash
sudo apt install ansible
ansible-galaxy collection install kubernetes.core
```

**2. Create a `playbook.yml`**:
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

**3. Run the playbook**:
```bash
ansible-playbook playbook.yml
```

</details>
