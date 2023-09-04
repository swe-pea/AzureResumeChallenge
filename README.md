# Azure Hosted Static Blog Site (Cloud Challenge) 

Check it out here: [cuauh.codes](https://www.cuauh.codes/)

## Overview 
This is a simple blog built with Azure Storage static website hosting, and Azure serverless architecture inspired by the cloud resume challenge. I'm building this site to showcase cloud computing experience while also taking the opportunity to become more proficient in C#, web development, and various other skills listed in the [cloud resume challenge - Azure](https://cloudresumechallenge.dev/docs/the-challenge/azure/#9-api). In addition, I will add blog posts where I'll write development topics that interest me and work on improving my technical writing skills!

### Technologies/Tools used
- [Azure DevOps](https://azure.microsoft.com/en-us/products/devops/) (YAML)
- C# & .NET Core6
- HTML, CSS, & JavaScript
- [Terraform](https://www.terraform.io/)
- [Azure Cosmos DB](https://azure.microsoft.com/en-us/products/cosmos-db)
- Powershell & Bicep

### Architecture
The solution contains 3 automation pipelines:
- **frontend-pipeline.yml:** Deploy/updates HTML, CSS, JavaScript static website
- **function-pipeline.yml:** Deploy/updates .NET Core Azure Function App backend
- **iac-automation.yml:** Runs Terraform & Bicep for resource provisioning

## Current Status
The project is currently in an "MVP" / first itteration stage of development. So far, I have completed the following challenge requirements:

:heavy_check_mark: Automate resource provisioning \
:heavy_check_mark: Setup website (HTTPS, DNS, CI/CD) \
:heavy_check_mark: Render visitor count from DB \
:heavy_check_mark: Setup & deployed the website (HTTPS, DNS, CI/CD) \
:heavy_check_mark: Setup & deployed Azure Function w/an HTTP trigger for DB

## Planned Features
- [ ] Add code testing in CI pipelines
- [ ] Improve website layout

## Running the project
1. Clone the repository
2. Create & configure pipelines in Azure DevOps using existing yaml files
3. Define & set pipeline variables according to your azure environment (subscription, terraform settings, etc..)
4. Run iac-automation.yml, then the other pipelines, modifying variables to work with your specific Azure environment
