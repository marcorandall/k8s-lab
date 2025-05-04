
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-bsides-training"
}

resource "kubernetes_namespace" "demo" {
  metadata {
    name = "demo"
  }
}
