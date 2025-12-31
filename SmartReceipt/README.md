# SmartReceipt AI – Automated Receipt Processing System

## Overview
SmartReceipt AI is a serverless system that automatically processes uploaded receipts, extracts text using Amazon Textract, stores structured data, and emails summaries to users.

## Architecture
- S3 triggers Lambda on receipt upload
- Lambda calls Textract for OCR
- Extracted data stored in DynamoDB
- SES sends receipt summary emails

## AWS Services Used
- Amazon S3
- AWS Lambda
- Amazon Textract
- Amazon DynamoDB
- Amazon SES
- IAM

## Key Features
- Fully automated receipt processing
- Serverless and scalable
- AI-powered text extraction
- Email summaries
- Secure storage

## Why This Project Matters
- Demonstrates event-driven architecture
- Shows real-world AI integration
- Highlights serverless best practices
- Strong Solutions Architect & DevOps signal
