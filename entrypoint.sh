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

# check aws creds not for production use
echo "$AWS_ACCESS_KEY_ID";
echo "$AWS_SECRET_ACCESS_KEY";
cat $INPUT_BASE_CONF_VAR

cd /workspace/Base_Infra/
terraform init -backend-config="./env/base.config"
terraform plan -var-file="$INPUT_BASE_CONF_VAR"
terraform $INPUT_ACTION -var-file="$INPUT_BASE_CONF_VAR"

cd /workspace/Platform_Infra/
terraform init -backend-config="./env/platform.config"
terraform plan -var-file="$INPUT_PLATFORM_CONF_VAR"
terraform $INPUT_ACTION -var-file="$INPUT_PLATFORM_CONF_VAR"

