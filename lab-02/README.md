# Lab 2: Integrate AWS Inventory via CloudFormation

## Objectives

- Integrate AWS inventory with FortiCNAPP using CloudFormation

## Lab Steps

### Step 1: Log into AWS Console

1. Navigate to https://aws.amazon.com/
2. Click **Sign into console**
3. **IMPORTANT:** After logging in, change to your local region (e.g., **Frankfurt (eu-central-1)**) using the region selector in the top right of the AWS Console
   - This step is critical - the CloudFormation template will deploy to whatever region is selected
   - If you skip this step, resources will be created in the wrong region

### Step 2: Get CloudFormation Template from FortiCNAPP

1. Log into FortiCNAPP console at https://partner-demo.lacework.net/
2. Ensure tenant is set to **FORTINETEMEADEMO**
3. Navigate to **Settings** > **Integrations** > **Cloud accounts**
4. Click **Add New**
5. Select **Amazon Web Services** as the cloud provider
6. Choose **CloudFormation** as the integration method
7. In the **Choose integration type** dropdown, select **CloudTrail+Configuration**
8. Click **Run CloudFormation Template**
9. This will open the CloudFormation stack creation page in your chosen AWS session (already logged in from Step 1)

### Step 3: Configure and Deploy CloudFormation Stack

The CloudFormation template should now be open in your AWS Console on Step 1 (Create stack). The template URL should already be populated. Configure the stack:

1. Create Stack: Click **Next** to proceed to the next step
2. Specify stack details: Review the parameters and leave them as default
   - The default configuration will create a new CloudTrail trail
   - Stack name will be pre-populated (e.g., `AWS-CloudTrail`)
   - API Token and other parameters are pre-configured
   - Click **Next** to proceed to the next step
3. Configure Stack Options: Leave as default (no changes needed)
   - In the **Capabilities** section, check the **I acknowledge that AWS CloudFormation might create IAM resources with custom names** checkbox
   - Click **Next** to proceed to the next step
4. Review and Create Stack: 
   - Review the stack details and leave as default
   - Click **Submit** to deploy the stack
   - Monitor the stack creation progress. Refresh via the **Refresh** buttons next to 'Stacks' and 'Events'.
   - Review Resources to see the resources created by the stack.
   - Review Outputs to see the outputs of the stack.
   - Review Events to see the events of the stack.
   - Wait for stack status to show **CREATE_COMPLETE**
   - Click **Close** to close the stack creation page

### Step 4: Review CloudFormation Resources

After the stack creation is complete, review the resources that were created:

#### Review CloudFormation Outputs

1. In the CloudFormation stack details page, click on the **Outputs** tab
2. Review the outputs, including the **RoleARN**
   - This is the cross-account access role that FortiCNAPP uses to access your AWS account
   - Note this value for reference

#### Review CloudTrail

1. Navigate to **CloudTrail** service in AWS Console
2. Click on **Trails** in the left navigation
3. Find the trail that was created (it will have a name ending in `-laceworkcws`, e.g., `AWS-CloudTrail-laceworkcws`)
4. Click on the trail name to view details
5. Review the **General details** section:
   - Verify **SNS notification delivery** is enabled
     - This is how FortiCNAPP receives notifications when the CloudTrail is updated
   - Note the **Trail log location** (S3 bucket name)
     - This is the S3 bucket where CloudTrail logs are stored
     - If integrating to an existing CloudTrail, you would need these details

#### Review IAM Role

1. Navigate to **IAM** service in AWS Console
2. Click on **Roles** in the left navigation
3. Find the IAM role that was created (it will be related to the CloudFormation stack name) through the search bar
4. Click on the role name to view details
5. Review the role's permissions and trust relationships
   - The trust relationship will show that FortiCNAPP (Lacework) can assume this role

### Step 5: Verify Integration in FortiCNAPP

1. Return to FortiCNAPP console
2. Navigate to **Settings** > **Integrations** > **Cloud accounts**
3. Verify the AWS account appears in the list with Type 'Configuration' and 'CloudTrail'
   - You may need to refresh the browser to see the new integration.

## Expected Results

- CloudFormation stack successfully deployed in AWS
- CloudTrail trail created with name ending in `-laceworkcws`
- CloudTrail SNS notification delivery enabled
- CloudTrail log location (S3 bucket) identified
- IAM role created and reviewed
- AWS CloudTrail and Configuration integrated with FortiCNAPP
