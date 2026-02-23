# Serverless REST API with JWT Authentication

## Project Overview

This project implements a secure, highly available, and fully serverless REST API on AWS. The infrastructure is designed according to AWS best practices, focusing on **Security, Performance Efficiency, and Cost Optimization**.

The architecture leverages a "Scale-to-Zero" model, ensuring that costs are only incurred during active requests while providing enterprise-grade security through identity-aware networking.

---

## Architecture Components

### 1. Identity Layer – Amazon Cognito

* **User Pool:** Manages user registration, authentication, and password recovery.
* **JWT Issuance:** Provides cryptographically signed JSON Web Tokens (JWT) upon successful login.
* **Security:** Enforces password complexity and provides a secure identity provider (IdP) for the application.

### 2. API Entry Point – Amazon API Gateway (HTTP API)

* **JWT Authorizer:** Natively validates Cognito tokens at the edge before invoking backend logic.
* **Routing:** Directs HTTP methods (GET, POST, PUT, DELETE) to specific microservices (Lambda).
* **Cors Configuration:** Restricted to allow only authorized frontend origins.

### 3. Compute Layer – AWS Lambda (Python 3.12)

* **Decoupled Functions:** Separate functions for `createTodo`, `getTodos`, `updateTodo`, and `deleteTodo`.
* **Identity Injection:** Extracts the `sub` (Subject ID) from the JWT claims to ensure strict user data isolation.
* **Boto3 Integration:** Communicates with DynamoDB using the AWS SDK for Python.

### 4. Database Layer – Amazon DynamoDB

* **NoSQL Storage:** High-performance, key-value storage with sub-millisecond latency.
* **Partition Key Model:** Uses `userId` as the Partition Key to allow for efficient data retrieval per user.
* **On-Demand Capacity:** Scales instantly with traffic spikes while maintaining zero cost at idle.

---

## Security Design

* **Edge Validation:** API Gateway rejects unauthorized requests (401) before they reach the Compute layer, preventing unnecessary Lambda execution costs.
* **Data Isolation:** Every database query is scoped to the `userId` extracted from the verified JWT, preventing Cross-User Data Leakage.
* **IAM Least Privilege:** Each Lambda function is assigned a specific execution role with permissions limited only to the necessary DynamoDB table.

---

## Deployment Phases

### Phase 1 – Identity & Security Setup

1. Provisioned Cognito User Pool and App Client.
2. Configured API Gateway with a **JWT Authorizer** linked to the Cognito Issuer URL.

### Phase 2 – Database & Compute Provisioning

1. Created DynamoDB table with `userId` (Partition Key) and `todoId` (Sort Key).
2. Developed Python 3.12 Lambda functions for each CRUD operation.
3. Applied IAM roles with `dynamodb:PutItem`, `dynamodb:GetItem`, and `dynamodb:UpdateItem` permissions.

### Phase 3 – API Routing & Integration

1. Mapped HTTP routes to Lambda integrations in API Gateway.
2. Configured the authorizer to protect all `/todos` endpoints.
3. Verified the "Bouncer" effect by testing requests without Authorization headers.

---

## Troubleshooting & Resolution

### Issue: Lambda Returning 500 Internal Server Error

After successful authentication, the API returned a 500 error during `GET` and `POST` requests.

**Investigation Steps:**

* Inspected **CloudWatch Logs** for the specific Lambda function.
* Verified the event structure passed from API Gateway.

**Root Cause:**
The Lambda code was attempting to access `event['requestContext']['authorizer']['claims']`, but when using **HTTP APIs** (v2), the claims are nested inside an additional `jwt` key: `event['requestContext']['authorizer']['jwt']['claims']`.

**Resolution:**

* Updated the Python logic to use the correct path for JWT claims.
* Re-deployed the functions and verified the `userId` was correctly extracted and stored in DynamoDB.

---

## Key Features Demonstrated

* **Stateless Authentication:** Using JWTs for secure, scalable user management.
* **Cost-Optimized Architecture:** $0.00 monthly cost for development/portfolio scale.
* **Security at Depth:** Combining Cognito Identity with IAM Policy enforcement.
* **Modern API Standards:** Utilizing HTTP API v2 for superior performance over REST API v1.

---
