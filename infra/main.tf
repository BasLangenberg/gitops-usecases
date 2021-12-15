# Create private docker repository
# Create management cluster
resource "digitalocean_kubernetes_cluster" "mgmt" {
  name    = "mgmt"
  region  = "ams3"
  version = "1.21.5-do.0"

  node_pool {
    name       = "autoscale-worker-pool"
    size       = "s-2vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 5
  }
}

# Create development cluster
# Create production cluster