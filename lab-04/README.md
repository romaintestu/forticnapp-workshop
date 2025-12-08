# Lab 4: Install Linux Agent

## Objectives

- Install FortiCNAPP agent on Linux EC2 instance

## Prerequisites

- AWS account with EC2 launch permissions

## Lab Steps

### Step 1: Log into AWS Console

1. Navigate to https://aws.amazon.com/
2. Click **Sign into console**
3. After logging in, change the region to **Asia Pacific (Singapore)** using the region selector in the top right of the AWS Console

### Step 2: Create Linux EC2 Instance

1. Navigate to **EC2** service in AWS Console
2. Click **Launch Instance**
3. Configure the instance:
   - **Name**: Enter a name (e.g., `FortiCNAPP-Linux-Agent`)
   - **Application and OS Images**: Select **Ubuntu**
   - **Instance type**: Select **t3.micro**
   - **Key pair (login)**: Select **Proceed without a key pair** (we'll use EC2 Instance Connect)
4. **Network settings**:
   - Use default
   - The default security group will allow SSH traffic, providing external access to your instance
5. **Configure storage**: Leave default (8 GB gp3)
6. Click **Launch Instance**
7. Wait for the instance to reach **Running** status

### Step 3: Get Agent Installation URL from FortiCNAPP

1. Log into FortiCNAPP console at https://partner-demo.lacework.net/
2. Ensure tenant is set to **FORTINETAPACDEMO**
3. Navigate to **Settings** > **Configuration** > **Agent tokens**
4. Find an existing Linux agent token in the list
5. Click the **Actions** ellipsis (three dots) for the token
6. Select **Install**
7. In the installation panel, expand **Lacework Script (recommended)**
8. Click **Copy URL** to copy the installation script URL
9. Keep this URL ready - you'll use it in the next step

### Step 4: Connect to Linux EC2 Instance

1. In AWS Console, navigate to **EC2** service
2. Click on **Instances** in the left navigation
3. Select the Linux EC2 instance you just created
4. Click **Connect**
5. Select **EC2 Instance Connect** tab
6. Click **Connect** (this will open a browser-based terminal - no key pair needed)
7. Once connected, verify system requirements:
   - Check available memory: `free -h`
   - Verify network connectivity: `ping -c 3 8.8.8.8`
   - Confirm sudo access: `sudo whoami`

### Step 5: Install Agent

In the EC2 Instance Connect terminal, run the following commands:

1. Download the installation script using the URL you copied in Step 3:
```bash
wget <paste-the-copied-url-here>
```

2. Make the script executable:
```bash
chmod +x install.sh
```

3. Execute the installation script:
```bash
sudo ./install.sh
```

The script will automatically install and configure the FortiCNAPP agent (datacollector) with the correct account and token.

### Step 6: Verify Agent Installation

1. Check the agent status using the datacollector binary:
```bash
sudo /var/lib/lacework/datacollector -status
```

This will return JSON output showing the agent status (e.g., `{"Version":2,"Datacollector":{"Status":"ACTIVE",...}}`). A status of "ACTIVE" indicates the agent is running and connected.

2. Check for agent logs:
```bash
ls -la /var/log/lacework/
```

3. Tail the agent log to see real-time activity:
```bash
sudo tail -f /var/log/lacework/datacollector.log
```
Press `Ctrl+C` to stop tailing the log.

## Expected Results

- Agent installed and running on Linux instance
