from locust import HttpUser, task, between

class DockerRegistryUser(HttpUser):
    wait_time = between(1, 2.5)

    @task
    def push_image(self):
        self.client.put("/v2/ubuntu/blobs/latest")

    @task
    def pull_image(self):
        self.client.get("/v2/ubuntu/manifests/latest")
