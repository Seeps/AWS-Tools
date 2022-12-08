#!/bin/bash

cd "${0%/*}"

# Verify that the EFS volume does not have any mount targets then list Name and FSID
aws efs describe-file-systems | jq -r '(["Name","File System ID"] | (., map(length*"-"))), (.FileSystems[] | select(.NumberOfMountTargets==0) | [.Name, .FileSystemId]) | @tsv'
aws efs describe-file-systems | jq -r '.FileSystems[] | select(.NumberOfMountTargets==0) | .FileSystemId' | while read EFS_ID

do
    # Delete the EFS volume if it does not have any mount targets
    aws efs delete-file-system --file-system-id $EFS_ID
    echo ""
    echo "Deleted EFS volume $EFS_ID"

done
