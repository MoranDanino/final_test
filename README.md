# final_test
## Devops Course final_test

Unfortunately, I didn't have time to make a README for each repository, I tried to be as clear as possible.

## terraform
- **`main.tf`** - Resources
- **`vars.tf`** - Variables
- **`outputs.tf`** - Outputs

## docker
- **`Dockerfile`** - Multistage Dockerfile
- **`not_final_app.py`** - The app with the bugs
- **`requirements.txt`** - The packages of the app

## python
- **`app.py`** - The fixed app
- **`requirements.txt`** - The packages of the app
- **`Dockerfile`** - Multistage Dockerfile (same as in Docker)

## jenkins
- **`Jenkinsfile`** - The pipeline
  ##### Docker Folder:
  - **`Dockerfile`** - Multistage Dockerfile
  - **`app.py`** - The fixed app
  - **`requirements.txt`** - The packages of the app

## azure
- **`azure-pipeline.yaml`** - The pipeline
  ##### docker Folder:
  - **`Dockerfile`** - Multistage Dockerfile
  - **`app.py`** - The fixed app
  - **`requirements.txt`** - The packages of the app

## K8s
- **`deployment.yaml`** - Deployment part
- **`service.yaml`** - Service that connects to the deployment (Load Balancer)
