#!/bin/bash

# Define Color escape codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Update the values in the config file
config1_file="/workspace/Base_Infra/env/base.config"
config2_file="/workspace/Platform_Infra/env/platform.config"

if [[ ! "$config1_file" || ! "$config2_file" ]]; then

    echo -e "${RED}Error: Configurations not found."
    exit 1
else
    sed -i "s/bucket=\"[^\"]+\"/bucket=\"$INPUT_REMOTE_BUCKET_NAME\"/g" "$config1_file"
    sed -i "s/region=\"[^\"]+\"/region=\"$INPUT_REMOTE_BUCKET_REGION\"/g" "$config1_file"
    sed -i "s/bucket=\"[^\"]+\"/bucket=\"$INPUT_REMOTE_BUCKET_NAME\"/g" "$config2_file"
    sed -i "s/region=\"[^\"]+\"/region=\"$INPUT_REMOTE_BUCKET_REGION\"/g" "$config2_file"

    echo -e "${GREEN} Remote backend suceesfully configured"
fi




# Check if AWS credentials are set

if [[ -z "$INPUT_AWS_ACCESS_KEY" || -z "$INPUT_AWS_SECRET_ACCESS_KEY" ]]; then

    echo -e "${RED}Error: AWS credentials not provided."

    exit 1
else
    # Set AWS Creds 
    export AWS_ACCESS_KEY_ID=$INPUT_AWS_ACCESS_KEY;
    export AWS_SECRET_ACCESS_KEY=$INPUT_AWS_SECRET_ACCESS_KEY;
    
    echo -e "${GREEN} AWS secret configured successful"

fi




# Validate the INPUT_ACTION variable (should be one of: plan, apply, destroy, etc.)

if [[ ! "$INPUT_ACTION" =~ ^(plan|apply|destroy|refresh|validate)$ ]]; then

    echo -e "${RED}Error: Invalid INPUT_ACTION. It should be one of: plan, apply, destroy, refresh, validate."

    exit 1

fi

if [["$INPUT_EXISTING_BASE_INFRA" == "no"]]; then
    cd /workspace/Base_Infra/
    echo "change directory to pwd"
    if [[ "$INPUT_BASE_CONF_VAR" ]]; then
        cat $INPUT_BASE_CONF_VAR > config1.tfvars
        echo -e "${GREEN} variable Configuration Available."
    else
        echo -e "${RED}Error: Configuration variable are not available."
        exit 1

    if terraform init -backend-config="./env/base.config"; then
        echo -e "${GREEN} Infra setup Successful"
    else
        echo -e "${RED}Error: Please Add Remote Configiuration"

    if [[ "$INPUT_ACTION" == "apply" ]]; then
        if [[ -f "./config1.tfvars" ]];then
            if terraform apply -auto-aprove -var-file="./config1.tfvars"; then
                echo  "infrastucture Deployed successful ! "
            else
                echo -e "${RED}Error: Infrastructure Deployment failed "
            fi
        else 
            echo -e "${RED}Error: Configuration not found"
            exit 1
        fi

    elif [[ "$INPUT_ACTION" == "plan" ]]; then
        if terraform plan -var-file="./config1.tfvars"; then
            echo -e "${GREEN} Terraform plan completed successfully."
        else
            echo -e "${RED}Error: Terraform plan failed."
            exit 1
        fi
    # Check if the INPUT_ACTION is "validate"

    elif [[ "$INPUT_ACTION" == "validate" ]]; then
        if terraform validate; then
            echo -e "${GREEN} Infra validation succeeded."
        else
            echo -e "${RED}Error: Infra validation failed."
            exit 1
        fi

    # Check if the INPUT_ACTION is "destroy"
    elif [[ "$INPUT_ACTION" == "destroy" ]]; then
        # Check if the config1.tfvars file exists
        if [[ -f "./config1.tfvars" ]]; then
            # Run Terraform destroy with auto-approval and the specified var file
            if terraform destroy -auto-approve -var-file="./config1.tfvars"; then
                echo "Infrastructure destruction successful!"
            else
                echo -e "${RED}Error: Infrastructure destruction failed."
                exit 1
            fi
        else
            echo -e "${RED}Error: config1.tfvars file not found."
            exit 1
        fi
    else
        echo -e "${RED}Error: Invalid INPUT_ACTION. It should be one of: apply, plan, validate, destroy."
        exit 1
    fi

elif [["$INPUT_EXISTING_BASE_INFRA" == "yes"]]; then
    echo -e "${GREEN} you have existed base infra"
else
    echo -e "${RED}Error: Invalid input please provide choice (yes/no)"
fi

################################################################################################################
# terraform plan -var-file="$INPUT_BASE_CONF_VAR"
echo "terraform $INPUT_ACTION -var-file=./config1.tfvars"

if [["$INPUT_EXISTING_PLATFORM_INFRA" == "no"]]; then
    cd /workspace/Platform_Infra/
    echo "change directory to ${pwd}"
    if [[ "$INPUT_BASE_CONF_VAR" ]]; then
        cat $INPUT_BASE_CONF_VAR > config2.tfvars
        echo -e "${GREEN} variable Configuration Available."
    else
        echo -e "${RED}Error: Configuration variable are not available."
        exit 1

    if terraform init -backend-config="./env/platform.config"; then
        echo -e "${GREEN} Infra setup Successful"
    else
        echo -e "${RED}Error: Please Add Remote Configiuration"

    if [[ "$INPUT_ACTION" == "apply" ]]; then
        if [[ -f "./config1.tfvars" ]];then
            if terraform apply -auto-aprove -var-file="./config2.tfvars"; then
                echo  "infrastucture Deployed successful ! "
            else
                echo -e "${RED}Error: Infrastructure Deployment failed "
            fi
        else 
            echo -e "${RED}Error: Configuration not found"
            exit 1
        fi

    elif [[ "$INPUT_ACTION" == "plan" ]]; then
        if terraform plan -var-file="./config2.tfvars"; then
            echo -e "${GREEN} Terraform plan completed successfully."
        else
            echo -e "${RED}Error: Terraform plan failed."
            exit 1
        fi
    # Check if the INPUT_ACTION is "validate"

    elif [[ "$INPUT_ACTION" == "validate" ]]; then
        if terraform validate; then
            echo -e "${GREEN} Infra validation succeeded."
        else
            echo -e "${RED}Error: Infra validation failed."
            exit 1
        fi

    # Check if the INPUT_ACTION is "destroy"
    elif [[ "$INPUT_ACTION" == "destroy" ]]; then
        # Check if the config1.tfvars file exists
        if [[ -f "./config2.tfvars" ]]; then
            # Run Terraform destroy with auto-approval and the specified var file
            if terraform destroy -auto-approve -var-file="./config2.tfvars"; then
                echo "Infrastructure destruction successful!"
            else
                echo -e "${RED}Error: Infrastructure destruction failed."
                exit 1
            fi
        else
            echo -e "${RED}Error: configuration file not found."
            exit 1
        fi
    else
        echo -e "${RED}Error: Invalid INPUT_ACTION. It should be one of: apply, plan, validate, destroy."
        exit 1
    fi

elif [["$INPUT_EXISTING_BASE_INFRA" == "yes"]]; then
    echo -e "${GREEN} you have existed base infra"
else
    echo -e "${RED}Error: Invalid input please provide choice (yes/no)"
fi


echo "terraform $INPUT_ACTION -var-file=./config2.tfvars"


