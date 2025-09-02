# Spring Boot Application Deployment on AWS

This project provides a complete solution for deploying a Spring Boot application on AWS using a robust and automated infrastructure-as-code approach.

## Architecture

The infrastructure is designed to be highly available, scalable, and secure. It consists of the following components:

*   **VPC:** A custom Virtual Private Cloud (VPC) to provide a logically isolated section of the AWS cloud.
*   **Subnets:** Public and private subnets across two Availability Zones for high availability.
*   **Application Load Balancer (ALB):** To distribute incoming traffic across the EC2 instances.
*   **EC2 Instances:** An Auto Scaling group of EC2 instances running the Spring Boot application.
*   **RDS PostgreSQL:** A Multi-AZ RDS PostgreSQL instance for the database.
*   **NAT Gateway:** To allow the EC2 instances in the private subnets to access the internet.
*   **S3 Buckets:** One S3 bucket for the Terraform state and another for the application artifacts.
*   **IAM Roles:** An IAM role for the EC2 instances to allow them to be managed by SSM and to access the S3 artifact bucket.
*   **GitHub Actions:** A CI/CD pipeline to automate the build and deployment of the Spring Boot application.

## Prerequisites

Before you begin, make sure you have the following:

*   An AWS account.
*   The AWS CLI installed and configured with your credentials.
*   Terraform installed on your local machine.
*   A GitHub repository with the code for this project.

## Setup and Deployment

Follow these steps to set up and deploy the project:

### 1. Clone the Repository

Clone this repository to your local machine:

```bash
git clone https://github.com/Heet09/spring-boot-project.git
cd spring-boot-project
```

### 2. Configure the Terraform Backend

1.  Create an S3 bucket and a DynamoDB table in your AWS account to be used for the Terraform remote backend.
2.  Update the `backend.tf` file with the names of your S3 bucket and DynamoDB table:

    ```terraform
    terraform {
      backend "s3" {
        bucket         = "your-terraform-state-bucket-name" # Replace with your S3 bucket name
        key            = "spring-boot-project/terraform.tfstate"
        region         = "us-east-1"
        dynamodb_table = "your-terraform-state-lock-table" # Replace with your DynamoDB table name
      }
    }
    ```

### 3. Configure the Artifacts Bucket

Create a `terraform.tfvars` file and add the name of the S3 bucket you want to use for storing the application artifacts:

```
artifacts_bucket_name = "my-spring-boot-artifacts-bucket"
```

### 4. Configure GitHub Secrets

In your GitHub repository, go to **Settings > Secrets and variables > Actions** and add the following secrets:

*   `AWS_ACCESS_KEY_ID`: Your AWS access key ID.
*   `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key.
*   `S3_ARTIFACTS_BUCKET`: The name of the S3 bucket you configured in the previous step.
*   `ASG_NAME`: The name of the Auto Scaling group, which is `asg-main`.

### 5. Provision the Infrastructure

1.  **Initialize Terraform:**

    ```bash
    terraform init
    ```

2.  **Create a Terraform plan:**

    ```bash
    terraform plan -var-file="terraform.tfvars"
    ```

3.  **Apply the Terraform configuration:**

    ```bash
    terraform apply -var-file="terraform.tfvars"
    ```

### 6. Trigger the CI/CD Pipeline

Commit and push your code to the `main` branch of your repository. This will trigger the GitHub Actions workflow to build and deploy your application.

### 7. Configure DNS

1.  Get the DNS name of the Application Load Balancer from the Terraform output:

    ```bash
    terraform output alb_dns_name
    ```

2.  Go to your domain registrar and create a CNAME record to point your desired domain to the ALB's DNS name.

## Terraform Resources

This project creates the following Terraform resources:

*   `aws_vpc`
*   `aws_subnet`
*   `aws_internet_gateway`
*   `aws_route_table`
*   `aws_route_table_association`
*   `aws_eip`
*   `aws_nat_gateway`
*   `aws_s3_bucket`
*   `aws_security_group`
*   `aws_iam_role`
*   `aws_iam_policy`
*   `aws_iam_role_policy_attachment`
*   `aws_iam_instance_profile`
*   `aws_launch_template`
*   `aws_autoscaling_group`
*   `aws_lb`
*   `aws_lb_target_group`
*   `aws_lb_listener`
*   `aws_autoscaling_attachment`
*   `aws_db_subnet_group`
*   `aws_db_instance`

## CI/CD Pipeline

The CI/CD pipeline is defined in the `.github/workflows/deploy.yml` file. It has the following steps:

1.  **Checkout:** Checks out the code from the repository.
2.  **Set up JDK:** Sets up the Java Development Kit.
3.  **Build with Maven:** Builds the Spring Boot application and creates a `.jar` file.
4.  **Configure AWS Credentials:** Configures the AWS credentials using the GitHub secrets.
5.  **Upload artifact to S3:** Uploads the built `.jar` file to the S3 artifact bucket.
6.  **Trigger deployment:** Uses the AWS CLI to execute the `/opt/deploy.sh` script on the EC2 instances using SSM Run Command.
