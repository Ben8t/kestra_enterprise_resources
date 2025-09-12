#!/bin/bash

# Script to generate terraform/.auto.tfvars from .env file
# This allows both Docker Compose and Terraform to use the same secret values

set -e

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "Error: .env file not found!"
    echo "Please copy env.template to .env and fill in your values:"
    echo "  cp env.template .env"
    echo "  # Edit .env with your actual values"
    exit 1
fi

# Source the .env file
set -a
source .env
set +a

# Generate .auto.tfvars for Terraform
cat > terraform/.auto.tfvars << EOF
# Database Configuration
postgres_db = "${POSTGRES_DB}"
postgres_user = "${POSTGRES_USER}"
postgres_password = "${POSTGRES_PASSWORD}"

# OpenAI Configuration
openai_api_key = "${OPENAI_API_KEY}"

# Kestra Configuration
kestra_encryption_secret_key = "${KESTRA_ENCRYPTION_SECRET_KEY}"
kestra_jdbc_secret = "${KESTRA_JDBC_SECRET}"

# License Configuration
kestra_license_id = "${KESTRA_LICENSE_ID}"
kestra_license_fingerprint = "${KESTRA_LICENSE_FINGERPRINT}"
kestra_license_key = "${KESTRA_LICENSE_KEY}"

# Existing Terraform variables
aws_key = "${AWS_KEY}"
aws_secret = "${AWS_SECRET}"
slack_webhook = "${SLACK_WEBHOOK}"
kestra_user = "${KESTRA_USER}"
kestra_password = "${KESTRA_PASSWORD}"
github_token = "${GITHUB_TOKEN}"
resend_api = "${RESEND_API}"
kestra_base_url = "${KESTRA_BASE_URL}"
kestra_tenant_id = "${KESTRA_TENANT_ID}"
kestra_username = "${KESTRA_USERNAME}"
EOF

echo "✅ Generated terraform/.auto.tfvars from .env file"
echo "📝 You can now run 'cd terraform && terraform plan' to use these variables"
