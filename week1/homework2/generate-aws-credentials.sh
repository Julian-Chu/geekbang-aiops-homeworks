#!/bin/bash

aws_access_key_id="${AWS_ACCESS_KEY_ID}"
aws_secret_access_key="${AWS_SECRET_ACCESS_KEY}"
aws_session_token="${AWS_SESSION_TOKEN}"

# print all environment variables
echo "AWS_ACCESS_KEY_ID: $aws_access_key_id"
echo "AWS_SECRET_ACCESS_KEY: $aws_secret_access_key"
echo "AWS_SESSION_TOKEN: $aws_session_token"


if [[ -z "$aws_access_key_id" || -z "$aws_secret_access_key" || -z "$aws_session_token" ]]; then
  echo "Error: Please set the following environment variables:"
  echo "AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN"
  exit 1
fi

cat > terraform/aws-credentials.txt <<EOF
[default]
aws_access_key_id        = $aws_access_key_id
aws_secret_access_key    = $aws_secret_access_key
aws_session_token        = $aws_session_token
EOF

echo "AWS credentials file created: terraform/aws-credentials.txt"