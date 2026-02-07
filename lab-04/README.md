# Lab 4: Install Lacework CLI and Trigger Inventory Scan

## Objectives

- Install the Lacework CLI tool in AWS CloudShell
- Configure CLI with FortiCNAPP credentials
- Verify AWS integrations from Labs 2 and 3
- Trigger an inventory scan to populate compliance data

## Prerequisites

- AWS account access
- FortiCNAPP account credentials
- Completed Lab 2 (AWS Inventory integration)

## Lab Steps

### Step 1: Log into AWS Console and Open CloudShell

1. Navigate to https://aws.amazon.com/
2. Click **Sign into console**
3. After logging in, change to your local region (e.g., **Asia Pacific (Singapore)**) using the region selector in the top right of the AWS Console
4. Click the **CloudShell** icon in the top navigation bar (cloud icon with `>_` symbol)
5. Wait for CloudShell to initialize (this may take a minute the first time)
6. Once CloudShell opens, you'll have a Linux-based terminal environment ready to use

### Step 2: Set Up Installation Directory

Create a bin directory in your home folder and add it to your PATH:

```bash
mkdir -p "$HOME/bin"
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

### Step 3: Install Lacework CLI

In the CloudShell terminal, run:

```bash
curl https://raw.githubusercontent.com/lacework/go-sdk/main/cli/install.sh | bash -s -- -d "$HOME/bin"
```

This will download and install the Lacework CLI tool to your home bin directory.

### Step 4: Create Service User in FortiCNAPP

Before creating an API key, you need to create a new service user with the appropriate permissions:

1. Log into FortiCNAPP console at https://partner-demo.lacework.net/
2. Ensure tenant is set to **FORTINETAPACDEMO**
3. Navigate to **Settings** > **Access Control** > **Users**
4. Click **Add New**
5. Choose **User Type**: **Service User**
6. Fill in the service user details:
   - **Name**: Enter a name (e.g., `[Your Name] Service User`)
   - **Description**: Enter a description (e.g., `lab-04`)
7. Click **Next**
8. Add the following user groups to grant the necessary permissions:
   - **'Cloud Integrations'** - Required for AWS integration management
   - **'Code Security Scanner'** - Required for code security scanning (Labs 10-11)
9. Complete the service user creation

### Step 5: Create API Key in FortiCNAPP

Now create an API key attached to the service user you just created:

1. Navigate to **Settings** > **Configuration** > **API keys**
2. Click **Create API key**
3. Fill in the API key details:
   - **Name**: Enter a name (e.g., `service-user-api-key-yourname`)
   - **Description**: Enter a description (e.g., `lab-04`)
   - **Assign this to a service user**: Toggle this **ON**
   - **Select a service user**: Choose the service user you just created (e.g., `[Your Name] Service User`)
4. Click **Save**
5. After saving, click on the ellipsis (three dots) next to the API key in the list and select **Download** to download the key as JSON.
6. Open the downloaded JSON file and note the **API Key** and **API Secret** values. Keep these credentials ready for the next step

### Step 6: Configure CLI

In CloudShell, run:

```bash
lacework configure
```

Enter your FortiCNAPP account credentials when prompted:
- **Account**: Your FortiCNAPP account name (e.g., `partner-demo`)
- **API Key**: The API key you just created
- **API Secret**: The API secret you just copied

### Step 7: Verify CLI Installation

```bash
lacework version
lacework api get /api/v2/UserProfile
```

The second command should return your user profile information, confirming the CLI is properly configured and connected.

### Step 8: List Cloud Account Integrations

Verify that the integrations from Labs 2 and 3 are visible:

```bash
lacework cloud-account list
```

You should see entries for your AWS account including:
- `AwsCfg` (Configuration integration from Lab 2)
- `AwsCtSqs` (CloudTrail integration from Lab 2)
- `AwsSidekick` (Agentless Workload Scanning from Lab 3, if completed)

### Step 9: Trigger Inventory Scan

Normally, FortiCNAPP collects resource inventory on a scheduled cycle (up to 24 hours). To avoid waiting, you can trigger an immediate scan.

```bash
lacework compliance aws scan
```

This triggers a resource inventory collection for all integrated AWS accounts. The scan will run in the background and takes 1-2 hours to complete. Once finished, compliance reports and resource inventory data will be populated in the FortiCNAPP console.

**Note:** Only one scan can run at a time. If another student has already triggered a scan, your request will be ignored until the current scan completes.

## Expected Results

- Lacework CLI installed and configured in AWS CloudShell
- CLI connectivity verified with FortiCNAPP
- AWS integrations from Labs 2 and 3 confirmed via CLI
- Inventory scan triggered to populate compliance data
