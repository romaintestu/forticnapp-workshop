# Lab 9: Code Security for Infrastructure as Code (IaC)

## Objectives

- Clone a repository containing Terraform code with security issues
- Install and configure the Lacework IaC scanning component
- Scan Terraform code for security vulnerabilities and misconfigurations
- Review scan results and understand security findings

## Prerequisites

- Completed [Lab 7: Install Lacework CLI and Terraform](../lab-07/README.md)
- Lacework CLI configured with FortiCNAPP credentials
- AWS CloudShell access

## Lab Steps

### Step 1: Open AWS CloudShell

1. Log into AWS Console at https://aws.amazon.com/
2. Change the region to **Asia Pacific (Singapore)** using the region selector in the top right
3. Click the **CloudShell** icon in the top navigation bar
4. Wait for CloudShell to initialize

### Step 2: Clone the Example Repository

Clone the repository containing Terraform code with intentional security issues:

```bash
cd ~
git clone https://github.com/andrewbearsley/lacework-iac-scan-example.git
cd lacework-iac-scan-example/example-terraform
```

This repository contains Terraform configurations with various security issues that FortiCNAPP can detect.

### Step 3: Verify Lacework CLI Configuration

Ensure your Lacework CLI is still configured:

```bash
lacework api get /api/v2/UserProfile
```

If you need to reconfigure, run:

```bash
lacework configure
```

### Step 4: Install the IaC Component

Install the Lacework IaC scanning component:

```bash
lacework component install iac
```

This installs the Infrastructure as Code scanner that can analyze Terraform, CloudFormation, and other IaC formats.

### Step 5: Update the IaC Component (Optional)

If the component is already installed, update it to ensure you have the latest version:

```bash
lacework component update iac
```

### Step 6: Scan the Terraform Code

Run the IaC scan on the current directory:

```bash
lacework iac scan
```

This will:
- Analyze the Terraform files in the current directory
- Detect security misconfigurations and vulnerabilities
- Upload the scan results to FortiCNAPP
- Display findings in the terminal

### Step 7: Review Scan Results

The scan output will show:
- Total number of findings
- Policy IDs and severity levels (Critical, High, Medium, Low)
- File paths and line numbers where issues are found
- Whether each finding passed or failed
- Upload reference for viewing results in the FortiCNAPP console

Review the findings and note:
- How many critical and high severity issues were found
- What types of security issues are present (encryption, access controls, networking, etc.)
- Which files contain the most security issues

## Expected Results

- Repository successfully cloned to CloudShell
- IaC component installed and updated
- Terraform code scanned for security issues
- Multiple security findings detected (the example repository contains over 100 intentional security issues)

## Additional Resources

- [Lacework IaC Scanning Documentation](https://docs.fortinet.com/document/lacework-forticnapp/latest/administration-guide/651014/getting-started-with-opal)
- [Example Repository](https://github.com/andrewbearsley/lacework-iac-scan-example)



