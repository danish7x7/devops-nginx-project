#!/bin/bash
# deploy.sh - One-click deployment script

set -e  # Exit immediately if any command fails

echo "🚀 Starting deployment..."

# Navigate to terraform directory
cd ~/devops-project/terraform

# Load the API token
export TF_VAR_do_token=$(cat ~/devops-project/secrets/secrets.txt | grep DO_TOKEN | cut -d= -f2)

# Get current home IP automatically
export TF_VAR_home_ip=$(curl -s ifconfig.me)
echo "📍 Your IP: $TF_VAR_home_ip"

# Initialize Terraform
echo "🔧 Initializing Terraform..."
terraform init

# Validate configuration
echo "✅ Validating configuration..."
terraform validate

# Plan deployment
echo "📋 Planning deployment..."
terraform plan

# Ask for confirmation
read -p "👆 Does the plan look correct? Deploy? (yes/no): " confirm

if [ "$confirm" = "yes" ]; then
  # Apply
  echo "🎯 Deploying infrastructure..."
  terraform apply -auto-approve

  # Get outputs
  echo ""
  echo "🎉 Deployment complete!"
  echo "================================"
  echo "Server IP: $(terraform output -raw droplet_ip)"
  echo "Access URL: $(terraform output -raw access_url)"
  echo "================================"
  echo ""
  echo "⏳ Waiting 60 seconds for server to initialize..."
  sleep 60

  # Test connection
  echo "🧪 Testing connection..."
  curl -I http://$(terraform output -raw droplet_ip) || echo "⚠️  Server still starting, wait 2 more minutes then visit the URL"

  echo ""
  echo "✅ All done! Visit: http://$(terraform output -raw droplet_ip)"
else
  echo "❌ Deployment cancelled"
fi
