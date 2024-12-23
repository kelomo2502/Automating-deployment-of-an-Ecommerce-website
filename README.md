# Automating-deployment-of-an-Ecommerce-website

## Background

A technology consulting firm, is adopting a cloud architecture for its software applications. As a DevOps Engineer, your task is to design and implement a robust CI/CD pipeline using Jenkins to automate the deployment of a web application. The goal is to achieve continuous integration, continuous deployment, and ensure the scalability and reliability of the applications.

1. Jenkins setup

Let's quickly lookup the installation process for jenkins in the offical documentation
Clikc link <https://www.jenkins.io/doc/book/installing/linux/>

- We would be needing the Java JKD as a dependency. So we would install that first by running the following commands:

```bash
sudo apt update
sudo apt install fontconfig openjdk-17-jre
```

- We would install jenkins by the running the following commands:

```bash
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
```

1. We would also need to install docker which we would need for building and running our app as a container. Let's install docker by running the following commands:

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
- Next we would fill the signup form save and continue
[Fill signup form](/images/Signup.png)
- Click save and finsih. Please take note of the jenkins url `http://54.158.123.86:8080/`
[Save and finish the setup](/images/save_finish.png)

2. Source code management and repository intergration

- Lets first create a freestyle job by goinf to new item menu
- [new item](/images/new_item.png)
- next Enter a name
- select freestyle project
- Click ok
- Go to source code management
- Insert repository URL
- select the main branch in this case
- Select GitHub hook trigger for GITScm polling to setup build trigger
- Click save

## Setup webhook on github

- Sign into your github account
- Click my repositories
- Select the ecommerce web app repository
- Click on settings
- On the left hand corner , find webhooks tab
- Click on webhooks and add webhook
- Inside the payload url, enter your jenkins webhook url <http://54.225.17.239:8080/web-hook/>
- Choose `application/json` as Content-Type
- Click add webhook to save
- Now if we push any commit into the repository, we would notice it triggers a build
- This is our freejob in action
For the pipline
- Click on the new item to create a new job
- Give it a descriptive name
- Choose the pipline type
- Click ok
- Go to configuration and look for build trigger
- Select GitHub hook trigger for GITScm polling
- Add pipeline script

```yaml
pipeline {
    agent any

    stages {
        stage('Connect To Github') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/kelomo2502/Automating-deployment-of-an-Ecommerce-website.git']])
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t dockerfile .'
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                script {
                    // Stop and remove the existing container if it exists
                    sh '''
                    docker stop ecommerce-container || true
                    docker rm ecommerce-container || true
                    docker run -itd --name ecommerce-container -p 8081:80 dockerfile
                    '''
                }
            }
        }
    }
}

```

- click save
Now if we add and commit any changes to our repo and push to github, The webhook kicks in and trigger a build in the piple which executes the piple script.
- Our website can be access via our `serverip:8081` since we map port 8081:80 in our script
That is our pipeline job in action
