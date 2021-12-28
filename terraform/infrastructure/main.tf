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
### We create it here so it can be queried later,
### All config is left to the ingress controller!
resource "digitalocean_loadbalancer" "mgmt" {
  name   = "lb-mgmt"
  region = "ams3"
  forwarding_rule {
          entry_port       = 443
          entry_protocol   = "https"
          target_port      = 443
          target_protocol  = "https"
          tls_passthrough  = true
        }
}

## DNS Setup
data "digitalocean_domain" "homecooked" {
  name = "homecooked.nl"
}

resource "digitalocean_record" "argo" {
  domain = data.digitalocean_domain.homecooked.name
  type   = "A"
  name   = "argo"
  value  = digitalocean_loadbalancer.mgmt.ip
}

# Create development cluster
# Create production clusterresource