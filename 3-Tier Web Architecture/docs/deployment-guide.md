# Deployment Guide – Enterprise 3-Tier Architecture

This guide outlines the steps to manually deploy the 3-tier web architecture using the AWS Management Console.

---

## Prerequisites

* Active AWS account
* IAM user with administrative permissions
* Repository cloned locally:

```bash
git clone https://github.com/Olabadmanji/OBDevOps.git
```

---

## Network Layer (VPC)

Create a dedicated network environment:

* VPC CIDR: `10.0.0.0/16`
* 2 Availability Zones
* 2 Public Subnets (Load Balancer)
* 2 Private App Subnets (EC2)
* 2 Private DB Subnets (RDS)
* 1 NAT Gateway (for outbound internet access)

Ensure route tables are properly associated:

* Public subnets → Internet Gateway
* Private subnets → NAT Gateway

---

## Security Groups

Create cascading security groups to enforce least privilege:

**ALB-SG**

* Inbound: HTTP (80), HTTPS (443) from `0.0.0.0/0`

**App-SG**

* Inbound: HTTP (80) from `ALB-SG`

**DB-SG**

* Inbound: MySQL (3306) from `App-SG`

---

## Secrets Management

Store the database password securely:

* Service: Systems Manager → Parameter Store
* Name: `/3tier/db-password`
* Type: `SecureString`
* Tier: Standard

---

## Database Layer (RDS)

Deploy a private MySQL database:

* Engine: MySQL
* Template: Dev/Test
* Instance type: `db.t3.micro`
* Public access: **No**
* Subnet Group: Private DB subnets
* Security Group: `DB-SG`

---

## Compute Layer (Auto Scaling)

### IAM Role

Create an EC2 IAM Role with:

* `AmazonSSMManagedInstanceCore`

### Launch Template

* AMI: Amazon Linux 2023
* Instance type: `t2.micro`
* Security Group: `App-SG`
* IAM Role: Attach created role
* User Data: Paste `scripts/user_data.sh`

### Auto Scaling Group

* Subnets: Private App subnets
* Desired: 2
* Min: 2
* Max: 4

---

## Load Balancing & Edge

### Application Load Balancer

* Type: Internet-facing
* Subnets: Public subnets
* Security Group: `ALB-SG`
* Target Group: EC2 instances on port 80

### CloudFront

* Origin: ALB DNS name
* Viewer policy: Redirect HTTP to HTTPS
* Enable AWS Managed WAF rules

---

## Verification

* Confirm Target Group instances are **Healthy**
* Access CloudFront distribution URL
* Validate application loads successfully

---

## Cleanup

Delete resources in the following order to avoid charges:

1. CloudFront Distribution
2. ALB & Target Groups
3. Auto Scaling Group
4. Launch Template
5. RDS Instance
6. NAT Gateway
7. VPC

---