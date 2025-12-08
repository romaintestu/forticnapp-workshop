# Lab 5: Install Windows Agent

## Objectives

- Install FortiCNAPP agent on Windows EC2 instance

## Prerequisites

- AWS account with EC2 launch permissions

## Lab Steps

### Step 1: Log into AWS Console

1. Navigate to https://aws.amazon.com/
2. Click **Sign into console**
3. After logging in, change the region to **Asia Pacific (Singapore)** using the region selector in the top right of the AWS Console

### Step 2: Create Windows EC2 Instance

1. Navigate to **EC2** service in AWS Console
2. Click **Launch Instance**
3. Configure the instance:
   - **Name**: Enter a name (e.g., `FortiCNAPP-Windows-Agent`)
   - **Application and OS Images**: Select **Microsoft Windows Server** (Windows Server 2022 or later)
   - **Instance type**: Select **t3.micro** or **t3.small**
   - **Key pair (login)**: 
     - Click **Create new key pair**
     - Enter a key pair name (e.g., `forticnapp-windows-key`)
     - Select **RSA** as the key pair type
     - Select **.pem** format
     - Click **Create key pair**
     - **Important**: Download the key pair file and save it securely - you'll need it to retrieve the Windows password
4. **Network settings**:
   - Use default
   - The default security group will allow RDP traffic, providing access to your instance
5. **Configure storage**: Leave default (30 GB gp3)
6. Click **Launch Instance**
7. Wait for the instance to reach **Running** status

### Step 3: Get Windows Password and Connect

1. In AWS Console, navigate to **EC2** service
2. Click on **Instances** in the left navigation
3. Select the Windows EC2 instance you just created
4. Click **Connect**
5. Select **RDP Client** tab
6. Click **Get Password** (you may need to wait for a few minutes after the instance is running)
7. Upload your key pair file (.pem) to decrypt the password
8. Copy the **Administrator password**
9. Click **Download remote desktop file** to download the RDP connection file
10. Open the downloaded RDP file:
    - **Windows**: Double-click the file to open it in Remote Desktop Connection
    - **Mac**: Right-click and open with Windows app (previously known as Microsoft Remote Desktop app)
11. When prompted, enter the **Administrator password** you copied in step 8
12. **Note**: You may see a certificate warning when connecting - this is normal for EC2 instances. Click **Continue** to proceed.
13. If the credentials don't work:
    - Wait a few more minutes - Windows instances can take 3-5 minutes to fully initialize
    - Make sure you copied the password correctly (it's case-sensitive)
    - Try clicking **Get Password** again in the AWS Console to refresh
    - Ensure you're using **Administrator** (with capital A) as the username
14. Once connected, open **PowerShell as Administrator**:
    - Right-click the **Start** button and select **Windows PowerShell (Admin)** or **Terminal (Admin)**
    - Or search for "PowerShell" in the Start menu, right-click it, and select **Run as administrator**
    - Or press **Windows key + X** and select **Windows PowerShell (Admin)** or **Terminal (Admin)**

### Step 4: Get Agent Installation Information from FortiCNAPP

1. Log into FortiCNAPP console at https://partner-demo.lacework.net/
2. Ensure tenant is set to **FORTINETAPACDEMO**
3. Navigate to **Settings** > **Configuration** > **Agent tokens**
4. Find an existing Windows agent token in the list
5. Click the **Actions** ellipsis (three dots) for the token
6. Select **Install**
7. In the installation panel:
   - Expand **Lacework PowerShell Script (recommended)** section
   - Click **Copy URL** to copy the PowerShell script ZIP URL (for downloading the script)
   - Expand **MSI Package** section
   - Click **Copy URL** to copy the MSI package URL (you'll need this for the MSIURL parameter)
   - **Important**: Also copy the **Access Token** value shown in the installation panel (you'll need this for the AccessToken parameter)
8. Keep the PowerShell script URL, MSI URL, and Access Token ready - you'll use them in the next step

### Step 5: Install Agent

On the Windows EC2 instance (via RDP, in PowerShell as Administrator):

1. Download the installation package using the URL you copied in Step 4:
```powershell
Invoke-WebRequest -Uri "<paste-the-copied-url-here>" -OutFile "install.zip"
```

2. Extract the ZIP file:
```powershell
Expand-Archive -Path "install.zip" -DestinationPath "install" -Force
```

3. Navigate to the extracted folder and check the contents:
```powershell
cd install
ls
```

4. Navigate into the `signed-scripts` directory:
```powershell
cd signed-scripts
```

5. Execute the installation script with all required parameters:
   - Replace `<your-token>` with the Access Token you copied from FortiCNAPP
   - Replace `<msi-url>` with the MSI URL you copied from the MSI Package section
```powershell
.\Install-LWDataCollector.ps1 -AccessToken "<your-token>" -ServerURL "https://partner-demo.lacework.net" -MSIURL "<msi-url>"
```

The script will automatically install and configure the FortiCNAPP agent with the correct account and token.

### Step 6: Verify Agent Installation

1. Check the agent service status (the service is named `LWDataCollector`):
```powershell
Get-Service -Name LWDataCollector
```

2. Check the agent installation directory:
```powershell
ls C:\ProgramData\Lacework\
```

3. Check for agent logs:
```powershell
ls C:\ProgramData\Lacework\Logs\
```

## Expected Results

- Agent installed and running on Windows instance
- LWDataCollector service running
- Installation directory exists at `C:\ProgramData\Lacework\`
- Log files present in `C:\ProgramData\Lacework\Logs\`
