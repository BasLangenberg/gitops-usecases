
output "mgmt_k8s_token" {
  value = digitalocean_kubernetes_cluster.mgmt.kube_config[0].token
}

output "mgmt_k8s_endpoint" {
  value = digitalocean_kubernetes_cluster.mgmt.endpoint
}

output "mgmt_k8s_ca_certificate" {
  value = base64decode(digitalocean_kubernetes_cluster.mgmt.kube_config[0].cluster_ca_certificate)
}