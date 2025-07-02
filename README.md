# 🚀 Full DevOps CI/CD Workflow (Jenkins + Ansible + Docker + Kubernetes on RHEL 9 EC2)

This project demonstrates a complete, production-style DevOps workflow manually configured from scratch — using only open-source tools and without prebuilt container images. It implements a GitOps-style CI/CD pipeline where a code push triggers a Jenkins pipeline, builds a Docker image, deploys it with Ansible, and runs the app on Kubernetes (Minikube) hosted on a remote EC2 node.

---

## 🔧 Tech Stack

- **Jenkins** — CI engine for automated builds and orchestration
- **Ansible** — Infrastructure provisioning and Kubernetes deployment
- **Docker** — Image build and private container registry
- **Minikube** — Local Kubernetes (inside EC2 target node)
- **Kubernetes** — To run and expose the application
- **Python Flask** — Lightweight test application

---

## 📁 Project Structure

Full-DevOps-Workflow/  
├── Ansible/  
│ ├── inventory.ini  
│ ├── site.yml # 👈 Single master playbook  
│ ├── roles/  
│ │ ├── setup_target/  
│ │ │ ├── tasks/  
│ │ │ │ └── main.yml # Installs Docker, kubectl, Minikube  
│ │ └── deploy_app/  
│ │ ├── tasks/  
│ │ │ └── main.yml # Copies and applies K8s manifests  
│ │ ├── templates/  
│ │ │ └── deployment.yaml.j2  
│ │ └── files/  
│ │ └── service.yaml  
├── App/  
│ ├── app.py  
│ ├── requirements.txt  
│ └── Dockerfile  
├── Jenkins/  
│ └── Jenkinsfile # CI pipeline definition  
├── setup/  
│ └── jenkins_host_setup.sh # Installs Jenkins, Docker, Ansible, Registry  


---

## 🚀 CI/CD Pipeline Flow


1️⃣ Developer pushes code to GitHub  
2️⃣ Jenkins pipeline auto-triggers  
3️⃣ Docker image is built from App/ and pushed to private registry  
4️⃣ Ansible runs:  
     - Provisions target EC2 (Docker, Minikube, kubectl)  
     - Deploys app + service to Kubernetes  
5️⃣ App exposed using NodePort service in Minikube  

🧭 Setup Instructions  
🛠️ All steps performed manually on 2 EC2 instances (RHEL 9):  

----
Jenkins Host (Control Node):

Install Docker, Jenkins, Ansible (via pip)  

Run a local Docker registry  

Configure SSH access to Target Node  

Setup Script:  

setup/jenkins_host_setup.sh  

----
Ansible Configuration:

inventory.ini — target EC2 host IP  

site.yml — master playbook combining both roles  

roles/setup_target/ — installs Docker + Minikube + kubectl  

roles/deploy_app/ — deploys K8s app and service YAMLs  

----
Jenkins Configuration:

Create a Freestyle or Pipeline job pointing to the GitHub repo  

Add private registry IP and Ansible command to Jenkins/Jenkinsfile  

🔎 How to Access the App   
Currently, the app is exposed using a Minikube NodePort service.  

Example:

minikube ip      # get Minikube IP (e.g. 192.168.49.2)  
curl http://192.168.49.2:30007/  

----
⚠️ Challenges Faced:

❌ Red Hat subscription issues: Could not use epel-release, solved by installing Ansible via pip

❌ Docker not found errors: Manual Docker repo added for RHEL 9 support

❌ Permission denied on Docker socket: Fixed with correct usermod and newgrp

❌ Jenkins user lacked Docker access: Resolved by adding jenkins to docker group

❌ Ansible automation on fresh EC2s: Required bootstrapping via roles for complete Minikube setup

----
📈 Future Improvements:

🔄 Replace Minikube with AWS EKS to use a production-grade managed Kubernetes service  

🌐 Public-facing service using an external LoadBalancer or EKS Ingress so app can be accessed via:  

http://<TARGET_EC2_PUBLIC_IP>/  
🔒 TLS & Authentication for private registry and production readiness  

✅ Add automated test stage in Jenkins before deployment  

