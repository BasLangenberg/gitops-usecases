# Scalable Kubernetes infrastructure with ArgoCD

[![DigitalOcean Referral Badge](https://web-platforms.sfo2.digitaloceanspaces.com/WWW/Badge%202.svg)](https://www.digitalocean.com/?refcode=6ea9fd9553be&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

This repository is used to store a learning project, with the following objectives / goals as an outline

- Run an 'management' cluster, hosting ArgoCD. This will support other 'application' Kubernetes clusters by provinding centralized infrastructure services
- Run a development application cluster, automatically picking up 'system' deployments, e.g. monitoring components, Ingress controllers
- Run a production application cluster, automatically picking up 'system' deployments, e.g. monitoring components, Ingress controllers
- Within ArgoCD, setup the application deployment
  - Multiple services composing a single app
  - Build on K8S with Tekton
  - Deploy to development automatically
  - Deploy to production after approval
  - Due to dependencies between services, ArgoCD should rollout new versions of the application in stages

Deliverables: Working usecase in this repository, blog posts. Bonus points for a (YouTube) video.

## Requirements

Tested on Ubuntu 20.04 in WSL

Requirements:

- A [DigitalOcean](https://www.digitalocean.com/) account
  - Using [this link](https://m.do.co/c/6ea9fd9553be) will give you 100 dollars of credit, which you can use to test the service for two months
  - If you spent 25 dollars with them, I'll get 25 dollars in credit as well, without it costing you anything extra
- [Terraform 1.1](https://terraform.io)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Kustomize](https://kubernetes.io/docs/tasks/tools/)
- [doctl](https://github.com/digitalocean/doctl)
- [argocd client tools](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
- A domain, setup in DigitalOcean for DNS

## How to use?

Export DIGITALOCEAN_TOKEN, run ```make```

You need to make some changes. This repo expects a domain is already setup, which is my own domain (homecooked.nl) in this case. This is required fot 

## References

https://medium.com/dzerolabs/using-tekton-and-argocd-to-set-up-a-kubernetes-native-build-release-pipeline-cf4f4d9972b0

https://www.youtube.com/watch?v=7mvrpxz_BfE

https://ibm.github.io/tekton-tutorial-openshift/lab1

https://github.com/digitalocean/csi-digitalocean/blob/master/examples/kubernetes/pod-single-existing-volume/README.md