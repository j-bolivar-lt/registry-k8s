.PHONY: install run stop uninstall loadtest

install:
	helm repo add twuni https://helm.twun.io
	helm repo update
	kubectl create namespace docker-registry
	helm install docker-registry twuni/docker-registry --namespace docker-registry

run:
	sleep 3
	nohup kubectl port-forward $$(kubectl get pods --namespace docker-registry -l "app=docker-registry,release=docker-registry" -o jsonpath="{.items[0].metadata.name}") 8080:5000 --namespace docker-registry &

stop:
	kill $$(ps aux | grep 'kubectl port-forward' | awk '{print $$2}')

uninstall:
	helm uninstall docker-registry --namespace docker-registry
	kubectl delete namespace docker-registry

loadtest:
	docker pull ubuntu:latest
	poetry run locust -f load_test.py --host=https://$$(awk -F "=" '/^username/ {print $$2}' config.ini):$$(awk -F "=" '/^password/ {print $$2}' config.ini)@$$(awk -F "=" '/^host/ {print $$2}' config.ini)

