#!/bin/bash

# Set the backup directory

backup_dir="/home/test/postgresdbbackup/db_test"

# Set the S3 bucket name and destination path
s3_bucket="s3-bucket-name"
s3_destination="s3://path/db_test/"

# Set the current date and time for the backup file
backup_file="${backup_dir}/db_test_backup_$(date +%Y:%m:%d_%H:%M:%S).sql"

# PostgreSQL login credentials
db_user="postgres"
db_password="password"
db_host="170.40.1.30"
db_port="5432"
db_name="db_test"

# Execute the psql command to create the backup file
PGPASSWORD="$db_password" pg_dump -U "$db_user" -h "$db_host" -p "$db_port" -F p -b -v -f $backup_file $db_name
#pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -W -F p -b -v -f $BACKUP_FILE $DB_NAME

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Backup created successfully for Battery-line-scada: $backup_file" > /home/olaadmin/postgresdbbackup/report/cron_report_db_test.txt

  # Upload the backup file to S3
  aws s3 cp "$backup_file" "$s3_destination"

  # Check if the upload was successful
  if [ $? -eq 0 ]; then
    echo "db_test DB Backup uploaded to S3 successfully" >> /home/test/postgresdbbackup/report/cron_report_db_test.txt
  else
    echo "db_test DB Backup upload to S3 failed!" >> /home/test/postgresdbbackup/report/cron_report_db_test.txt
  fi
else
  echo "db_test DB Backup failed!" >> /home/test/postgresdbbackup/report/cron_report_db_test.txt
fi

# Removing the file from Local once uploaded to S3.
rm $backup_file
echo "Local file Deleted" >> /home/test/postgresdbbackup/report/cron_report_db_test.txt
# Replace this with your actual Slack webhook URL
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/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"
TEXT_FILE="/home/test/postgresdbbackup/report/cron_report_db_test.txt"                   # Change this to the path of your text file

# Read the content of the text file
MESSAGE=$(cat "$TEXT_FILE")

# Send the message to Slack
curl -X POST -H 'Content-type: application/json' --data "{
  \"text\": \"$MESSAGE\"
}" "$SLACK_WEBHOOK_URL"
