# Scalable Kubernetes infrastructure with ArgoCD

This repository is used to store a learning project, with the following objectives / goals as an outline

- Run an 'orchestrator' cluster, hosting ArgoCD. This will support other 'application' Kubernetes clusters
- Run a development application cluster, automatically picking up 'system' deployments, e.g. monitoring components, Ingress controllers
- Run a production application cluster, automatically picking up 'system' deployments, e.g. monitoring components, Ingress controllers
- Within ArgoCD, setup the application deployment
  - Multiple services composing a single app
  - Build on K8S with Tekton
  - Deploy to development automatically
  - Deploy to production after approval
  - Due to dependencies between services, ArgoCD should rollout new versions of the application in stages

Deliverables: Working usecase in this repository, blog posts. Bonus points for a (YouTube) video.
