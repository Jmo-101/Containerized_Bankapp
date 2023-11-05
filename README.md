<p align="center">
<img src="https://github.com/kura-labs-org/kuralabs_deployment_1/blob/main/Kuralogo.png">
</p>
<h1 align="center">Containerized_Bankapp<h1> 

# Purpose

This project demonstrates the utilization of Terraform and Docker, along with Jenkins, to provision a CI/CD pipeline with Jenkins agents. Terraform is used to automate the creation of Elastic Container Services using a Docker image.

## Docker

I started by using an existing EC2 instance with Docker installed to create a Docker image based on a past deployment of a retail banking application. Details of this deployment can be found [here](link_to_details). After creating a Dockerfile and building the image using `docker build`, I renamed the image with the `docker tag` command and uploaded it to my DockerHub account using `docker push`.

## GitHub

I used Git commands to clone my repository into the EC2 instances to obtain the necessary files. After getting the required files, I initialized the repository with `git init`, added all the files using `git add .`, committed the changes with `git commit`, and pushed the repository to GitHub using `git push`.

## Terraform

Once the Docker image was uploaded to DockerHub, I used another existing EC2 instance with Terraform installed to automate the creation of three EC2 instances. These instances were created in a default VPC. One instance served as a Jenkins manager, the second as a Docker instance and Jenkins agent, and the third as a Terraform instance and Jenkins agent.

## Jenkinsfile

In my Jenkinsfile, I edited a few lines and included my credentials using a DockerHub token for the Jenkins pipeline to recognize my Docker image.

## Jenkins Manager

In my Jenkins manager, I configured two agents. One agent was used for the Terraform portion of my Jenkins file, while the second agent was used to log into my DockerHub and build the uploaded image. I installed a Docker Pipeline plugin and ran a multibranch pipeline. After a few attempts, the pipeline was successful.

## ECS & Application

After confirming the success of my pipeline, I checked my infrastructure and application on AWS. Everything specified in the Terraform `main.tf` file was built upon success.

<img width="700" alt="Screenshot 2023-11-04 at 10 23 35 PM" src="https://github.com/Jmo-101/Containerized_Bankapp/assets/138607757/e25a79d5-37ba-4d81-bd02-5e423765377e">

## Security & Containers

Upon observation, the infrastructure is not secure due to the Jenkins manager being housed in a default VPC and public subnet. If the Jenkins manager is compromised or fails, the entire application goes down. However, the containers are secure as they are placed in a private subnet. I configured a desired count of two tasks for my banking cluster in the `main.tf` file. If a task is terminated, another task will spin back up, ensuring the desired count of two for the cluster.
