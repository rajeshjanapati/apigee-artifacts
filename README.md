# Apigee Artifacts

Welcome to the Apigee Artifacts repository! This repository contains details about Apigee X artifacts, including Proxies, SharedFlows, Environment Config Variables like Key-Value Maps (KVMs), Target Servers, Environment-level proxies, organization-level KVMs, developer details, App details, API Product details, and master proxy deployment details. These artifacts are managed and implemented using Apigee Management APIs within PowerShell scripts, integrated with GitHub Actions workflows.

**Key Focus Areas:**
- Apigee X
- GitHub Actions Workflow
- Apigee API Management APIs
- PowerShell Scripting

**Overview:**

This project automates the nightly extraction of Apigee X Artifacts. The workflow is scheduled to run at specific times using cron expressions. When executed, the workflow utilizes Apigee Management APIs to create Proxies, SharedFlows, Environment Config Variables, and more within this GitHub repository. Each item is detailed and documented as part of the process.

Please find the nightly extracted data of apigee-x in the artifacts branch, for configuration variables like KVMs, Apps data has been encrypted, including KVM Entries, consumer key, and consumer secret, and stored in specific file paths at both the organization and environment levels. For each extracted item, in-depth details are provided to offer a comprehensive understanding. Proxies and shared flows, for instance, include information such as policies, base paths, and deployed environments, stored at respective filepaths for both organization and environment levels. Developers and API Products have their complete details stored in respective file paths.

**Specific Features:**
* Export all artifacts from Apigee X and Push changes Github
* Handling Newly created artifacts
* Handling Deleted Artifacts, if any user performed a hard delete


For a comprehensive list of Apigee API Management APIs, please visit the [Apigee API Management APIs page](https://cloud.google.com/apigee/docs/reference/apis/apigee/rest).

For any questions or contributions, please feel free to reach out and collaborate with us!
