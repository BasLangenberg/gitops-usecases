.PHONY: init provision destroy apply

provision: init-infra apply-infra k8s-resources

init-infra:
	cd terraform/infrastructure && terraform init

apply-infra:
	cd terraform/infrastructure && terraform apply --auto-approve

k8s-resources:
	doctl kubernetes cluster kubeconfig save k8s-mgmt
	kustomize build kubernetes/ingress-nginx/overlay/mgmt | kubectl apply -f -
	kubectl apply -f kubernetes/argocd/namespace.yaml
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

destroy:
	cd terraform/infrastructure && terraform destroy --auto-approve

.DEFAULT_GOAL := provision
