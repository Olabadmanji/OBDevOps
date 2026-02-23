# CloudCostTracker: Automated AWS Cost Monitoring & Alerting

## Project Overview

**CloudCostTracker** is an enterprise-grade serverless solution designed to provide real-time visibility into AWS spending. It automates the entire lifecycle of cost management: from monitoring daily fluctuations via CloudWatch to generating visual executive summaries hosted on a secure, private S3 origin.

The project aligns with the **Cost Optimization** and **Security** pillars of the AWS Well-Architected Framework by ensuring zero cost at idle and maintaining a private storage posture.

---

## Architecture Components

### 1. Observability Layer – CloudWatch Metrics

* **Billing Metrics:** Ingests `EstimatedCharges` from the `us-east-1` region to track account-wide spend.
* **Event-Driven Triggers:** Uses Amazon EventBridge (Cron) to trigger reporting functions on a weekly schedule.

### 2. Alerting Layer – Amazon SNS

* **Real-Time Thresholds:** CloudWatch Alarms trigger SNS topics when pre-defined budget limits are breached.
* **Multi-Channel Notification:** Configured for instant email alerts to notify stakeholders of cost anomalies.

### 3. Compute Layer – AWS Lambda (Python 3.12)

* **Cost Explorer Integration:** Utilizes the `ce:GetCostAndUsage` API to aggregate service-specific spending data.
* **Automated Reporting:** Generates a dynamic HTML dashboard (Tailwind CSS/Chart.js) and pushes it to S3.

### 4. Security & Distribution – CloudFront + S3 (OAC)

* **Hardened Storage:** Amazon S3 bucket is configured with **Block Public Access** and contains no public objects.
* **Origin Access Control (OAC):** Amazon CloudFront is the exclusive entry point, using OAC to securely fetch data from the private bucket.

---

## Security Design

* **Zero-Public Exposure:** By using **CloudFront OAC**, the S3 bucket remains 100% private. This eliminates the "Public S3 Bucket" security risk common in static hosting.
* **IAM Least Privilege:** The Lambda execution role is restricted specifically to `s3:PutObject` for a single bucket and `ce:GetCostAndUsage`, preventing lateral movement.
* **Encryption in Transit:** All dashboard traffic is served over HTTPS via CloudFront’s global edge network.

---

## Deployment Process

### Phase 1 – Monitoring Foundation

1. Enabled **Billing Preferences** in the AWS Management Console to allow metric ingestion.
2. Provisioned **CloudWatch Alarms** tied to an SNS Topic for threshold monitoring.

### Phase 2 – Serverless Logic & IAM

1. Developed the **Python 3.12** Lambda function to query the Cost Explorer API.
2. Configured an IAM Policy allowing the Lambda function to write to S3 and read billing data.

### Phase 3 – Secure Distribution

1. Deployed an S3 bucket with all public access blocked.
2. Configured a **CloudFront Distribution** with Origin Access Control (OAC).
3. Updated the S3 Bucket Policy to grant `s3:GetObject` permission *only* to the CloudFront OAC principal.

---

## Troubleshooting & Resolution

### Issue: Lambda "AccessDenied" when querying Cost Explorer

The Lambda function failed to retrieve billing data, resulting in empty reports.

**Investigation Steps:**

* Reviewed CloudWatch Logs for the Lambda function.
* Verified that the IAM Role had the `ce:GetCostAndUsage` permission.

**Root Cause:**
AWS Cost Explorer API access is not enabled by default in some accounts, and the Lambda function was attempting to query data from a region other than `us-east-1`. Billing metrics and Cost Explorer data are globally aggregated in the North Virginia region.

**Resolution:**

* Explicitly enabled **Cost Explorer** in the Billing Console.
* Updated the Boto3 client configuration in the Lambda function to target the `us-east-1` endpoint.
* Re-ran the EventBridge trigger, which resulted in a successful dashboard generation.

---

## Key Features Demonstrated

* **Cost-Optimized Reporting:** Automated executive summaries with zero server overhead.
* **Modern Security Posture:** Implementation of **Origin Access Control (OAC)** for private S3 hosting.
* **Infrastructure as Code (IaC) Readiness:** Modular architecture ready for Terraform/CloudFormation deployment.
* **Full-Stack Serverless:** Integration of frontend visualization (Chart.js) with backend AWS data.

---