# Lab 11: Cleanup

This lab provides a cleanup script to remove all workshop resources from AWS CloudShell.

## Prerequisites

- AWS CloudShell access
- AWS CLI available in CloudShell (pre-installed)

## Instructions

1. Open AWS CloudShell in your browser.

2. Copy the entire contents of `cloudshell_cleanup.sh`.

3. Paste the script into the CloudShell terminal and press Enter.

4. The script will automatically:
   - Destroy Terraform resources
   - Terminate EC2 instances
   - Remove Terraform and Lacework CLI binaries
   - Remove cloned repositories and workshop artifacts
   - Delete CloudFormation stacks (AWS-AgentlessScanning, then AWS-Cloudtrail)
   - Delete CloudTrail trails
   - Delete EC2 key pairs
   - Delete security groups (except default)
   - Delete S3 buckets

5. Wait for the script to complete. The cleanup process may take several minutes, especially when deleting CloudFormation stacks and S3 buckets.

## What Gets Cleaned Up

The script removes the following workshop resources:

- Terraform deployments and binaries
- Lacework CLI and configuration
- Cloned code repositories (lacework-iac-scan-example, lacework-sca-scan-example)
- EC2 instances
- CloudFormation stacks (AWS-AgentlessScanning, AWS-Cloudtrail)
- CloudTrail trails
- EC2 key pairs
- Security groups (except default)
- S3 buckets (Lacework-related)
- Workshop artifacts (LICENSE files, sbom.json, terraform.zip, etc.)
- Malformed files created during workshop setup

## Notes

- The script runs non-interactively and disables AWS CLI pager to prevent prompts.
- CloudFormation stack deletions wait for completion before proceeding.
- S3 bucket deletion handles versioned objects and delete markers.
- The default security group is preserved.
- If any step fails, the script continues with remaining cleanup steps.

## Troubleshooting

If the script encounters errors:

- Check AWS permissions for the CloudShell user.
- Verify resources exist before running cleanup.
- Some resources may require manual deletion if dependencies prevent automated removal.
