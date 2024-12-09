# Automating-deployment-of-an-Ecommerce-website

## Background

A technology consulting firm, is adopting a cloud architecture for its software applications. As a DevOps Engineer, your task is to design and implement a robust CI/CD pipeline using Jenkins to automate the deployment of a web application. The goal is to achieve continuous integration, continuous deployment, and ensure the scalability and reliability of the applications.

## Jenkins setup

Let's quickly lookup the installation process for jenkins in the offical documentation
Clikc link <https://www.jenkins.io/doc/book/installing/linux/>

1. We would be needing the Java JKD as a dependency. So we would install that first by running the following commands:

```bash
sudo apt update
sudo apt install fontconfig openjdk-17-jre
```

2. We would install jenkins by the running the following commands:

```bash
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
```

3. We would also need to install docker which we would need for building and running our app as a container. Let's install docker by running the following commands:

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

next run
`sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`

Now we have Jenkins, JDK and Docker setup on our Ubuntu ec2 instance

Lets go to <http://serverip:8080> to complete our jenkins

## Completing our jenkins setup

On jenkins page we would need to provide Adminpassword to authenticate it. The password can be gotten by running `cat  /var/lib/jenkins/secrets/initialAdminPassword`

- Next we would install suggested plugins
[Install plugins](/images/Install-plugins.png)