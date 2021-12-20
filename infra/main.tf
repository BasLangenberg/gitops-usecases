# Create private docker repository

# Create management cluster resources

## Cluster
resource "digitalocean_kubernetes_cluster" "mgmt" {
  name    = "k8s-mgmt"
  region  = "ams3"
  version = "1.21.5-do.0"

  node_pool {
    name       = "autoscale-worker-pool"
    size       = "s-2vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 5
    tags = ["k8s-mgmt-nodes"]
  }
}

## Load Balancer
resource "digitalocean_loadbalancer" "mgmt" {
  name   = "lb-mgmt"
  region = "nyc3"

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 443
    target_protocol = "https"
    tls_passthrough = true
  }

  healthcheck {
    port     = 80
    path     = "/health"
    protocol = "http"
  }

  droplet_tag = "k8s-mgmt-nodes"
}

provider "kubernetes" {
  alias = "mgmt"
  host             = digitalocean_kubernetes_cluster.mgmt.endpoint
  token            = digitalocean_kubernetes_cluster.mgmt.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.mgmt.kube_config[0].cluster_ca_certificate
  )
}

resource "kubernetes_namespace" "argocd" {
  provider = kubernetes.mgmt
  metadata {
    name = "argocd"
  }
}
# Create development cluster
# Create production cluster