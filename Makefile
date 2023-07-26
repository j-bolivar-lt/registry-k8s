.PHONY: install run stop uninstall loadtest

install-registry:
	helm repo add twuni https://helm.twun.io
	helm repo update
	kubectl create namespace docker-registry
	helm install docker-registry twuni/docker-registry --namespace docker-registry


install-dragonfly:
	helm repo add dragonfly https://dragonflyoss.github.io/helm-charts/
	helm install --create-namespace --namespace dragonfly-system dragonfly dragonfly/dragonfly -f dragonfly/values.yaml
	#kubectl -n dragonfly-system wait --for=condition=ready --all --timeout=10m pod

uninstall-dragonfly:
	helm uninstall dragonfly --namespace dragonfly-system
	kubectl delete namespace dragonfly-system


run-registry:
	sleep 3
	nohup kubectl port-forward $$(kubectl get pods --namespace docker-registry -l "app=docker-registry,release=docker-registry" -o jsonpath="{.items[0].metadata.name}") 8080:5000 --namespace docker-registry &

stop-registry:
	kill $$(ps aux | grep 'kubectl port-forward' | awk '{print $$2}')

uninstall-registry:
	helm uninstall docker-registry --namespace docker-registry
	kubectl delete namespace docker-registry

loadtest:
	docker pull ubuntu:latest
	cd docker-registry && poetry install && poetry run locust -f load_test_registry.py --host=https://$$(awk -F "=" '/^username/ {print $$2}' config.ini):$$(awk -F "=" '/^password/ {print $$2}' config.ini)@$$(awk -F "=" '/^host/ {print $$2}' config.ini)


install-minio:
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm install --create-namespace --namespace minio minio bitnami/minio -f docker-registry-minio/values.yml
	kubectl -n minio wait --for=condition=ready --all --timeout=10m pod

uninstall-minio:
	helm uninstall minio --namespace minio
	kubectl delete namespace minio

build:
	docker build -t jbolivarlt/python_kubernetes .

push: build
	docker push jbolivarlt/python_kubernetes
