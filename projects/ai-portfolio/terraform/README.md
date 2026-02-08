# How to generate required infra

- Create lambda functions and related IAM roles
```
cd stacks/lambda
terraform init
terraform apply
```
- Add a file terraform.tfvars in stacks/api-gateway-utilities containing your own AWS-managed domain
```
my_domain   = "my-amazing-domain.com"
```
- Create api subdomain and related API Gateway settings
```
cd stacks/api-gateway-utilities
terraform init
terraform apply
```
