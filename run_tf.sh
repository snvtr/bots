#!/bin/bash

USER_NAME=$(mktemp -u | cut -c 10-14 | tr '[:upper:]' '[:lower:]')
echo "USER_NAME=$USER_NAME" > files/user.env

terraform init
terraform apply .

echo "Local user: $USER_NAME'