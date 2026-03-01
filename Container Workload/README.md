# Project 3: Container Workload on AWS ECS Fargate using Terraform

## **Overview**

Containerized a Node.js application and deployed it to AWS ECS Fargate with production-grade infrastructure managed entirely through Terraform. This project demonstrates the full DevOps lifecycle — from writing application code, containerizing it with Docker, storing the image in a private registry, and running it on serverless container infrastructure with automatic scaling and secure credential management.

---

## **What Was Built**

| Component | Service | Purpose |
| --- | --- | --- |
| **Container Registry** | Amazon ECR | Stores Docker image privately |
| **Container Runtime** | ECS Fargate | Runs containers without managing servers |
| **Load Balancer** | Application Load Balancer | Routes traffic, health checks |
| **Networking** | VPC, Subnets, NAT Gateway | Isolated, secure network |
| **Auto Scaling** | Application Auto Scaling | Scales tasks based on CPU/Memory |
| **Secrets** | AWS Secrets Manager | Injects credentials at runtime |
| **Monitoring** | CloudWatch Logs | Container log aggregation |
| **Infrastructure** | Terraform | Everything provisioned as code |

---

## **Tech Stack**

* **Infrastructure as Code:** Terraform
* **Containerization:** Docker
* **Container Orchestration:** AWS ECS Fargate
* **Image Registry:** Amazon ECR
* **Load Balancing:** AWS Application Load Balancer
* **Networking:** AWS VPC, Public/Private Subnets, NAT Gateway
* **Security:** AWS IAM, AWS Secrets Manager
* **Observability:** AWS CloudWatch Logs + Container Insights
* **Language:** Node.js (Express)

---

## **Project Structure**

```bash
├── main.tf            # Provider and S3 backend configuration
├── variables.tf       # All input variables
├── outputs.tf         # ALB URL, cluster name, ECR URL
├── vpc.tf             # VPC, subnets, IGW, NAT Gateway, route tables
├── ecr.tf             # ECR repository and lifecycle policy
├── secrets.tf         # Secrets Manager secret and version
├── iam.tf             # ECS execution role and task role
├── ecs.tf             # ECS cluster, task definition, service
├── alb.tf             # ALB, target group, listener, security groups
├── autoscaling.tf     # Auto scaling target and tracking policies
└── app/
    ├── server.js      # Node.js Express application
    ├── package.json   # Dependencies
    └── Dockerfile     # Container build instructions

```

---

## **Key Technical Decisions**

**Why Fargate over EC2 launch type?**
Fargate is serverless — no EC2 instances to patch, manage, or right-size. You pay only for the CPU and memory your containers actually use.

**Why private subnets for ECS tasks?**
Tasks have no public IPs. All inbound traffic must go through the ALB. This reduces the attack surface significantly.

**Why Secrets Manager over environment variables?**
Secrets never appear in task definitions, CloudWatch logs, or source code. They are injected directly into the container at runtime by the ECS agent using the execution role's IAM permissions.

**Why target tracking auto scaling?**
Target tracking automatically calculates the right number of tasks needed to maintain the target metric. No manual step scaling rules to maintain.

---

## **How to Deploy**

### **Prerequisites**

* AWS CLI configured
* Terraform installed
* Docker installed

### **Steps**

**1. Create Terraform state backend (one time)**

* Create an S3 bucket for state storage
* Create a DynamoDB table named `terraform-locks` for state locking

**2. Initialize and deploy infrastructure**

```bash
terraform init
terraform plan -var="app_db_password=YourPassword"
terraform apply -var="app_db_password=YourPassword" -auto-approve

```

**3. Build and push Docker image**

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION=us-east-1
REPO="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/container-workload-app"

aws ecr get-login-password --region $REGION | \
  docker login --username AWS --password-stdin \
  "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"

docker build -t container-workload-app ./app
docker tag container-workload-app:latest $REPO:latest
docker push $REPO:latest

```

**4. Force ECS deployment**

```bash
aws ecs update-service \
  --cluster project3-cluster \
  --service project3-service \
  --force-new-deployment \
  --region us-east-1

```

**5. Verify**

```bash
terraform output
curl $(terraform output -raw alb_dns_name)/health

```

---

## **Live Output**

When deployed successfully the ALB returns:

```json
{
  "message": "ECS Fargate App is running!",
  "environment": "production",
  "db_password_set": true,
  "api_key_set": true
}

```

`db_password_set: true` and `api_key_set: true` confirm that AWS Secrets Manager is successfully injecting credentials into the container at runtime.

---

## **Security Highlights**

* ECS tasks run in **private subnets** with no public IP addresses
* All traffic routes through the **ALB** as the single entry point
* Credentials stored in **Secrets Manager**, never in source code or task definitions
* **IAM least privilege** — execution role and task role have separate, minimal permissions
* ECR **image scanning on push** — vulnerabilities detected automatically
* **Security groups** restrict task traffic to ALB only

---

## **Skills Demonstrated**

* Infrastructure as Code with Terraform
* Docker containerization and image management
* AWS ECS Fargate serverless container orchestration
* Private networking with VPC, public/private subnets
* Load balancing and health check configuration
* Application auto scaling with target tracking policies
* Secrets management and IAM security best practices
* CloudWatch logging and container observability
* Git version control and GitHub portfolio management

---