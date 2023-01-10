#:/bin/bash

sudo su

name="jesbin"
s3_bucket="upgrad-jesbin"
timestamp=$(date '+%d%m%Y-%H%M%S')

# TASK 01 START

# Update Packages
apt update -y

# Check if apache2 is installe, if not install apache2
if [[ apache2 != $(dpkg --get-selections apache2 | awk '{print $1}') ]];
then
        apt install apache2 -y
fi

# Check if apache2 service is running, if not start apache2 service
status=$(systemctl ststus apache2 | grep active | awk '{print $3}' | tr -d '()')
if [[ ststus != ${status} ]];
then
        systemctl start apache2
fi

# Check if apache2 service is enabled, if not enable
enable=$(systemctl is-enabled apache2 | grep "enabled")
if [[ enabled != ${enabled} ]];
then
        systemctl enable apache2
fi

# Creating archive of access logs and error logs
cd /var/log/apache2
tar -cf /tmp/${name}-httpd-logs-${timestamp}.tar *.log

# Copy archived logs to S3 bucket
if [[ -f /tmp/${name}-httpd-logs-${timestamp}.tar ]];
then
        aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar
fi

#TASK 02 END
 
