<p align="center">
<img src="https://github.com/kura-labs-org/kuralabs_deployment_1/blob/main/Kuralogo.png">
</p>
<h1 align="center">Containerized_Bankapp<h1> 

## Planning

<img width="500" alt="Screenshot 2023-11-05 at 10 39 37 AM" src="https://github.com/Jmo-101/Containerized_Bankapp/assets/138607757/da9eaa63-057d-4628-95f0-395b7f404ed9">


# Purpose

This project demonstrates the utilization of Terraform and Docker, along with Jenkins, to provision a CI/CD pipeline with Jenkins agents. Terraform is used to automate the creation of Elastic Container Services using a Docker image.

## Docker

I started by using an existing EC2 instance with Docker installed to create a Docker image based on a past deployment of a retail banking application. Details of this deployment can be found [here](https://github.com/Jmo-101/automate_tf_bankapp.git). After creating a Dockerfile and building the image using `docker build`, I renamed the image with the `docker tag` command and uploaded it to my DockerHub account using `docker push`.

<img width="518" alt="Screenshot 2023-11-04 at 5 58 23 PM" src="https://github.com/Jmo-101/Containerized_Bankapp/assets/138607757/241266f0-492f-42ac-a9aa-87f21ee89d43">

<img width="216" alt="docker image" src="https://github.com/Jmo-101/Containerized_Bankapp/assets/138607757/ebab6705-d943-4df2-9201-8512acac71a7">

## GitHub

I used Git commands to clone my repository into the EC2 instances to obtain the necessary files. After getting the required files, I initialized the repository with `git init`, added all the files using `git add .`, committed the changes with `git commit`, and pushed the repository to GitHub using `git push`.

## Terraform

Once the Docker image was uploaded to DockerHub, I used another existing EC2 instance with Terraform installed to automate the creation of three EC2 instances. These instances were created in a default VPC. One instance served as a Jenkins manager, the second as a Docker instance and Jenkins agent, and the third as a Terraform instance and Jenkins agent.

## Jenkinsfile

In my Jenkinsfile, I edited a few lines and included my credentials using a DockerHub token for the Jenkins pipeline to recognize my Docker image.

## Jenkins Manager

In my Jenkins manager, I configured two agents. One agent was used for the Terraform portion of my Jenkins file, while the second agent was used to log into my DockerHub and build the uploaded image. I installed a Docker Pipeline plugin and ran a multibranch pipeline. After a few attempts, the pipeline was successful.

<img width="650" alt="Screenshot 2023-11-04 at 10 12 50 PM" src="https://github.com/Jmo-101/Containerized_Bankapp/assets/138607757/51eb9592-9972-4773-822c-55d101b11b40">


## ECS & Application

After confirming the success of my pipeline, I checked my infrastructure and application on AWS. Everything specified in the Terraform `main.tf` file was built upon success.

<img width="800" alt="Screenshot 2023-11-04 at 10 22 43 PM" src="https://github.com/Jmo-101/Containerized_Bankapp/assets/138607757/f4d1fe0b-3bb7-44d5-90aa-55f6978c82cf">
<img width="700" alt="Screenshot 2023-11-04 at 10 23 35 PM" src="https://github.com/Jmo-101/Containerized_Bankapp/assets/138607757/e25a79d5-37ba-4d81-bd02-5e423765377e">
<img width="500" alt="Screenshot 2023-11-04 at 10 24 19 PM" src="https://github.com/Jmo-101/Containerized_Bankapp/assets/138607757/f6c2d755-696c-4efc-8627-7790646fa0a8">

## Security & Containers

Upon observation, the infrastructure is not secure due to the Jenkins manager being housed in a default VPC and public subnet. If the Jenkins manager is compromised or fails, the entire application goes down. However, the containers are secure as they are placed in a private subnet. I configured a desired count of two tasks for my banking cluster in the `main.tf` file. If a task is terminated, another task will spin back up, ensuring the desired count of two for the cluster.

```python
# ECS Service
resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "bank-ecs-service"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.aws-ecs-task.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 2
  force_new_deployment = true
```

## Troubleshooting
