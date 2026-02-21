#!/bin/bash

# Update system packages
yum update -y

# Install Apache Web Server
yum install -y httpd

# Start Apache
systemctl start httpd
systemctl enable httpd

# Install AWS CLI (if not preinstalled)
yum install -y aws-cli

# Retrieve DB password from SSM Parameter Store
DB_PASSWORD=$(aws ssm get-parameter \
    --name "/prod/db/password" \
    --with-decryption \
    --query "Parameter.Value" \
    --output text \
    --region us-east-1)

# Create test webpage
echo '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise 3-Tier Architecture on AWS</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px auto; max-width: 900px; line-height: 1.6; color: #333; }
        h1 { border-bottom: 3px solid #222; padding-bottom: 10px; }
        .highlight { background: #f5f5f5; padding: 15px; border-left: 4px solid #333; margin: 15px 0; }
    </style>
</head>
<body>
    <h1>Highly Available 3-Tier Architecture on AWS</h1>
    <p>Application tier successfully provisioned behind an Application Load Balancer.</p>
    <div class="highlight">
        <strong>Security Status:</strong> Database connection string securely fetched via AWS Systems Manager Parameter Store.
    </div>
    <p>Built by olabadmanji | Cloud & DevOps Engineer</p>
</body>
</html>' > /var/www/html/index.html