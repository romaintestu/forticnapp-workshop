# Lab 7: Install Lacework CLI and Terraform

## Objectives

- Install the Lacework CLI tool in AWS CloudShell
- Configure CLI with FortiCNAPP credentials
- Install Terraform in AWS CloudShell
- Verify CLI and Terraform installations

## Prerequisites

- Completed Lab 6
- AWS account access
- FortiCNAPP account credentials

## Lab Steps

### Step 1: Log into AWS Console and Open CloudShell

1. Navigate to https://aws.amazon.com/
2. Click **Sign into console**
3. After logging in, change the region to **Asia Pacific (Singapore)** using the region selector in the top right of the AWS Console
4. Click the **CloudShell** icon in the top navigation bar (cloud icon with `>_` symbol)
5. Wait for CloudShell to initialize (this may take a minute the first time)
6. Once CloudShell opens, you'll have a Linux-based terminal environment ready to use

### Step 2: Install Lacework CLI

In the CloudShell terminal, run:

```bash
curl https://raw.githubusercontent.com/lacework/go-sdk/main/cli/install.sh | sudo bash -s -- -d /usr/local/bin
```

This will download and install the Lacework CLI tool.

**Note**: For Windows installation (if needed outside CloudShell), download from the [Lacework CLI releases page](https://github.com/lacework/go-sdk/releases).

### Step 3: Create API Key in FortiCNAPP

Before configuring the CLI, you need to create an API key in the FortiCNAPP console:

1. Log into FortiCNAPP console at https://partner-demo.lacework.net/
2. Ensure tenant is set to **FORTINETAPACDEMO**
3. Navigate to **Settings** > **Configuration** > **API keys**
4. Click **Create API key**
5. Fill in the API key details:
   - **Name**: Enter a name (e.g., `service-user-api-key`)
   - **Description**: Enter a description (e.g., `AB lab`)
   - **Assign this to a service user**: Toggle this **ON**
   - **Select a service user**: Choose a service user from the dropdown (e.g., `LACEWORK_CLOUD_INTEGRATIONS_SERVICE_USER`)
6. Click **Save**
7. **Important**: Copy the **API Key** and **API Secret** immediately - you won't be able to see the secret again after closing the dialog
8. Keep these credentials ready for the next step

### Step 4: Configure CLI

In CloudShell, run:

```bash
lacework configure
```

Enter your FortiCNAPP account credentials when prompted:
- **Account**: Your FortiCNAPP account name (e.g., `partner-demo`)
- **API Key**: The API key you just created
- **API Secret**: The API secret you just copied

### Step 5: Verify CLI Installation

```bash
lacework version
lacework api get /api/v2/UserProfile
```

The second command should return your user profile information, confirming the CLI is properly configured and connected.

### Step 6: Install Terraform

CloudShell comes with Terraform pre-installed, but let's verify and update if needed:

```bash
terraform version
```

If Terraform is not installed or you need a specific version, install it:

```bash
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform version
```

### Step 7: Verify Terraform Installation

```bash
terraform version
```

This should display the Terraform version information.

## Expected Results

- Lacework CLI installed and configured in AWS CloudShell
- CLI connectivity verified with FortiCNAPP
- Terraform installed and accessible from command line

## Next Steps

Proceed to [Lab 8: Install integrations via Terraform](../lab-08/README.md)
