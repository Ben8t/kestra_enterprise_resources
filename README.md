# Kestra EE Setup

## Quick Start

### 1. Create Environment File
Copy the template and add your secrets:
```bash
cp env.example .env
# Edit .env with your actual values
```

### 2. Generate Terraform Variables
```bash
./generate-tf-vars.sh
```

### 3. Start Services
```bash
# Start Docker Compose
docker-compose up -d

# Apply Terraform configuration
cd terraform
terraform init
terraform apply
```

## Scripts

### `generate-tf-vars.sh`
Generates `terraform/.auto.tfvars` from your `.env` file. Run this whenever you update your environment variables.

### `cleanup.sh`
Cleans up Terraform artifacts and Docker volumes:
```bash
./cleanup.sh --terraform    # Remove Terraform files
./cleanup.sh --docker       # Remove Docker volumes  
./cleanup.sh --all          # Remove everything
```

## Files
- `.env` - Your secrets (not in git)
- `env.example` - Template for environment variables
- `docker-compose.yml` - Uses environment variables from `.env`
- `terraform/` - Terraform configuration
