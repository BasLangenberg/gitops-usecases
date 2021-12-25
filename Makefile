.PHONY: init provision destroy apply

provision: init-infra apply-infra init-k8s apply-k8s

init-infra:
	cd terraform/infrastructure && terraform init

init-k8s:
	cd terraform/kubernetes && terraform init

apply-infra:
	cd terraform/infrastructure && terraform apply --auto-approve

apply-k8s:
	cd terraform/kubernetes && terraform apply --auto-approve

destroy:
	cd terraform/kubernetes && terraform destroy --auto-approve
	cd terraform/infrastructure && terraform destroy --auto-approve

.DEFAULT_GOAL := provision
