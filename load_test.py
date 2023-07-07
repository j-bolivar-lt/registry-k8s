
import configparser
import subprocess
import time
from locust import User, task

config = configparser.ConfigParser()
config.read('config.ini')
registry_host = config.get('credentials', 'host')
registry_host = registry_host.split("//")[-1]

class DockerUser(User):

    @task
    def pull_image(self):
        image = f'{registry_host}/ubuntu:latest'
        start_time = time.time()
        subprocess.check_output(['docker', 'pull', image])
        total_time = int((time.time() - start_time) * 1000)  # converting to milliseconds
        self.environment.events.request.fire(
            request_type='DOCKER PULL',
            name=image,
            response_time=total_time,
            response_length=0,
        )

    @task
    def push_image(self):
        local_image = 'ubuntu:latest'
        remote_image = f'{registry_host}/ubuntu:latest'
        start_time = time.time()
        subprocess.check_output(['docker', 'tag', local_image, remote_image])
        subprocess.check_output(['docker', 'push', remote_image])
        total_time = int((time.time() - start_time) * 1000)  # converting to milliseconds
        self.environment.events.request.fire(
            request_type='DOCKER PUSH',
            name=remote_image,
            response_time=total_time,
            response_length=0,
        )

