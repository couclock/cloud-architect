# How to generate required infra

- Create remote state storage
```
cd stacks/remote-state-storage
terraform init
terraform apply
```

- Create IAM role required for lambda functions
```
cd stacks/common-lambda
terraform init
terraform apply
```

- Create yFinance lambda functions
```
cd stacks/yfinance-lambda
terraform init
terraform apply
```

- Create api subdomain and related API Gateway settings
```
cd stacks/api-gateway-utilities
terraform init
terraform apply
```
