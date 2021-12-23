.PHONY: init provision destroy apply

provision: init apply

init:
	cd terraform && terraform init

apply:
	cd terraform && terraform apply --auto-approve

destroy:
	cd terraform && terraform destroy --auto-approve

.DEFAULT_GOAL := provision
