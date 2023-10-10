#!/bin/bash

# Update the values in the config file
config1_file="/workspace/Base_Infra/env/base.config"
config2_file="/workspace/Platform_Infra/env/platform.config"

sed -i "s/bucket=\"[^\"]+\"/bucket=\"$INPUT_REMOTE_BUCKET_NAME\"/g" "$config1_file"
sed -i "s/region=\"[^\"]+\"/region=\"$INPUT_REMOTE_BUCKET_REGION\"/g" "$config1_file"
sed -i "s/bucket=\"[^\"]+\"/bucket=\"$INPUT_REMOTE_BUCKET_NAME\"/g" "$config2_file"
sed -i "s/region=\"[^\"]+\"/region=\"$INPUT_REMOTE_BUCKET_REGION\"/g" "$config2_file"

# Set AWS Creds 
export AWS_ACCESS_KEY_ID=$INPUT_AWS_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$INPUT_AWS_SECRET_ACCESS_KEY

cd /workspace/Base_Infra/
cat $INPUT_BASE_CONF_VAR > config1.tfvars
terraform init -backend-config="./env/base.config"
terraform plan -var-file="./config1.tfvars"
terraform $INPUT_ACTION -var-file="./config1.tfvars"

cd /workspace/Platform_Infra/
cat $INPUT_PLATFORM_CONF_VAR > config2.tfvars
terraform init -backend-config="./env/platform.config"
terraform plan -var-file="./config2.tfvars"
terraform $INPUT_ACTION -var-file="./config2.tfvars"

