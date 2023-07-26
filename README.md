
# Docker-Registry Benchmarking Suite

This project aims to provide a benchmarking suite for Docker-Registry and other registry implementations like Dragonfly. We set up the registry instances using Helm charts in an external Kubernetes cluster and perform a series of stress tests to analyze their robustness and performance under various scenarios.

## Objectives

The primary objectives of this project are:

- To create a reliable benchmarking system for Docker-Registry and other similar tools.
- To perform comparative analyses of different registry implementations.
- To evaluate performance under different load conditions and identify potential bottlenecks.
- To provide an easy-to-use framework that others can utilize to test their registry setups.

## Pre-requisites

- Helm, v3.0+
- Kubernetes cluster, v1.18+
- kubectl, v1.18+
- Docker
- Python (with `locust` and `poetry` installed)
- A `config.ini` file with registry details and credentials

## Getting Started

1. Clone this repository to your local machine.
```bash
git clone <repository-url>
```

2. Change into the directory of the project.
```bash
cd <directory-name>
```

3. Create a `config.ini` file in the root directory of the project with the following structure:

```ini
[credentials]
username=
password=
host=
```

Replace the `username`, `password`, and `host` values with your actual Docker registry credentials and host. These will be used by the benchmarking scripts to interact with your registry.

## Makefile Targets

This project uses a Makefile for managing deployments and performing benchmarks. The main targets are:

- **install:** Installs Docker-Registry in your Kubernetes cluster using the Helm chart. It adds the Helm repo, updates it, creates a new namespace called 'docker-registry', and deploys the Docker-Registry chart into this namespace.
```bash
make install
```

- **run:** Runs the Docker-Registry by setting up a port-forward from local port 8080 to port 5000 on the Docker-Registry pod.
```bash
make run
```

- **stop:** Stops the port-forwarding setup by the `run` command.
```bash
make stop
```

- **uninstall:** Uninstalls the Docker-Registry Helm release and deletes the 'docker-registry' namespace.
```bash
make uninstall
```

- **loadtest:** Runs a load test against your Docker-Registry using `locust`. It first pulls the 'ubuntu:latest' image from Docker Hub, and then starts the benchmark, pointing `locust` to your Docker registry host as specified in your `config.ini` file.
```bash
make loadtest
```

---

Remember to replace `<repository-url>` and `<directory-name>` with your actual repository URL and directory name, respectively.
