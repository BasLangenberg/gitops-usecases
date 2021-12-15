.PHONY: init provision destroy apply

provision: init apply

init:
	cd infra && terraform init

apply:
	cd infra && terraform apply --auto-approve

destroy:
	cd infra && terraform destroy --auto-approve

.DEFAULT_GOAL := provision