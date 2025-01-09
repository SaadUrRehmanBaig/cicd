# CI/CD Pipeline with Gitea, Docker, and Kubernetes on Vagrant

This project demonstrates a complete CI/CD pipeline setup using a self-hosted Gitea server and Gitea runner to automate the build, deployment, and Kubernetes management process. The entire setup, including the Gitea server and Kubernetes cluster, is hosted on Vagrant virtual machines.

## Project Overview

1. **Gitea Server Setup**: A self-hosted Gitea server is provisioned on a Vagrant machine.
2. **Gitea Runner Setup**: A Gitea runner is installed and configured on the same Vagrant machine. The runner details are present in the `provision.sh` file.
3. **Repository Setup**: The project repository is uploaded to the Gitea server.
4. **Secrets and Variables**: Secrets and environment variables are added to the Gitea repository for secure access during the pipeline execution.
5. **Workflow Configuration**: The CI/CD pipeline is defined in a `deploy.yaml` file located in the `.gitea/workflows` directory.
6. **Docker Image Build and Publish**: The pipeline builds a Docker image and publishes it to a container registry.
7. **Kubernetes Deployment**: The `deployment.sh` script updates Kubernetes secrets and config maps, then deploys the application on a locally hosted Kubernetes cluster.

## Project Structure

```plaintext
├── gitea/         # Shell script for provisioning Gitea server and runner
    ├── provision.sh
    └── Vagrantfile
├── kubernetes/         # Shell script for provisioning kubernestes server
    └── Vagrantfile 
├── repository/
    ├── backend/
        └── resourses/
            └── deployment.sh
            └── secrets.yaml
            └── deployment-services.yaml
    ├── .gitea/
        └── workflows/
            └── deploy.yaml   # Gitea workflow configuration file
```

## Setting Up the Gitea Server and Runner

1. Clone this repository to your local machine.
2. move to gitea folder and Run the following command to start the Vagrant machine:
   ```bash
   vagrant up
   ```
3. The `provision.sh` script will automatically set up the Gitea server and docker on the Vagrant machine.
4. Access the machine by `vagrant ssh` command and run the docker command for runner provide in provision.sh by changing token from gitea server.
5. Access the Gitea server at `http://192.168.33.102:3000`.

## Repository and Secrets Configuration

1. After accessing the Gitea server, create a new repository and upload your project files.
2. Navigate to the repository settings and add necessary secrets and variables.

## CI/CD Workflow Configuration

1. Add the `deploy.yaml` file to your repository under the `.gitea/workflows/` directory.
2. The `deploy.yaml` file contains steps to:
   - Build a Docker image
   - Publish the image to a container registry
   - Run `deployment.sh` to update secrets and config maps
   - Deploy the application to a Kubernetes cluster
 
## Kubernetes Setup on Vagrant

1. move to kubernetes folder and Run the following command to start the Vagrant machine:
   ```bash
   vagrant up
   ```
2. Access the machine by `vagrant ssh` command and get the k3s.yml file to base 64 by running `cat /etc/rancher/k3/k3s.yml | base64`.
4. copy the output in secrets of gitea under `KUBECONFIG`.


## Running the CI/CD Pipeline

1. Push your changes to the Gitea repository.
2. The Gitea runner will automatically trigger the pipeline defined in `deploy.yaml`.
3. Monitor the pipeline execution through the Gitea web interface.

## Workflow Example (`deploy.yaml`)

```yaml
name: Deploy Application
on:
  push:
    branches:
      - main
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Build Docker image
        run: |
          docker build -t my-app:latest .

      - name: Publish Docker image
        run: |
          docker tag my-app:latest registry.local/my-app:latest
          docker push registry.local/my-app:latest

      - name: Deploy to Kubernetes
        run: |
          chmod +x deployment.sh
          ./deployment.sh
```

## Summary

This project showcases a fully automated CI/CD pipeline using a self-hosted Gitea server and runner on Vagrant machines. The pipeline builds and publishes Docker images, updates Kubernetes secrets and config maps, and deploys the application to a locally hosted Kubernetes cluster. The setup is designed to be easily reproducible and scalable for various projects.

