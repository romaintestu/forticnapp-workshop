# Lab 3: Integrate Agentless Workload Scanning via CloudFormation

## Objectives

- Integrate agentless workload scanning with FortiCNAPP using CloudFormation

## Lab Steps

### Step 1: Log into AWS Console

1. Navigate to https://aws.amazon.com/
2. Click **Sign into console**
3. After logging in, change the region to **Asia Pacific (Singapore)** using the region selector in the top right of the AWS Console

### Step 2: Get CloudFormation Template from FortiCNAPP

1. Log into FortiCNAPP console at https://partner-demo.lacework.net/
2. Ensure tenant is set to **FORTINETAPACDEMO**
3. Navigate to **Settings** > **Integrations** > **Cloud accounts**
4. Click **Add New**
5. Select **Amazon Web Services** as the cloud provider
6. Choose **CloudFormation** as the integration method, Click **Next**
7. In the **Choose integration type** dropdown, select **Agentless Workload Scanning (Single account)**
8. The configuration screen (Step 2 of 2 • Configuration) will appear
9. Configure the integration:
   - **Name**: Enter `Agentless Workload Scanning [your name]` (e.g., `Agentless Workload Scanning John Doe`)
   - **Scanning AWS Account ID**: Enter your AWS account ID
   - Leave all other options as default:
     - Limit Scanned Workloads: Leave empty (default)
     - Scan Frequency (hours): Leave as default (24 hours)
     - Scanning Options: Leave checkboxes as default
10. Click **Save** to save the integration configuration
11. A modal dialog will appear: "Next step: Run or download the CloudFormation template"
    - The modal explains that the integration will appear on the Cloud accounts page
    - You need to run or download the CloudFormation template to complete the integration
    - The template can be found in the detail page of this integration
12. Click **Got it** to close the modal
13. Navigate to the integration detail page:
    - The integration should now appear in the Cloud accounts list, in status 'Pending'
    - Click on the integration you just created to open its detail page
14. Click **Run CloudFormation Template** on the integration detail page
15. This will open the CloudFormation stack creation page in your chosen AWS session (already logged in from Step 1)

### Step 3: Configure and Deploy CloudFormation Stack

The CloudFormation template should now be open in your AWS Console on Step 1 (Create stack). The template URL should already be populated. Configure the stack:

1. Create Stack: Click **Next** to proceed to the next step
2. Specify stack details: Review the parameters
   - Enter a **Stack name** (e.g., `AWS-AgentlessScanning`). Stack name must contain only letters, numbers, hyphens. Must start with a letter.
   - In the **Scanner Deployment Configuration** section, find the **Regions** parameter
   - Set **Regions** to `ap-southeast-1` (this is the region where workloads exist and will be scanned)
   - In the **AWS Service Permissions** section, For **Quota Check**: "Can a new VPC and VPC Internet Gateway be created in each selected Region?"
   - Select **Yes** from the dropdown (this is required and not pre-populated)
   - API Token and other parameters are pre-configured
   - Click **Next** to proceed to the next step
3. Configure Stack Options: Leave as default (no changes needed)
   - In the **Capabilities** section, check both checkboxes:
     - **I acknowledge that AWS CloudFormation might create IAM resources with custom names**
     - **I acknowledge that AWS CloudFormation might require the following capability: CAPABILITY_AUTO_EXPAND**
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

### Step 4: Investigate ECS Cluster

After the CloudFormation stack completes, investigate the ECS cluster that was provisioned:

1. Navigate to **ECS** (Elastic Container Service) in AWS Console
2. Click on **Clusters** in the left navigation
3. Find the ECS cluster that was created by the CloudFormation stack
4. Click on the cluster name to view details
5. Review the cluster configuration and resources
6. Navigate to **Task Definitions** in the left navigation
7. Find the task definition related to the agentless scanning (look for "sidekick" in the name)

### Step 5: Verify Integration in FortiCNAPP

1. Return to FortiCNAPP console
2. Navigate to **Settings** > **Integrations** > **Cloud accounts**
3. Verify the AWS account appears in the list with Type 'Agentless Workload Scanning'
   - You may need to refresh the browser to see the new integration.

## Expected Results

- CloudFormation stack successfully deployed in AWS
- Agentless Workload Scanning integrated with FortiCNAPP

## Next Steps

Proceed to [Lab 4: Install Linux Agent](../lab-04/README.md)
