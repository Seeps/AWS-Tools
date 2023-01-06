#!/bin/bash

cd "${0%/*}"

# List EC2 instances by launch time and tag name
aws ec2 describe-instances | jq -r '(["Launch Time","Instance Name"] | (., map(length*"-"))), (.Reservations[].Instances[] | .LaunchTime as $LaunchTime | (.Tags[] | select(.Key=="Name") | [$LaunchTime, .Value])) | @csv'
