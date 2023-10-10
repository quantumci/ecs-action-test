# Use Alpine Linux as the base image
FROM alpine:latest
# Install required packages

RUN apk update &&\
    apk add --no-cache \
    bash \
    curl \
    unzip \
    sed

LABEL maintainer="mail@gmal.com"


# Download and install Terraform

RUN curl -o terraform.zip https://releases.hashicorp.com/terraform/0.15.0/terraform_0.15.0_linux_amd64.zip && \
unzip terraform.zip && \
    mv terraform /usr/local/bin/terraform && \
rm terraform.zip

# Set the working directory

WORKDIR /workspace 


# Copy your Terraform configuration files into the container
COPY . /workspace

# Entrypoint command to run Terraform apply

RUN pwd

RUN ls

RUN chmod +x /workspace/entrypoint.sh


CMD ["/workspace/entrypoint.sh"]