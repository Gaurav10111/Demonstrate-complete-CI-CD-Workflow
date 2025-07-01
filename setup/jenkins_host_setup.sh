# 1. Base packages
sudo dnf install -y wget curl git python3 python3-pip

# 2. Install Ansible manually
python3 -m pip install --upgrade pip
python3 -m pip install ansible

# 3. Add Docker repo manually
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 4. Install Docker
sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
newgrp docker

# 5. Add Jenkins repo and install
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key
sudo dnf install -y java-17-openjdk jenkins
sudo systemctl enable --now jenkins

# 6. Start Docker registry
docker run -d -p 5000:5000 --name registry --restart always registry:2

# 7. Fix Jenkins Docker access
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

