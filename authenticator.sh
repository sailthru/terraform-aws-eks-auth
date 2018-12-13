#!/bin/bash
set -e

# Debug log all STDERR and script's own output to authenticator.log
# exec 2> authenticator.log
# set -x

# Extract cluster name from STDIN
eval "$(jq -r '@sh "CLUSTER_NAME=\(.cluster_name) ROLE=\(.role) PROFILE=\(.profile)"')"

# Retrieve token with AWS IAM Authenticator
TOKEN=$(AWS_PROFILE=$PROFILE aws-iam-authenticator token -i $CLUSTER_NAME -r $ROLE | jq -r .status.token)

# Output token as JSON
jq -n --arg token "$TOKEN" '{"token": $token}'
