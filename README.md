# Docker-Registry Helm Deployment

This project sets up Docker-Registry using a Helm chart in an external Kubernetes cluster and runs some stress tests to ensure its robustness. 

## Pre-requisites

- Helm, v3.0+
- Kubernetes cluster, v1.18+
- kubectl, v1.18+

## Getting Started

1. Clone this repository to your local machine.
```bash
git clone <repository-url>
```

2. Change into the directory of the project.
```bash
cd <directory-name>
```

## Makefile Targets

This project uses a Makefile for managing deployments. The main targets are:

- **install:** To install Docker-Registry using the Helm chart.
```bash
make install
```

- **run:** To run the Docker-Registry.
```bash
make run
```

- **uninstall:** To uninstall the Docker-Registry and delete the namespace.
```bash
make uninstall
```

