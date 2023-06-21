#!/bin/bash

# Output file
output_file="ec2_ips.csv"

# Write header to the output file
echo "EC2 Instance ID,Region,Public IP,Private IP" > "$output_file"

# Get the list of available AWS regions
regions=$(aws ec2 describe-regions --query 'Regions[].RegionName' --output text)

# Iterate through each region and list EC2 instances and their public and private IPs
for region in $regions; do
  instances_info=$(aws ec2 describe-instances --region "$region" --query "Reservations[].Instances[].[InstanceId, PublicIpAddress, PrivateIpAddress]" --output text)

  # Check if there are any instances in the region
  if [ -n "$instances_info" ]; then
    while read -r instance_id public_ip private_ip; do
      if [ "$public_ip" == "None" ]; then
        public_ip=""
      fi
      echo "$instance_id,$region,$public_ip,$private_ip" >> "$output_file"
    done <<< "$instances_info"
  fi
done
