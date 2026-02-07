#!/bin/bash
# CloudShell Cleanup Script
# This script cleans up CloudShell artifacts created during labs 7, 9, and 10
#
# To use: Copy and paste this entire script into AWS CloudShell, or save as a file and run:
#   bash cloudshell_cleanup.sh#

set -e

echo "=== FortiCNAPP Workshop CloudShell Cleanup ==="
echo ""

# Step 1: Destroy Terraform resources first (Lab 8)
# This removes Terraform-managed AWS integrations
echo "Checking for Terraform deployments..."
if [ -d "$HOME/lacework/aws" ]; then
    echo "  Found Terraform working directory: ~/lacework/aws"
    
    # Navigate to the Terraform directory
    cd "$HOME/lacework/aws" || {
        echo "  ⚠ Failed to navigate to ~/lacework/aws directory"
        cd "$HOME"
        exit 1
    }
    
    # Check if terraform command is available
    if command -v terraform &>/dev/null || [ -f "$HOME/bin/terraform" ]; then
        TERRAFORM_CMD="terraform"
        if [ -f "$HOME/bin/terraform" ]; then
            TERRAFORM_CMD="$HOME/bin/terraform"
        fi
        
        # Check if terraform is initialized
        if [ ! -d ".terraform" ] && [ ! -f "terraform.tfstate" ] && [ ! -f ".terraform/terraform.tfstate" ]; then
            echo "  Terraform not initialized - initializing first..."
            if $TERRAFORM_CMD init -upgrade 2>/dev/null; then
                echo "  ✓ Terraform initialized"
            else
                echo "  ⚠ Terraform init failed - may not have resources to destroy"
            fi
        fi
        
        # Run terraform destroy with auto-approve
        echo "  Running terraform destroy..."
        if $TERRAFORM_CMD destroy -auto-approve 2>/dev/null; then
            echo "  ✓ Terraform resources destroyed successfully"
        else
            echo "  ⚠ Terraform destroy encountered errors (check output above)"
            echo "  This may be normal if no resources exist or were already destroyed"
        fi
    else
        echo "  ⚠ Terraform command not found - skipping destroy"
        echo "  You may need to manually destroy Terraform resources"
    fi
    
    # Return to home directory
    cd "$HOME"
else
    echo "  - No Terraform working directory found (~/lacework/aws does not exist)"
    echo "  Skipping Terraform init and destroy"
fi

# Step 2: Terminate all EC2 instances
echo "Terminating EC2 instances..."
if command -v aws &>/dev/null; then
    # Disable AWS CLI pager to prevent interactive prompts
    export AWS_PAGER=""
    
    # Get all running and stopped EC2 instances
    INSTANCES=$(aws ec2 describe-instances --no-cli-pager --query 'Reservations[].Instances[].InstanceId' --output text --filters "Name=instance-state-name,Values=running,stopped" 2>/dev/null || echo "")
    
    if [ -n "$INSTANCES" ]; then
        echo "  Found EC2 instances to terminate:"
        for instance in $INSTANCES; do
            echo "    - $instance"
        done
        echo "  Terminating instances..."
        # Terminate all instances at once
        if aws ec2 terminate-instances --instance-ids $INSTANCES --no-cli-pager 2>/dev/null; then
            echo "  ✓ Termination request sent for all instances"
        else
            echo "  ⚠ Failed to terminate some instances"
        fi
    else
        echo "  - No EC2 instances found"
    fi
else
    echo "  - AWS CLI not found (skipping EC2 termination)"
fi

# Step 3: Remove Terraform binary
echo "Removing Terraform..."
if [ -f "$HOME/bin/terraform" ]; then
    rm -f "$HOME/bin/terraform"
    echo "  Terraform removed from bin/"
fi
# Also check for terraform in home directory
if [ -f "$HOME/terraform" ]; then
    rm -f "$HOME/terraform"
    echo "  Terraform removed from home directory"
fi

# Step 4: Remove Lacework CLI binary
echo "Removing Lacework CLI..."
if [ -f "$HOME/bin/lacework" ]; then
    rm -f "$HOME/bin/lacework"
    echo "  Lacework CLI removed"
else
    echo "  Lacework CLI not found"
fi

# Step 5: Remove cloned repositories
echo "Removing cloned repositories..."
if [ -d "$HOME/lacework-iac-scan-example" ]; then
    rm -rf "$HOME/lacework-iac-scan-example"
    echo "  Removed lacework-iac-scan-example repository"
fi

if [ -d "$HOME/lacework-sca-scan-example" ]; then
    rm -rf "$HOME/lacework-sca-scan-example"
    echo "  Removed lacework-sca-scan-example repository"
fi

# Step 5a: Remove LICENSE files and other workshop artifacts
echo "Removing LICENSE files and workshop artifacts..."
# Remove LICENSE.txt
if [ -f "$HOME/LICENSE.txt" ]; then
    rm -f "$HOME/LICENSE.txt"
    echo "  Removed LICENSE.txt"
fi
# Remove LICENSES.txt (plural)
if [ -f "$HOME/LICENSES.txt" ]; then
    rm -f "$HOME/LICENSES.txt"
    echo "  Removed LICENSES.txt"
fi
# Remove sbom.json
if [ -f "$HOME/sbom.json" ]; then
    rm -f "$HOME/sbom.json"
    echo "  Removed sbom.json"
fi
# Remove terraform.zip
if [ -f "$HOME/terraform.zip" ]; then
    rm -f "$HOME/terraform.zip"
    echo "  Removed terraform.zip"
fi
# Remove terraform binary if it's in home directory (not in bin/)
if [ -f "$HOME/terraform" ] && [ ! -f "$HOME/bin/terraform" ]; then
    rm -f "$HOME/terraform"
    echo "  Removed terraform binary from home directory"
fi
# Remove any malformed export/command files or directories (often created by copy-paste errors)
find "$HOME" -maxdepth 1 \( -type f -o -type d \) \( -name "*export*" -o -name "*TF_PLUGIN*" -o -name "*Configure*" -o -name "*Terraform*" \) 2>/dev/null | while read -r item; do
    if [ -e "$item" ]; then
        # Check if it looks like a malformed command file/directory
        if [ -f "$item" ]; then
            if head -1 "$item" 2>/dev/null | grep -qE "(export|TF_PLUGIN|Configure)" 2>/dev/null; then
                rm -f "$item"
                echo "  Removed malformed file: $(basename "$item")"
            fi
        elif [ -d "$item" ]; then
            # Check if directory name contains workshop-related keywords
            dirname=$(basename "$item")
            if echo "$dirname" | grep -qiE "(export|TF_PLUGIN|Configure|Terraform)" 2>/dev/null; then
                rm -rf "$item"
                echo "  Removed malformed directory: $dirname"
            fi
        fi
    fi
done

# Step 6: Remove Terraform working directory
echo "Removing Terraform working directory..."
if [ -d "$HOME/lacework" ]; then
    rm -rf "$HOME/lacework"
    echo "  Removed ~/lacework directory"
fi

# Step 6a: Remove Terraform plugin cache directory
echo "Removing Terraform plugin cache..."
if [ -d "$HOME/.terraform.d" ]; then
    rm -rf "$HOME/.terraform.d"
    echo "  Removed ~/.terraform.d directory"
else
    echo "  ~/.terraform.d directory not found"
fi

# Step 7: Remove Lacework CLI configuration
echo "Removing Lacework CLI configuration..."
if [ -d "$HOME/.lacework" ]; then
    rm -rf "$HOME/.lacework"
    echo "  Removed Lacework CLI configuration directory"
else
    echo "  Lacework CLI configuration directory not found"
fi

# Remove Lacework config file (.lacework.toml)
if [ -f "$HOME/.lacework.toml" ]; then
    rm -f "$HOME/.lacework.toml"
    echo "  Removed Lacework CLI config file (.lacework.toml)"
else
    echo "  Lacework CLI config file not found"
fi

# Step 8: Remove component installations
echo "Removing Lacework components..."
if [ -d "$HOME/.lacework/components" ]; then
    rm -rf "$HOME/.lacework/components"
    echo "  Removed Lacework components"
fi

# Step 9: Clean up bin directory if empty
if [ -d "$HOME/bin" ] && [ -z "$(ls -A $HOME/bin)" ]; then
    rmdir "$HOME/bin"
    echo "  Removed empty bin directory"
fi

# Step 10: Remove PATH modifications from .bashrc if they exist (SAFE - only removes specific lines)
echo "Cleaning up .bashrc..."
if [ -f "$HOME/.bashrc" ]; then
    # Backup .bashrc first
    cp "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"
    echo "  Created backup of .bashrc"
    
    # Only remove specific workshop-related lines - be very precise to avoid breaking syntax
    # Remove PATH exports that add $HOME/bin (exact match patterns only)
    sed -i '/^export PATH=\$HOME\/bin:\$PATH$/d' "$HOME/.bashrc" 2>/dev/null || \
    sed -i '' '/^export PATH=\$HOME\/bin:\$PATH$/d' "$HOME/.bashrc" 2>/dev/null
    
    # Remove malformed PATH exports (HOME/bin without $) - but only standalone export lines
    sed -i '/^export PATH=HOME\/bin:/d' "$HOME/.bashrc" 2>/dev/null || \
    sed -i '' '/^export PATH=HOME\/bin:/d' "$HOME/.bashrc" 2>/dev/null
    
    # Remove Terraform cache directory setting (exact match)
    sed -i '/^export TF_PLUGIN_CACHE_DIR=/d' "$HOME/.bashrc" 2>/dev/null || \
    sed -i '' '/^export TF_PLUGIN_CACHE_DIR=/d' "$HOME/.bashrc" 2>/dev/null
    
    # Verify syntax is still valid after cleanup
    if bash -n "$HOME/.bashrc" 2>/dev/null; then
        echo "  Cleaned up .bashrc (syntax verified)"
    else
        echo "  ⚠ Syntax error detected after cleanup - restoring backup"
        cp "$HOME/.bashrc.backup."* "$HOME/.bashrc" 2>/dev/null
        echo "  Restored .bashrc from backup"
    fi
else
    echo "  .bashrc not found"
fi

# Step 11: Delete CloudFormation stacks (before CloudTrail deletion)
echo "Deleting CloudFormation stacks..."
if command -v aws &>/dev/null; then
    # Disable AWS CLI pager to prevent interactive prompts
    export AWS_PAGER=""
    
    # First, delete AWS-AgentlessScanning stack (has nested stacks)
    # Stack name starts with AWS-AgentlessScanning but may have additional characters
    AGENTLESS_STACK=$(aws cloudformation describe-stacks --no-cli-pager --query 'Stacks[?starts_with(StackName, `AWS-AgentlessScanning`)].StackName' --output text 2>/dev/null || echo "")
    if [ -n "$AGENTLESS_STACK" ]; then
        echo "  Deleting AWS-AgentlessScanning stack (this may take a few minutes)..."
        if aws cloudformation delete-stack --stack-name "$AGENTLESS_STACK" --no-cli-pager 2>/dev/null; then
            echo "    Deletion initiated, waiting for completion..."
            aws cloudformation wait stack-delete-complete --stack-name "$AGENTLESS_STACK" --no-cli-pager 2>/dev/null
            if [ $? -eq 0 ]; then
                echo "    ✓ AWS-AgentlessScanning stack deleted successfully"
            else
                echo "    ⚠ AWS-AgentlessScanning stack deletion may still be in progress"
            fi
        else
            echo "    ⚠ Failed to delete AWS-AgentlessScanning stack"
        fi
    else
        echo "  - AWS-AgentlessScanning stack not found"
    fi
    
    # Then, delete AWS-Cloudtrail stack
    # Stack name starts with AWS-Cloudtrail but may have additional characters
    CLOUDTRAIL_STACK=$(aws cloudformation describe-stacks --no-cli-pager --query 'Stacks[?starts_with(StackName, `AWS-Cloudtrail`)].StackName' --output text 2>/dev/null || echo "")
    if [ -n "$CLOUDTRAIL_STACK" ]; then
        echo "  Deleting AWS-Cloudtrail stack (this may take a few minutes)..."
        if aws cloudformation delete-stack --stack-name "$CLOUDTRAIL_STACK" --no-cli-pager 2>/dev/null; then
            echo "    Deletion initiated, waiting for completion..."
            aws cloudformation wait stack-delete-complete --stack-name "$CLOUDTRAIL_STACK" --no-cli-pager 2>/dev/null
            if [ $? -eq 0 ]; then
                echo "    ✓ AWS-Cloudtrail stack deleted successfully"
            else
                echo "    ⚠ AWS-Cloudtrail stack deletion may still be in progress"
            fi
        else
            echo "    ⚠ Failed to delete AWS-Cloudtrail stack"
        fi
    else
        echo "  - AWS-Cloudtrail stack not found"
    fi
else
    echo "  - AWS CLI not found (skipping CloudFormation stack cleanup)"
fi

# Step 12: Delete CloudTrail trails created by workshop (before S3 buckets)
echo "Deleting CloudTrail trails created by workshop..."
if command -v aws &>/dev/null; then
    # Disable AWS CLI pager to prevent interactive prompts
    export AWS_PAGER=""
    
    # Find and delete CloudTrail trails (pattern: lacework-cloudtrail or similar workshop trails)
    # Get all trails and filter for workshop-related ones (containing "lacework")
    ALL_TRAILS=$(aws cloudtrail list-trails --no-cli-pager --query 'Trails[].Name' --output text 2>/dev/null || echo "")
    
    WORKSHOP_TRAILS=""
    if [ -n "$ALL_TRAILS" ]; then
        for trail in $ALL_TRAILS; do
            # Check if trail name contains workshop-related keywords (lacework)
            if echo "$trail" | grep -qi "lacework" 2>/dev/null; then
                WORKSHOP_TRAILS="$WORKSHOP_TRAILS $trail"
            fi
        done
    fi
    
    if [ -n "$WORKSHOP_TRAILS" ]; then
        for trail in $WORKSHOP_TRAILS; do
            echo "  Deleting CloudTrail trail: $trail"
            # Stop logging first (required before deletion)
            aws cloudtrail stop-logging --name "$trail" --no-cli-pager 2>/dev/null || true
            sleep 2
            # Delete the trail
            if aws cloudtrail delete-trail --name "$trail" --no-cli-pager 2>/dev/null; then
                echo "    ✓ Deleted CloudTrail trail: $trail"
            else
                echo "    ⚠ Failed to delete CloudTrail trail: $trail"
            fi
        done
    else
        echo "  - No workshop CloudTrail trails found"
    fi
else
    echo "  - AWS CLI not found (skipping CloudTrail cleanup)"
fi

# Step 13: Delete EC2 key pairs (before S3 buckets)
echo "Deleting EC2 key pairs..."
if command -v aws &>/dev/null; then
    # Disable AWS CLI pager to prevent interactive prompts
    export AWS_PAGER=""
    
    # Get all EC2 key pairs
    ALL_KEY_PAIRS=$(aws ec2 describe-key-pairs --no-cli-pager --query 'KeyPairs[].KeyName' --output text 2>/dev/null || echo "")
    
    if [ -n "$ALL_KEY_PAIRS" ]; then
        for key_pair in $ALL_KEY_PAIRS; do
            echo "  Deleting EC2 key pair: $key_pair"
            if aws ec2 delete-key-pair --key-name "$key_pair" --no-cli-pager 2>/dev/null; then
                echo "    ✓ Deleted EC2 key pair: $key_pair"
            else
                echo "    ⚠ Failed to delete EC2 key pair: $key_pair"
            fi
        done
    else
        echo "  - No EC2 key pairs found"
    fi
else
    echo "  - AWS CLI not found (skipping EC2 key pair cleanup)"
fi

# Step 14: Delete security groups (except 'default')
echo "Deleting security groups (except 'default')..."
if command -v aws &>/dev/null; then
    # Disable AWS CLI pager to prevent interactive prompts
    export AWS_PAGER=""
    
    # Get all security groups except 'default'
    SECURITY_GROUPS=$(aws ec2 describe-security-groups --no-cli-pager --query 'SecurityGroups[?GroupName!=`default`].GroupId' --output text 2>/dev/null || echo "")
    
    if [ -n "$SECURITY_GROUPS" ]; then
        for sg_id in $SECURITY_GROUPS; do
            echo "  Deleting security group: $sg_id"
            if aws ec2 delete-security-group --group-id "$sg_id" --no-cli-pager 2>/dev/null; then
                echo "    ✓ Deleted security group: $sg_id"
            else
                echo "    ⚠ Failed to delete security group: $sg_id (may be in use)"
            fi
        done
    else
        echo "  - No security groups found (other than 'default')"
    fi
else
    echo "  - AWS CLI not found (skipping security group cleanup)"
fi

# Step 15: Delete S3 buckets created by workshop (LAST - after all other cleanup)
echo "Deleting S3 buckets created by workshop..."
if command -v aws &>/dev/null; then
    # Disable AWS CLI pager to prevent interactive prompts
    export AWS_PAGER=""
    
    # Function to delete S3 bucket (handles versioning and delete markers)
    delete_s3_bucket() {
        local bucket=$1
        echo "  Processing bucket: $bucket"
        
        # Check if bucket exists
        if ! aws s3api head-bucket --bucket "$bucket" --no-cli-pager 2>/dev/null; then
            echo "    - Bucket does not exist or is already deleted"
            return
        fi
        
        # Suspend versioning if enabled
        echo "    Checking versioning..."
        VERSIONING=$(aws s3api get-bucket-versioning --bucket "$bucket" --query 'Status' --output text --no-cli-pager 2>/dev/null || echo "None")
        if [ "$VERSIONING" == "Enabled" ]; then
            echo "    Suspending versioning..."
            aws s3api put-bucket-versioning --bucket "$bucket" --versioning-configuration Status=Suspended --no-cli-pager 2>/dev/null || true
            sleep 3
        fi
        
        # Remove all objects (non-versioned first)
        echo "    Removing all objects..."
        aws s3 rm "s3://$bucket" --recursive --no-cli-pager 2>/dev/null || true
        
        # Remove all object versions and delete markers using delete-objects API
        echo "    Removing object versions and delete markers..."
        
        # Delete all versions
        VERSIONS_JSON=$(aws s3api list-object-versions --bucket "$bucket" --output json --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}' --no-cli-pager 2>/dev/null)
        if [ -n "$VERSIONS_JSON" ] && [ "$VERSIONS_JSON" != "null" ] && echo "$VERSIONS_JSON" | grep -q '"Objects"'; then
            echo "$VERSIONS_JSON" | aws s3api delete-objects --bucket "$bucket" --delete file:///dev/stdin --no-cli-pager 2>/dev/null || true
        fi
        
        # Delete all delete markers
        MARKERS_JSON=$(aws s3api list-object-versions --bucket "$bucket" --output json --query '{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}' --no-cli-pager 2>/dev/null)
        if [ -n "$MARKERS_JSON" ] && [ "$MARKERS_JSON" != "null" ] && echo "$MARKERS_JSON" | grep -q '"Objects"'; then
            echo "$MARKERS_JSON" | aws s3api delete-objects --bucket "$bucket" --delete file:///dev/stdin --no-cli-pager 2>/dev/null || true
        fi
        
        # Final cleanup - remove any remaining objects
        aws s3 rm "s3://$bucket" --recursive --no-cli-pager 2>/dev/null || true
        
        # Delete bucket
        echo "    Deleting bucket..."
        sleep 2
        if aws s3api delete-bucket --bucket "$bucket" --no-cli-pager 2>/dev/null; then
            echo "    ✓ Deleted bucket: $bucket"
        else
            echo "    ⚠ Failed to delete bucket: $bucket"
            echo "    Try: aws s3 rb s3://$bucket --force"
        fi
    }
    
    # Find and delete all Lacework-related buckets
    # Patterns: lacework-ct-bucket-*, lacework-*-bucket-*, lacework-agentless-*, lw-*, *-laceworkcws-*
    ALL_BUCKETS=$(aws s3api list-buckets --query 'Buckets[].Name' --output text --no-cli-pager 2>/dev/null || echo "")
    
    LACEWORK_BUCKETS=""
    if [ -n "$ALL_BUCKETS" ]; then
        for bucket in $ALL_BUCKETS; do
            # Check if bucket name contains Lacework-related patterns
            if echo "$bucket" | grep -qiE "(lacework|lw-)" 2>/dev/null; then
                LACEWORK_BUCKETS="$LACEWORK_BUCKETS $bucket"
            fi
        done
    fi
    
    if [ -n "$LACEWORK_BUCKETS" ]; then
        echo "  Found Lacework-related buckets:"
        for bucket in $LACEWORK_BUCKETS; do
            echo "    - $bucket"
        done
        for bucket in $LACEWORK_BUCKETS; do
            delete_s3_bucket "$bucket"
        done
    else
        echo "  - No Lacework-related buckets found"
    fi
else
    echo "  - AWS CLI not found (skipping S3 bucket cleanup)"
fi

echo ""
echo "=== CloudShell cleanup complete ==="
