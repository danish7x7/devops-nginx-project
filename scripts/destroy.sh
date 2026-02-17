#!/bin/bash
# destroy.sh - Clean up all resources

cd ~/devops-project/terraform

# Load token
export TF_VAR_do_token=$(cat ~/devops-project/secrets/secrets.txt | grep DO_TOKEN | cut -d= -f2)
export TF_VAR_home_ip=$(curl -s ifconfig.me)

echo "⚠️  WARNING: This will destroy ALL resources!"
echo "💰 This will stop any charges"
read -p "Are you sure? (yes/no): " confirm

if [ "$confirm" = "yes" ]; then
  terraform destroy -auto-approve
  echo "💥 All resources destroyed"
  echo "💰 No more charges!"
else
  echo "Cancelled - resources are safe"
fi
