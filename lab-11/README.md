# Lab 11: Code Security for Applications (SCA)

## Objectives

- Clone a repository containing application code with security issues
- Install and configure the Lacework SCA (Software Composition Analysis) scanning component
- Scan application code for vulnerabilities, weaknesses, and license risks
- Review scan results and understand security findings
- Generate a Software Bill of Materials (SBOM)
- Generate scan reports in JSON and Markdown formats

## Prerequisites

- Completed [Lab 8: Install Lacework CLI and Terraform](../lab-08/README.md)
- Lacework CLI configured with FortiCNAPP credentials
- AWS CloudShell access

## Lab Steps

### Step 1: Open AWS CloudShell

1. Log into AWS Console at https://aws.amazon.com/
2. Change to your local region (e.g., **Frankfurt**) using the region selector in the top right
3. Click the **CloudShell** icon in the top navigation bar
4. Wait for CloudShell to initialize

### Step 2: Clone the Example Repository

Clone the repository containing application code with intentional security issues:

```bash
cd ~
git clone https://github.com/andrewbearsley/lacework-sca-scan-example.git
cd lacework-sca-scan-example
```

This repository contains JavaScript/TypeScript application code with various security vulnerabilities, weaknesses, and license risks that FortiCNAPP can detect.

### Step 3: Verify Lacework CLI Configuration

Ensure your Lacework CLI is still configured:

```bash
lacework api get /api/v2/UserProfile
```

If you need to reconfigure, run:

```bash
lacework configure
```

### Step 4: Install the SCA Component

Install the Lacework SCA scanning component:

```bash
lacework component install sca
```

This installs the Software Composition Analysis scanner that can analyze application dependencies, detect vulnerabilities, and identify license risks.

### Step 5: Update the SCA Component (Optional)

If the component is already installed, update it to ensure you have the latest version:

```bash
lacework component update sca
```

### Step 6: Scan the Application Code

Run the SCA scan on the current directory:

```bash
lacework sca scan .
```

This will:
- Analyze the application code and dependencies
- Detect vulnerabilities in third-party packages
- Identify security weaknesses (CWEs)
- Detect hard-coded secrets and credentials
- Identify license risks
- Upload the scan results to FortiCNAPP
- Display findings in the terminal

### Step 7: Review Scan Results

The scan output will show:
- Summary statistics (artifacts analyzed, vulnerabilities found, secrets detected, etc.)
- **Vulnerabilities**: List of CVEs with severity levels (Critical, High, Medium, Low)
  - Direct and transitive dependencies affected
  - CVE IDs and descriptions
- **Weaknesses**: Common Weakness Enumeration (CWE) findings
  - Hard-coded credentials
  - SQL injection vulnerabilities
  - Authentication issues
  - And more
- License risks detected
- Copyrights detected

Review the findings and note:
- How many critical and high severity vulnerabilities were found
- What types of weaknesses are present (hard-coded credentials, SQL injection, etc.)
- Which packages have the most vulnerabilities
- How many secrets were detected

### Step 8: Generate Software Bill of Materials (SBOM)

Generate a Software Bill of Materials in CycloneDX JSON format:

```bash
lacework sca scan ./ -f cdx-json -o sbom.json
```

This creates an SBOM file that lists all dependencies and their versions, which can be used for:
- Compliance reporting
- Supply chain security tracking
- Dependency management
- Security audits

View the generated SBOM:

```bash
cat sbom.json
```

### Step 9: Generate Scan Reports

Generate detailed scan reports in multiple formats for sharing and documentation:

**Generate JSON Report:**

```bash
lacework sca scan ./ -f json -o scan-report.json
```

This creates a comprehensive JSON report containing all scan findings, including:
- Vulnerability details with CVEs
- Weakness findings (CWEs)
- Detected secrets
- License information
- Package dependencies

View the JSON report:

```bash
cat scan-report.json
```

**Generate Markdown Report:**

```bash
lacework sca scan ./ -f md -o scan-report.md
```

This creates a human-readable Markdown report that includes:
- Executive summary
- Vulnerability breakdown by severity
- Detailed findings with descriptions
- Recommendations
- Package and dependency information

View the Markdown report:

```bash
cat scan-report.md
```

These reports can be:
- Shared with development teams
- Included in security documentation
- Used for compliance reporting
- Integrated into CI/CD pipelines
- Archived for audit purposes

## Expected Results

- Repository successfully cloned to CloudShell
- SCA component installed and updated
- Application code scanned for security issues
- Multiple vulnerabilities detected (the example repository contains intentional security issues including CVEs, hard-coded credentials, and license risks)
- SBOM generated successfully in CycloneDX JSON format
- Scan reports generated in JSON and Markdown formats
- Findings categorized by severity and type (vulnerabilities, weaknesses, licenses)

## Additional Resources

- [Lacework SCA Scanning Documentation](https://docs.fortinet.com/document/lacework-forticnapp/latest/administration-guide/433465/software-composition-analysis-sca)
- [Example Repository](https://github.com/andrewbearsley/lacework-sca-scan-example)


