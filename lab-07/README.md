# Lab 7: Install Lacework CLI and Terraform

## Objectives

- Install the Lacework CLI tool in AWS CloudShell
- Configure CLI with FortiCNAPP credentials
- Install Terraform in AWS CloudShell
- Verify CLI and Terraform installations

## Prerequisites

- AWS account access
- FortiCNAPP account credentials

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

This directory will be used for both Lacework CLI and Terraform installations.

### Step 3: Install Lacework CLI

In the CloudShell terminal, run:

```bash
curl https://raw.githubusercontent.com/lacework/go-sdk/main/cli/install.sh | bash -s -- -d "$HOME/bin"
```

This will download and install the Lacework CLI tool to your home bin directory.

**Note**: For Windows installation (if needed outside CloudShell), download from the [Lacework CLI releases page](https://github.com/lacework/go-sdk/releases).

### Step 4: Create Service User in FortiCNAPP

Before creating an API key, you need to create a new service user with the appropriate permissions:

1. Log into FortiCNAPP console at https://partner-demo.lacework.net/
2. Ensure tenant is set to **FORTINETAPACDEMO**
3. Navigate to **Settings** > **Access Control** > **Users**
4. Click **Add New**
5. Choose **User Type**: **Service User**
6. Fill in the service user details:
   - **Name**: Enter a name (e.g., `[Your Name] Service User`)
   - **Description**: Enter a description (e.g., `lab-07`)
7. Click **Next**
8. Add the **'Cloud Integrations'** user group to grant the necessary permissions
9. Complete the service user creation

### Step 5: Create API Key in FortiCNAPP

Now create an API key attached to the service user you just created:

1. Navigate to **Settings** > **Configuration** > **API keys**
2. Click **Create API key**
3. Fill in the API key details:
   - **Name**: Enter a name (e.g., `service-user-api-key`)
   - **Description**: Enter a description (e.g., `lab-07`)
   - **Assign this to a service user**: Toggle this **ON**
   - **Select a service user**: Choose the service user you just created (e.g., `[Your Name] Service User`)
4. Click **Save**
5. **Important**: Copy the **API Key** and **API Secret** immediately - you won't be able to see the secret again after closing the dialog
6. Keep these credentials ready for the next step

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

### Step 8: Install Terraform

Install Terraform in AWS CloudShell:

1. Download Terraform (Linux amd64) and unzip it to your bin folder:

First, get the latest Terraform version:

```bash
TERRAFORM_VERSION=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
```

Then download and install that version:

```bash
wget -O terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip terraform.zip
mv terraform "$HOME/bin/"
rm terraform.zip
# Configure Terraform to use the temporary directory for cache to prevent running out of cloudshell storage space
echo 'export TF_PLUGIN_CACHE_DIR="/tmp"' >> ~/.bashrc
source ~/.bashrc
```

**Alternative**: If you prefer to check manually, visit [HashiCorp's Terraform releases page](https://releases.hashicorp.com/terraform/) and replace `${TERRAFORM_VERSION}` in the URL with the latest version number (e.g., `1.9.5`).


## Expected Results

- Lacework CLI installed and configured in AWS CloudShell
- CLI connectivity verified with FortiCNAPP
- Terraform installed and accessible from command line

