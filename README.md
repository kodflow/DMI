# Dockerfiles Minimal Images

This repository contains a set of secure Dockerfiles to facilitate the deployment of applications in containerized environments. 
The provided Dockerfiles are designed with security best practices in mind to minimize potential vulnerabilities and ensure safe usage.

## Prerequisites

Before using the Dockerfiles in this repository, make sure the following items are installed on your system:

- Docker Engine: [Install Docker Engine](https://docs.docker.com/engine/install/)
- Docker Compose: [Install Docker Compose](https://docs.docker.com/compose/install/)

## Repository Structure

The repository is organized as follows:
```text
├── core
	└── CORE_NAME
		├── dockerfile
		└── context
└── service
	└── SERVICE_NAME
		├── dockerfile
		└── context
```
## Contributions
Contributions to this repository are welcome! If you have any improvements to the existing Dockerfiles or want to add new secure Dockerfiles, please submit a pull request. Please follow security best practices while contributing to maintain code quality and security.

## Disclaimer
Please note that while these Dockerfiles are designed with security best practices, it is always recommended to perform a proper evaluation of your environment and configuration before deploying containers in production. The authors of this repository are not responsible for any security issues or damages caused by improper use of these Dockerfiles.