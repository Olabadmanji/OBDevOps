Enterprise 3-Tier Web Architecture on AWS

## Project Overview

This project implements a highly available, fault-tolerant, and secure 3-tier web architecture on AWS. The infrastructure is designed according to AWS best practices and aligns with the AWS Well-Architected Framework pillars, particularly **Security, Reliability, and Operational Excellence**.

The architecture separates the presentation, application, and database layers to ensure scalability, maintainability, and security.

---

## Architecture Components

### 1. Network Layer – Amazon VPC

* Custom Virtual Private Cloud spanning two Availability Zones
* Public and private subnet segmentation
* Internet Gateway for public connectivity
* NAT Gateway for controlled outbound internet access

The network is designed with strict isolation between public-facing and private resources.

---

### 2. Load Balancing – Application Load Balancer

* Internet-facing Application Load Balancer deployed in public subnets
* Routes HTTP/HTTPS traffic to private EC2 instances
* Performs continuous health checks
* Integrated with AWS WAF

The ALB distributes incoming traffic across multiple application instances to ensure high availability.

---

### 3. Compute Layer – EC2 & Auto Scaling Group

* EC2 instances deployed in private subnets
* Managed by an Auto Scaling Group
* Launch Template used for standardized instance configuration
* Automated scaling based on traffic demand

The Auto Scaling Group ensures elasticity and automatic replacement of unhealthy instances.

---

### 4. Database Layer – Amazon RDS (MySQL)

* Amazon RDS MySQL instance deployed in private database subnets
* Dedicated DB Subnet Group
* Associated with restrictive security groups
* Automated backups enabled

In a production environment, Multi-AZ deployment would be enabled for high availability and automatic failover.

---

### 5. Secure Outbound Connectivity – NAT Gateway

* NAT Gateway deployed in public subnet
* Enables private EC2 instances to access the internet for updates and patches
* Prevents inbound internet access to private resources

---

### 6. Secrets Management – AWS Systems Manager Parameter Store

* Database credentials stored as encrypted `SecureString` parameters
* IAM Role attached to EC2 instances
* Secure retrieval of secrets during instance boot

This approach prevents hardcoded credentials and enforces least-privilege access.

---

### 7. Edge Optimization & Security – CloudFront & AWS WAF

* Amazon CloudFront distribution for global content delivery
* AWS Web Application Firewall attached for application-layer protection
* Protection against common OWASP threats (e.g., SQL injection, XSS)
* Reduced latency via edge caching

---

## 🔐 Security Design

* Layered security using cascading Security Groups
* ALB accessible from the internet (Port 80/443)
* Application tier accepts traffic only from ALB Security Group
* Database tier accepts traffic only from Application Security Group
* IAM roles used instead of embedded credentials

---

## Deployment Process

### Phase 1 – Network & Security Foundation

1. Provisioned VPC, subnets, route tables, Internet Gateway, and NAT Gateway
2. Configured cascading Security Groups:

   * `ALB-SG`: Allows inbound HTTP/HTTPS from 0.0.0.0/0
   * `App-SG`: Allows HTTP from `ALB-SG` only
   * `DB-SG`: Allows MySQL (3306) from `App-SG` only

---

### Phase 2 – Database & Secrets Configuration

1. Stored RDS master password in SSM Parameter Store (SecureString)
2. Deployed RDS MySQL instance within private DB subnets
3. Attached appropriate security groups

---

### Phase 3 – Compute & Edge Deployment

1. Created EC2 Launch Template with `user_data.sh` for Apache installation and SSM secret retrieval
2. Configured Auto Scaling Group across private subnets
3. Deployed Application Load Balancer
4. Attached AWS WAF
5. Configured CloudFront distribution for global traffic routing

---

## Troubleshooting & Resolution

### Issue: Target Group Health Checks Failing

The Application Load Balancer marked backend EC2 instances as unhealthy.

**Investigation Steps:**

* Reviewed EC2 instance system logs
* Verified security group configurations
* Checked IAM role permissions

**Root Cause:**
The EC2 instances did not have the required IAM role (`AmazonSSMManagedInstanceCore`) to retrieve the encrypted database password from AWS Systems Manager Parameter Store. The failure caused the startup script to terminate before the web server installation completed.

**Resolution:**

* Updated the Launch Template with the correct IAM Instance Profile
* Terminated unhealthy instances
* Auto Scaling Group launched new healthy instances

---

## Key Features Demonstrated

* Multi-AZ high availability design
* Infrastructure security using least privilege principles
* Elastic scaling architecture
* Secure secrets management
* Layer 7 traffic routing
* Global content delivery with edge caching
* Production-style troubleshooting workflow

---
