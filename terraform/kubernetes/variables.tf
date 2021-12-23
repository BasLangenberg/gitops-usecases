variable "token" {
    description = "the token required to authenticate to the cluster"
    type = string
}

variable "ca_certificate" {
    description = "the clusters ca_certificate, base64decoded"
    type = string
}

variable "endpoint" {
    description = "the endpoint the cluster is listening on"
    type = string
}