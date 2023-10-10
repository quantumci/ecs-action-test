
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
          base_conf_var: ./Base_Infra/config.tfvars # Replace with the correct path
          platform_conf_var: ./Platform_Infra/config.tfvars # Replace with the correct path
          INPUT_AWS_ACCESS_KEY: ${{ secrets.AWS_ACCESS_KEY }}
          INPUT_AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          INPUT_AWS_DEFAULT_REGION: us-east-1
          INPUT_REMOTE_BUCKET_NAME: test-123-ecs # Replace with your own S3 bucket name
          INPUT_REMOTE_BUCKET_REGION: us-east-1 # Replace with your own S3 bucket region
          INPUT_ACTION: apply
```


## Usage

1. Create a workflow file as shown above.
2. Customize the input variables as needed.
3. Trigger the workflow manually using the "workflow_dispatch" event or through other triggers that suit your needs.

## Inputs

- `base_conf_var`: Path to the base configuration file (e.g., `./Base_Infra/config.tfvars`).
- `platform_conf_var`: Path to the platform configuration file (e.g., `./Platform_Infra/config.tfvars`).
- `INPUT_AWS_ACCESS_KEY`: AWS access key (stored as a secret).
- `INPUT_AWS_SECRET_ACCESS_KEY`: AWS secret access key (stored as a secret).
- `INPUT_AWS_DEFAULT_REGION`: AWS region (e.g., `us-east-1`).
- `INPUT_REMOTE_BUCKET_NAME`: Your S3 bucket name.
- `INPUT_REMOTE_BUCKET_REGION`: S3 bucket region.
- `INPUT_ACTION`: Action to perform (e.g., `apply`).

Remember to set up your AWS credentials as secrets in your repository to keep them secure.
