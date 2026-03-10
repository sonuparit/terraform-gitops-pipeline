# 🚀 Advanced GitHub Actions CI/CD Pipeline (AWS ECR + Helm + GitOps + ArgoCD)

This document explains the **GitHub Actions workflow** used to
automatically build, package, and deploy microservices using a modern
**DevOps + GitOps architecture**.

The workflow performs the following tasks:

1.  Detects which microservices changed
2.  Builds Docker images only for those services
3.  Pushes images to **AWS Elastic Container Registry (ECR)**
4.  Updates Helm chart values automatically
5.  Commits changes back to the Git repository
6.  Allows **ArgoCD** to automatically deploy to Kubernetes

This design follows **production-grade DevOps practices used by modern
cloud-native systems**.

---

# 🧠 Why This Pipeline Is Important

This workflow demonstrates several advanced DevOps concepts recruiters
look for:

- Microservice-aware CI/CD pipelines
- Selective builds for efficiency
- Dynamic parallel deployments
- AWS container registry integration
- GitOps-based Kubernetes deployment
- Infrastructure automation
- Safe deployment patterns

Instead of rebuilding the entire application, the pipeline intelligently
deploys **only the services that changed**.

---

# 📁 Project Structure

    repo-root/
    │
    ├── .github/workflows/deploy.yml
    │
    └── src/
        ├── ui/
        ├── catalog/
        ├── cart/
        ├── checkout/
        └── orders/

Each service contains:

    src/<service>/
        Dockerfile
        application code
        chart/
            values.yaml

---

# ⚡ Workflow Name

    name: Deploy

This simply defines the workflow name visible inside the **GitHub
Actions UI**.

---

# 🔔 Workflow Triggers

    on:
      push:
        branches: [gitops]
        paths: ['src/**']
      workflow_dispatch:

The pipeline runs when:

### 1️⃣ Code is pushed to the `gitops` branch

AND the change occurs inside:

    src/

Example:

    src/cart/app.js
    src/ui/index.js

Changes outside `src/` will not trigger deployment.

This reduces unnecessary pipeline executions.

### 2️⃣ Manual execution

    workflow_dispatch

Allows engineers to run deployments manually from the GitHub UI.

---

# 🌍 Global Environment Variables

    env:
      AWS_REGION: ${{ secrets.AWS_REGION }}

Defines a workflow-level variable available to all jobs.

The value comes from **GitHub Secrets**.

Example:

    AWS_REGION = us-east-1

---

# 🧩 Pipeline Jobs Overview

The pipeline contains three jobs:

Job Purpose

---

detect-changes Identify which microservices changed
deploy Build and deploy services
summary Create deployment report

---

# 🔍 Job 1 --- Detect Changed Services

    detect-changes:
      runs-on: ubuntu-latest

Runs a script that determines **which services were modified in the
latest commit**.

---

## Checkout Repository

    - uses: actions/checkout@v4
      with:
        fetch-depth: 2

The runner downloads the repository.

`fetch-depth: 2` ensures GitHub retrieves the **last two commits**,
enabling comparison.

---

# 🔎 Change Detection Logic

    git diff --name-only HEAD~1 HEAD

This command lists all files modified in the latest commit.

Example:

    src/cart/app.js
    src/cart/Dockerfile

The script checks if changes belong to any service folder.

Example detection:

    src/cart/

If detected, the service is marked as changed.

---

# 📦 List of Microservices

    SERVICES=("ui" "catalog" "cart" "checkout" "orders")

The pipeline iterates through these services to check for modifications.

---

# 🧮 Dynamic Matrix Generation

If services changed, the script builds a **JSON matrix**.

Example:

    {
      "service": ["cart","orders"]
    }

This matrix allows GitHub Actions to run deployments **in parallel**.

---

# ⚡ Job 2 --- Deploy Services

    deploy:
      needs: detect-changes

The deploy job only runs **after the change detection job completes**.

---

# 🧵 Parallel Deployments

    strategy:
      matrix:
        service: [cart, orders]

GitHub automatically creates multiple jobs:

    Deploy cart
    Deploy orders

These run simultaneously, reducing deployment time.

---

# 🔐 AWS Authentication

    aws-actions/configure-aws-credentials@v4

Authenticates the pipeline with AWS using stored secrets:

    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY

---

# 📦 Login to Amazon ECR

    aws-actions/amazon-ecr-login@v2

Allows Docker to authenticate with **Amazon Elastic Container
Registry**.

Equivalent command:

    docker login

---

# 🏗 Build Docker Images

    docker build -t <repo>:<tag>

Images are tagged using the commit SHA:

Example:

    commit SHA: 9f8d21ac
    tag: 9f8d21a

This ensures **traceable and versioned deployments**.

---

# ☁ Push Images to ECR

    docker push

Images are pushed to:

    AWS_ACCOUNT_ID.dkr.ecr.<region>.amazonaws.com

Example:

    123456789012.dkr.ecr.us-east-1.amazonaws.com/retail-store-cart

---

# 🧠 Smart Infrastructure Feature

If an ECR repository does not exist, the pipeline automatically creates
it.

    aws ecr create-repository

This makes deployments **fully automated**.

---

# ⚙ Update Helm Chart

The pipeline updates:

    src/<service>/chart/values.yaml

Example change:

Before:

    image:
      repository: retail-store-cart
      tag: old

After:

    image:
      repository: retail-store-cart
      tag: 9f8d21a

Only the **application image** is updated.

Infrastructure images like Redis or MySQL remain unchanged.

---

# 💾 Commit Updated Helm Values

The pipeline commits updated Helm files back to the repository.

    git commit
    git push

Example commit message:

    Update cart Helm chart to 9f8d21a

---

# 🔁 Push Retry Logic

The workflow includes retry protection:

    for i in {1..3}

If a push fails due to race conditions, the pipeline:

1.  Pulls latest changes
2.  Rebases
3.  Retries push

This prevents pipeline failures during concurrent deployments.

---

# 📊 Job 3 --- Deployment Summary

The final job generates a deployment report inside GitHub Actions.

Example output:

    Deployment Summary

    Commit: 9f8d21a
    Branch: gitops
    Changed Services: cart orders

    Status: Deployment successful

This helps teams quickly understand deployment results.

---

# 🔄 GitOps Deployment Flow

This pipeline follows **GitOps best practices**.

Instead of applying Kubernetes manifests directly, it updates the Git
repository.

Deployment flow:

    Developer Push
          ↓
    GitHub Actions CI
          ↓
    Docker Build
          ↓
    Push Image → AWS ECR
          ↓
    Update Helm Values
          ↓
    Commit to Git Repo
          ↓
    ArgoCD detects change
          ↓
    ArgoCD syncs Kubernetes

The Kubernetes cluster is **never modified directly by CI**.

Git remains the **single source of truth**.

---

# 🏆 Key DevOps Concepts Demonstrated

This pipeline showcases several advanced practices:

### Selective Microservice Builds

Only changed services are built.

### Parallel Deployments

Matrix strategy enables concurrent builds.

### GitOps Deployment Model

Infrastructure state stored in Git.

### Container Registry Integration

AWS ECR used for secure image storage.

### Automated Infrastructure Creation

Repositories created automatically.

### Safe Deployment Process

Retry logic prevents race conditions.

---

# 🎯 Why this pipeline is valuable

This pipeline demonstrates:

- Real-world DevOps workflows
- Cloud-native architecture
- Microservices deployment automation
- GitOps principles
- Production-level CI/CD engineering

These are the same patterns used in **large-scale Kubernetes environments**.

---

# 📌 Technologies Used

- GitHub Actions
- Docker
- AWS ECR
- Helm
- ArgoCD
- Kubernetes
- GitOps methodology

---

# 👨‍💻 Author

Created as part of a **DevOps engineering learning project** focused on:

- CI/CD architecture
- Kubernetes deployment automation
- Cloud-native infrastructure
