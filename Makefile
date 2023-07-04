.PHONY: install run uninstall

install:
	helm repo add stable https://charts.helm.sh/stable
	helm repo update
	kubectl create namespace docker-registry
	helm install docker-registry stable/docker-registry --namespace docker-registry

run:
	sleep 3	
	kubectl port-forward $$(kubectl get pods --namespace docker-registry -l "app=docker-registry,release=docker-registry" -o jsonpath="{.items[0].metadata.name}") 8080:5000 --namespace docker-registry

uninstall:
	helm uninstall docker-registry --namespace docker-registry
	kubectl delete namespace docker-registry


