.PHONY: init provision destroy apply

provision: init-infra apply-infra init-k8s apply-k8s k8s-resources tkn-tasks

init-infra:
	cd terraform/infrastructure && terraform init

apply-infra:
	cd terraform/infrastructure && terraform apply --auto-approve

init-k8s:
	cd terraform/kubernetes && terraform init

apply-k8s:
	cd terraform/kubernetes && terraform apply --auto-approve

k8s-resources:
	doctl kubernetes cluster kubeconfig save k8s-mgmt
	kustomize build kubernetes/ingress-nginx/overlay/mgmt | kubectl apply -f -
	sleep 30
	kubectl apply -f kubernetes/argocd/namespace.yaml
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml	
	sleep 30
	kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
	kubectl create configmap config-artifact-pvc --from-literal=size=10Gi --from-literal=storageClassName=manual -o yaml -n tekton-pipelines --dry-run=true | kubectl replace -f -

tkn-tasks:
	kubectl apply -f tekton/git-clone-task.yaml
	kubectl apply -f tekton/kaniko-task.yaml
	kubectl apply -f tekton/pipeline.yaml
	kubectl apply -f tekton/serviceaccount.yaml

build:
	kubectl create -f tekton/pipelinerun.yaml

destroy:
	cd terraform/infrastructure && terraform destroy --auto-approve

argo-pass:
	kubectl -n argocd get secrets argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d

argo-demo-app:
	argocd app create 2048-game-app --repo https://github.com/BasLangenberg/tekton-pipeline-example-app --path kustomize --dest-server https://kubernetes.default.svc --dest-namespace default --sync-option CreateNamespace=false

.DEFAULT_GOAL := provision
