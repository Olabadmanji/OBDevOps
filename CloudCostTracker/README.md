Here is a professional, portfolio-ready version of your **README.md**. I have updated it to include the **OAC security model**, the **Lambda automation**, and the **modern dashboard** improvements we discussed.

---

# ☁️ CloudCostTracker

### *Automated AWS Cost Monitoring & Intelligent Alert System*

**CloudCostTracker** is a serverless solution designed to provide real-time visibility into AWS spending. It automates the entire lifecycle of cost management: from monitoring daily fluctuations via CloudWatch to generating weekly visual executive summaries hosted on a secure, private S3 origin.

---

## 🏗️ Architecture

The system leverages a 100% serverless stack to ensure zero cost when idle and high scalability.

1. **Observability Layer:** **CloudWatch Metrics** ingest `EstimatedCharges` from the N. Virginia (`us-east-1`) region to track account-wide spend.
2. **Alerting Layer:** **CloudWatch Alarms** trigger **Amazon SNS** notifications when pre-defined budget thresholds are breached.
3. **Compute Layer:** An **AWS Lambda (Python 3.12)** function queries the **AWS Cost Explorer API** weekly to aggregate service-level data.
4. **Storage Layer:** Reports are persisted in **Amazon S3**, which is hardened by **Block Public Access** settings.
5. **Distribution Layer:** **Amazon CloudFront** serves the static dashboard using **Origin Access Control (OAC)**, ensuring the S3 bucket remains private while providing global HTTPS access.

---

## 🚀 Key Features

* **Real-Time Threshold Alerting:** Instant email notifications via SNS when costs exceed user-defined limits.
* **Automated Weekly Reporting:** Zero-touch report generation using Lambda cron triggers (EventBridge).
* **Secure Static Hosting:** Modern security posture using CloudFront OAC to eliminate public S3 buckets.
* **Interactive Data Visualization:** Portfolio-ready dashboard built with Tailwind CSS and Chart.js for clear cost attribution.

---

## 🛠️ Tech Stack

* **Compute:** AWS Lambda
* **Storage:** Amazon S3
* **Network:** Amazon CloudFront (OAC)
* **Monitoring:** CloudWatch Metrics & Alarms
* **Security:** AWS IAM (Least Privilege Policies)
* **Frontend:** HTML5, Tailwind CSS, Chart.js

---

## 📝 Setup & Deployment

### 1. Enable Billing Metrics

You must enable "Receive Billing Alerts" in your AWS Billing Preferences to allow CloudWatch to receive cost data.

### 2. Lambda Configuration

Deploy the provided Python script with an **IAM Execution Role** containing:

* `ce:GetCostAndUsage` (Cost Explorer access)
* `s3:PutObject` (Permission to write reports to your bucket)

### 3. S3 Bucket Policy (OAC)

The bucket is configured with a private policy that grants access *only* to the CloudFront Service Principal:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": { "Service": "cloudfront.amazonaws.com" },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR-BUCKET/*",
            "Condition": {
                "StringEquals": { "AWS:SourceArn": "arn:aws:cloudfront::ACCOUNT:distribution/ID" }
            }
        }
    ]
}

```

---

## 📊 Dashboard Preview

*The dashboard provides a service-by-service breakdown of the previous 7 days of spending, automatically refreshed by the Lambda function.*

---

## ⚖️ License

This project is licensed under the MIT License - see the LICENSE file for details.

---

[AWS Cloud Projects Portfolio]