#!/bin/bash

cd "${0%/*}"

# Set name/path of S3 bucket
echo ""
echo "Enter S3 bucket name or path (Ex. test-bucket or root-bucket/test-bucket):"
read bucket_name

# Set the name of the SQLite database
db_name="s3_objects.db"

# Create a new SQLite database
sqlite3 "$db_name" "CREATE TABLE s3_objects (last_modified TEXT, size INTEGER, object_name TEXT, object_path TEXT)"

# List all objects in the bucket and insert them into the database
aws s3 ls "s3://$bucket_name" --recursive | while read -r line; do
  size=$(echo "$line" | awk '{print $3}')
  last_modified=$(echo "$line" | awk '{print $1" "$2}')
  object_name=$(echo "$line" | awk '{print $NF}' | sed 's/"/""/g')
  object_path=$(echo "$line" | awk '{print $4}' | sed 's/"/""/g')
  sqlite3 "$db_name" "INSERT INTO s3_objects VALUES (\"$last_modified\", $size, \"$object_name\", \"$object_path\")"
done

# Export the SQLite database as a CSV file
sqlite3 -header -csv "$db_name" "SELECT last_modified, size, object_name, object_path FROM s3_objects" > s3_objects.csv
