
# ecs-action-test Repository

This repository contains a GitHub Action for deploying an ECS infrastructure using Terraform. You can use this action to automate the setup and management of your ECS infrastructure.

## Workflow Configuration

To use this GitHub Action, you need to create a workflow configuration. Create a `.github/workflows/main.yml` file in your repository and add the following content:

```yaml
name: Test ECS action
on: workflow_dispatch

jobs:
  test-action:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Run ECS Infrastructure Action
        uses: quantumci/ecs-action-test@v1.0.0       # Replace with the correct GitHub Action reference, e.g., quantumci/ecs-action-test@v1.0.0
        with:
          base_conf_var: ./Base_Infra/config.tfvars
          platform_conf_var: ./Platform_Infra/config.tfvars
          aws_access_key: ${{ secrets.AWS_ACCESS_KEY }} # add Secretes variables 
          aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }} # add Secretes variables
          aws_default_region: us-east-1
          remote_bucket_name: test-123-ecs # add your own s3 bucket name
          remote_bucket_region: us-east-1 # add your own s3 bucket region
          action: apply
         
```


## Usage

1. Create a workflow file as shown above.
2. Customize the input variables as needed.
3. Trigger the workflow manually using the "workflow_dispatch" event or through other triggers that suit your needs.

## Inputs

- `base_conf_var`: Path to the base configuration file (e.g., `./Base_Infra/config.tfvars`).
- `platform_conf_var`: Path to the platform configuration file (e.g., `./Platform_Infra/config.tfvars`).
- `aws_access_key`: AWS access key (stored as a secret).
- `INPUT_AWS_SECRET_ACCESS_KEY`: AWS secret access key (stored as a secret).
- `aws_secret_access_key`: AWS region (e.g., `us-east-1`).
- `remote_bucket_name`: Your S3 bucket name.
- `remote_bucket_region`: S3 bucket region.
- `action`: Action to perform (e.g., `apply`).

Remember to set up your AWS credentials as secrets in your repository to keep them secure.

## Trigger With Inputs
```yaml
name: Test ECS action
on: 
  workflow_dispatch:
      inputs:
        action_input:
          description: 'Action to perform'
          required: true
          default: 'test'
          type: choice
          options:
            - test
            - apply
            - destroy
            - validate

jobs:
  test-action:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: run local actions
        uses: quantumci/ecs-action-test@v1.0.0   # Replace with the correct GitHub Action reference, e.g., quantumci/ecs-action-test@v1.0.0
        with:
          existing_base_infra: no
          existing_platform_infra: yes
          base_conf_var: ./Base_Infra/config.tfvars
          platform_conf_var: ./Platform_Infra/config.tfvars
          aws_access_key: ${{ secrets.AWS_ACCESS_KEY }} # add Secretes variables 
          aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }} # add Secretes variables
          aws_default_region: us-east-1
          remote_bucket_name: test-123-ecs # add your own s3 bucket name
          remote_bucket_region: us-east-1 # add your own s3 bucket region
          action: ${{ inputs.action_input }}
```
