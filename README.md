# AWS Energy Data Pipeline
A fully serverless, auto-deploying energy monitoring pipeline using Terraform, Lambda, S3, DynamoDB, and FastAPI with CI/CD integration.

---

## 📌 Features
- Real-time data generation using Open-Meteo + mock data
- S3 ingestion + Lambda-triggered transformation
- DynamoDB storage with anomaly flagging
- FastAPI endpoints to access energy data
- Plotly visualization script
- GitHub Actions CI/CD with Terraform auto-deploy

---

## 🧰 Tech Stack
- AWS: Lambda, S3, DynamoDB, CloudWatch, IAM
- Python 3.10: FastAPI, boto3, requests, plotly
- Terraform v1.6+
- GitHub Actions for CI/CD

---

## 🛠️ Setup Instructions

### 1. Install Prerequisites
- Python ≥ 3.8
- Terraform ≥ 1.6
- AWS CLI (`aws configure`)
- GitHub Account

### 2. Clone & Prepare
```bash
git clone https://github.com/yourname/aws-energy-data-pipeline.git
cd aws-energy-data-pipeline
pip install -r requirements.txt
bash lambda/build.sh
bash data_generator/build.sh

bash layers/build.sh
```
These archives must exist before running `terraform plan` so Terraform can find the zip files.
Run the build scripts to create the Lambda deployment archives and the dependency layer.

```
Run the build scripts to package the Lambda functions with their dependencies.

The script stores key resource names to `last_outputs.json` after each deploy
and uses them on the next run to clean up any leftover resources. This helps
avoid naming conflicts when deploying repeatedly.

---

## ⚙️ CI/CD with GitHub Actions
### 🔐 Add GitHub Secrets
Go to **Settings → Secrets → Actions**:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### 🚀 CI/CD Trigger
Push to the `main` branch:
```bash
git add .
git commit -m "Initial deploy"
git push origin main
```

GitHub will auto-deploy your Terraform setup.

---

## 🧪 API Usage
Run locally:
```bash
uvicorn api.main:app --reload
```
- GET `/site/{site_id}?start=...&end=...`
- GET `/site/{site_id}/anomalies`

---

## 📊 Visualize Data
```bash
python visualization/visualize.py
```

---

## 🧹 Cleanup
```bash
cd terraform
terraform destroy -auto-approve
```
Alternatively, trigger the **Terraform Destroy** workflow on GitHub:
1. Push this repository to GitHub.
2. Open the **Actions** tab.
3. Select **Terraform Destroy** and click **Run workflow**.
This runs `terraform destroy -auto-approve` for you.

---

## 🤖 Optional Enhancements
- Alerts via SNS for anomalies
- Grafana for dashboards
- Kinesis for streaming ingestion

---

## 📁 Final Structure
```
aws-energy-data-pipeline/
├── .github/workflows/deploy.yml
├── .github/workflows/destroy.yml
├── api/main.py
├── data_generator/generate_data.py
├── lambda/lambda_function.py
├── visualization/visualize.py
├── terraform/*.tf
├── requirements.txt
├── .gitignore
├── README.md
```

---

Made with ❤️ for scalable data engineering.
