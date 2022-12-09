# AWS-Tools
Random automation tools/scripts for AWS resources

## efs-cleanup.sh
This script utilizes the AWS-CLI to query for EFS stores that have no mount targets (meaning the EFS resource is not connected with anything and therefore not in use). It then lists the name and file system ID of the EFS store, and proceeds to iteratively delete each one.

**NOTE**: This script requires [AWS-CLI](https://aws.amazon.com/cli/) and [jq](https://stedolan.github.io/jq/download/) to be installed on your system.
