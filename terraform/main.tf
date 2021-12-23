module "infrastructure" {
    source = "./infrastructure"
}

module "kubernetes" {
    source = "./kubernetes"
    endpoint = module.infrastructure.mgmt_k8s_endpoint
    token = module.infrastructure.mgmt_k8s_token
    ca_certificate = module.infrastructure.mgmt_k8s_ca_certificate
}