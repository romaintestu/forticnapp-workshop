# Lab 1: Hands-on Cloud Security with FortiCNAPP

## Objectives

- Understand FortiCNAPP capabilities
- Navigate the FortiCNAPP console
- Review key security features and dashboards

## Prerequisites

- Email address for sign-in
- Web browser
- Access to email inbox for sign-in link

## Lab Steps

### Step 1: Access FortiCNAPP Console

*Goal: Access the FortiCNAPP demo environment and select the appropriate tenant.*

1. Navigate to https://partner-demo.lacework.net/
2. Enter your email address
3. Click **Get sign in link**
4. Check your email and click the sign-in link
5. Select the **FORTIDEMO** tenant from the bottom of the navigation drawer
6. Review the main dashboard

### Step 2: Explore Discovery Features

*Goal: Use Discovery features to identify security risks and investigate application behavior in the cloud environment.*

#### Resource Inventory

*Goal: Identify EC2 instances with the highest security risk based on vulnerability counts.*

1. Navigate to **Discovery** > **Resource Inventory** in the left navigation panel
2. Filter by **Resource Type = ec2:instance** using the filter dropdown
3. Sort the table by **Vulnerabilities** (click the Vulnerabilities column header or use the "Sort: Vulnerabilities" option)
4. Review the table to identify which EC2 instances have the highest number of vulnerabilities

#### Search

*Goal: Investigate application behavior in the cloud environment.*

1. Click the **Search** icon in the left navigation panel
2. Search for **datacollector** (this is the FortiCNAPP agent application)
3. In the search results, click on **datacollector**
4. Review the application details to investigate what datacollector is doing in the cloud environment
5. Answer the following questions:
   - What is the datacollector memory usage trend?
   - What is the CPU usage percentage?

### Step 3: Explore Threat Center Features

*Goal: Investigate security alerts and analyze the timeline of events for potential threats.*

#### Alerts

1. Navigate to **Threat Center** > **Alerts** in the left navigation panel
2. Filter by **past 3 months** using the date range selector
3. Filter for **Composite** alerts using the alert category filter
4. Open the **Potentially Compromised AWS Keys** alert
5. Click on the **Observations** tab to see the timeline of events
6. Review the intrusion graph and observations table to understand the sequence of activities

### Step 4: Explore Risk Center Features

*Goal: Analyze security risks across attack paths, compliance, identities, vulnerabilities, and code security.*

#### Attack Path

1. Navigate to **Risk Center** > **Attack Path** > **Top Work Items** in the left navigation panel
2. In the **Top risky paths with exposed secrets** section, select an entry from the table
3. Click **View Attack Path** in the **Action** column
4. Investigate the attack path and answer the following questions:
   - What secret is exposed on the EC2 instance?
   - What compliance violations are present?
5. Review the security group configuration:
   - Scroll down to the security group to view details
   - Navigate to the **Configuration** tab
   - Review the **Inbound Rules** section
   - What inbound rules have open ports?
6. Review the exposed identity:
   - Scroll down to the identity section in the attack path
   - What does the exposed identity have access to do?

#### Compliance

*Goal: Review compliance posture and identify violations against security frameworks.*

1. Navigate to **Risk Center** > **Compliance** > **Cloud** in the left navigation panel
2. Click on **CIS Amazon Web Services Foundations Benchmark** framework
3. Click the filter icon under **By section**
4. Filter by **non-compliant resources**
5. Click into the policy **Ensure that S3 is configured with 'Block Public Access' enabled**
6. Review the policy details. How many S3 buckets are non-compliant?
7. Click **View context** to understand the policy context

#### Identities

*Goal: Analyze identity and access management risks in the cloud environment.*

1. Navigate to **Risk Center** > **Identities** in the left navigation panel
2. Select the **Top identity risks** tab
3. Choose an identity from the list
4. Click **Investigate** to view identity details
5. Review the **Granted vs. used entitlements** chart. How many granted vs used entitlements are shown?

#### Vulnerabilities

*Goal: Identify and prioritize vulnerabilities across cloud resources.*

1. Navigate to **Risk Center** > **Vulnerabilities** > **Vulnerabilities[New]** in the left navigation panel
2. Click **Explore: Hosts**
3. Review the list. How many hosts are vulnerable?
4. Click **Filter**
5. Add a clause: **Package** > **Package status** = **Active**
6. Scroll to the bottom and click **Search**
7. Review the list again. How many hosts are vulnerable with active packages?

#### Code Security

*Goal: Review code security findings and software composition analysis results.*

1. Navigate to **Risk Center** > **Code Security** > **Infrastructure (IaC)** in the left navigation panel
2. Choose a repository from the list
3. Review the latest assessment
4. Navigate to **Risk Center** > **Code Security** > **Applications** in the left navigation panel
5. Select the **Vulnerabilities: Hard-coded secrets** tab
6. Click on **Aws Credentials**
7. Find the code where the access key has been published

### Step 5: Explore Governance Features

*Goal: Review security policies across different categories to understand policy management and coverage.*

#### Policies

1. Navigate to **Governance** > **Policies** in the left navigation panel
2. Review policies in the **Compliance** tab
3. Review policies in the **Threats** tab
4. Review policies in the **Vulnerabilities: Build time** tab (Build and Runtime)
5. Review policies in the **Anomalies** tab

### Step 6: Configure Settings and Review Integration Options

*Goal: Configure user settings and understand available methods for integrating FortiCNAPP with cloud environments.*

#### Change Tenant

1. Select the **FORTINETAPACDEMO** tenant from the bottom of the navigation drawer

#### My Settings

1. Select **My Settings** > **My profile** in the Settings navigation panel
2. Disable the default email notification

#### Integrations

1. Navigate to **Integrations** > **Cloud accounts** in the Settings navigation panel
2. Review the integrations available
3. Review the integration options available in the Integrations section

## Next Steps

Proceed to [Lab 2: Integrate AWS Inventory via CloudFormation](../lab-02/README.md)

