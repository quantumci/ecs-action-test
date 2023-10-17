#!/bin/bash

# Define Color escape codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo $INPUT_REPO;

# Update the values in the config file
config1_file="/workspace/Base_Infra/env/base.config"
config2_file="/workspace/Platform_Infra/env/platform.config"

if [[ ! "$config1_file" || ! "$config2_file" ]]; then

    echo -e "${RED}Error: Remote backend configurations not found."
    exit 1
else
    sed -i "s/bucket=\"[^\"]+\"/bucket=\"$INPUT_REMOTE_BUCKET_NAME\"/g" "$config1_file"
    sed -i "s/region=\"[^\"]+\"/region=\"$INPUT_REMOTE_BUCKET_REGION\"/g" "$config1_file"
    sed -i "s/bucket=\"[^\"]+\"/bucket=\"$INPUT_REMOTE_BUCKET_NAME\"/g" "$config2_file"
    sed -i "s/region=\"[^\"]+\"/region=\"$INPUT_REMOTE_BUCKET_REGION\"/g" "$config2_file"

    echo -e "${GREEN} Remote backend configuration found"
fi




# Check if AWS credentials are set

# if [[ -z "$INPUT_AWS_ACCESS_KEY" || -z "$INPUT_AWS_SECRET_ACCESS_KEY" ]]; then

#     echo -e "${RED}Error: AWS credentials not provided."

#     exit 1
# else
#     # Set AWS Creds 
#     export AWS_ACCESS_KEY_ID=$INPUT_AWS_ACCESS_KEY;
#     export AWS_SECRET_ACCESS_KEY=$INPUT_AWS_SECRET_ACCESS_KEY;
    
#     echo -e "${GREEN} AWS secret configured successfully"

# fi

# Check inputs is yes or no for INPUT_BASE_CONF_VAR and INPUT_PLATFORM_CONF_VAR
if [[ "$INPUT_EXISTING_BASE_INFRA" != "yes" && "$INPUT_EXISTING_BASE_INFRA" != "no" ]]; then
    echo -e "${RED} Error: input for existing_base_infra must be either yes or no "
    exit 1
fi

if [[ "$INPUT_EXISTING_PLATFORM_INFRA" != "yes" && "$INPUT_EXISTING_PLATFORM_INFRA" != "no" ]]; then
    echo -e "${RED} Error: input for existing_platform_infra must be either yes or no "
    exit 1
fi




# Validate the INPUT_ACTION variable (should be one of: plan, apply, destroy, etc.)

if [[ ! "$INPUT_ACTION" =~ ^(test|apply|destroy|refresh|validate)$ ]]; then

    echo -e "${RED}Error: Invalid INPUT_ACTION. It should be one of: test, apply, destroy, refresh, validate."

    exit 1

fi

# Function to download files

download() {

    ERROR_MESSAGE="404: Not found"

    if [ -n "$1" ]; then

        variable="$1"
        SAVE_PATH="$2"
        SAVE_FILE_NAME="config1.tfvars"
        IFS='/' read -ra parts <<< "$variable"
        owner="${parts[0]}"
        repo="${parts[1]}"
        branch="${parts[2]}"
        path=$(IFS=/ ; echo "${parts[*]:3}")
        echo "Owner: $owner"
        echo "Repository: $repo"
        echo "Path: $path"


    else 
        echo -r "${RED} error file path not found"
        exit 1
    fi

    if [ -n "$INPUT_TOKEN" ]; then
        curl -H "Authorization: token $INPUT_TOKEN" \
             -H 'Accept: application/vnd.github.v3.raw' \
             -o "$SAVE_PATH/$SAVE_FILE_NAME" \
             -L https://raw.githubusercontent.com/$owner/$repo/$branch/$path
    
    else

        curl -H 'Accept: application/vnd.github.v3.raw' \
             -o "$SAVE_PATH/$SAVE_FILE_NAME" \
             -L https://raw.githubusercontent.com/$owner/$repo/$branch/$path

    fi

    if grep -q "$ERROR_MESSAGE" "$SAVE_PATH/$SAVE_FILE_NAME"; then
        echo "404: Not found error. Please check the file path."
        exit 1

    fi
}


# Funcrion For Run Terraform\

spinup() {

    if [[ "$1" ]]; then
        cat $1 > config1.tfvars
        echo -e "${GREEN} variable Configuration Available."
    else
        echo -e "${RED}Error: Configuration variable are not available."
        exit 1
    fi

    if terraform init -backend-config="./env/base.config"; then
        echo -e "${GREEN} Infra setup Successful"
    else
        echo -e "${RED}Error: Please Add Remote Configiuration"

    fi

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

    elif [[ "$INPUT_ACTION" == "test" ]]; then
        if terraform plan -var-file="./config1.tfvars"; then
            echo -e "${GREEN} Infrastructure test completed successfully."
        else
            echo -e "${RED}Error: Infrastructure test failed. please check configuration variables"
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
        echo -e "${RED}Error: Invalid INPUT_ACTION. It should be one of: apply, test, validate, destroy."
        exit 1
    fi
}

#########################################################################################################

if [[ "$INPUT_EXISTING_BASE_INFRA" == no ]]; then
    cd /workspace/Base_Infra/
    download "$INPUT_BASE_CONF_VAR" "/workspace/Base_Infra"
    cat $SAVE_FILE_NAME;
    # spinup "$INPUT_BASE_CONF_VAR"
    
elif  [[ "$INPUT_EXISTING_BASE_INFRA" == yes ]]; then
    echo -e "${GREEN}  you have existed base infra "

else
    echo -e "${RED}Error: Invalid input please provide choice (yes/no)"
    exit 1
fi

################################################################################################################


if [["$INPUT_EXISTING_PLATFORM_INFRA" == no ]]; then
    cd /workspace/Platform_Infra/
    download "$INPUT_PLATFORM_CONF_VAR" "/workspace/Platform_Infra"
    spinup "$INPUT_PLATFORM_CONF_VAR"

elif  [[ "$INPUT_EXISTING_PLATFORM_INFRA" == yes ]]; then
    echo -e "${GREEN}  you have existed platform infra "

else
    echo -e "${RED}Error: Invalid input please provide choice (yes/no)"

fi
