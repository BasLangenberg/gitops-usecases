.PHONY: init provision destroy apply

provision: init-infra apply-infra k8s-resources

init-infra:
	cd terraform/infrastructure && terraform init

apply-infra:
	cd terraform/infrastructure && terraform apply --auto-approve

k8s-resources:
	doctl kubernetes cluster kubeconfig save k8s-mgmt
	kustomize build kubernetes/ingress-nginx/overlay/mgmt | kubectl apply -f -
	sleep 30
	kubectl apply -f kubernetes/argocd/namespace.yaml
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml	
	sleep 30
	kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml

destroy:
	cd terraform/infrastructure && terraform destroy --auto-approve

.DEFAULT_GOAL := provision
