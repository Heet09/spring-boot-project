#!/bin/bash
sudo yum update -y
sudo yum install -y java-17-amazon-corretto-devel

# Create the deployment script
cat <<'EOF' > /opt/deploy.sh
#!/bin/bash
S3_BUCKET=${1}
ARTIFACT_NAME=${2}

aws s3 cp s3://${S3_BUCKET}/${ARTIFACT_NAME} /home/ec2-user/app.jar

sudo systemctl restart spring-boot-app
EOF

chmod +x /opt/deploy.sh

# Create the systemd service file
cat <<'EOF' > /etc/systemd/system/spring-boot-app.service
[Unit]
Description=Spring Boot Demo Application
After=network.target

[Service]
User=ec2-user
ExecStart=/usr/bin/java -jar /home/ec2-user/app.jar
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

# Reload the systemd daemon and enable the service
sudo systemctl daemon-reload
sudo systemctl enable spring-boot-app
