# Without write = true, digitalocean will give you a pleasant afternoon,
# Wondering why your build pipelines fail 
resource "digitalocean_container_registry_docker_credentials" "bl-k8s" {
  registry_name = "bl-k8s"
  write = true
}

data "digitalocean_kubernetes_cluster" "mgmt" {
  name = "k8s-mgmt"
}

data "digitalocean_volume" "mgmt-pv" {
  name   = "mgmt-pv"
  region = "ams3"
}

provider "kubernetes" {
  host             = data.digitalocean_kubernetes_cluster.mgmt.endpoint
  token            = data.digitalocean_kubernetes_cluster.mgmt.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.mgmt.kube_config[0].cluster_ca_certificate
  )
}

resource "kubernetes_secret" "registry-secret" {
  metadata {
    name = "docker-cfg"
  }

  data = {
    ".dockerconfigjson" = digitalocean_container_registry_docker_credentials.bl-k8s.docker_credentials
    "config.json" = digitalocean_container_registry_docker_credentials.bl-k8s.docker_credentials
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_manifest" "persistentvolume_mgmt_k8s" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "PersistentVolume"
    "metadata" = {
      "annotations" = {
        "pv.kubernetes.io/provisioned-by" = "dobs.csi.digitalocean.com"
      }
      "name" = "mgmt-k8s"
    }
    "spec" = {
      "accessModes" = [
        "ReadWriteOnce",
      ]
      "capacity" = {
        "storage" = "5Gi"
      }
      "csi" = {
        "driver" = "dobs.csi.digitalocean.com"
        "fsType" = "ext4"
        "volumeAttributes" = {
          "com.digitalocean.csi/noformat" = "true"
        }
        "volumeHandle" = data.digitalocean_volume.mgmt-pv.id
      }
      "persistentVolumeReclaimPolicy" = "Delete"
      "storageClassName" = "do-block-storage"
    }
  }
}

resource "kubernetes_manifest" "persistentvolumeclaim_fakeservice_source_pvc" {
  depends_on = [
    kubernetes_manifest.persistentvolume_mgmt_k8s
  ]
  manifest = {
    "apiVersion" = "v1"
    "kind" = "PersistentVolumeClaim"
    "metadata" = {
      "name" = "fakeservice-source-pvc"
      "namespace" = "default"
    }
    "spec" = {
      "storageClassName" = "do-block-storage"
      "volumeName" = "mgmt-k8s"
      "accessModes" = [ 
        "ReadWriteOnce"
      ]
      "resources" = {
      "requests" ={
        "storage" = "5Gi"
      }
      }
    }
  }
}