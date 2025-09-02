#!/bin/bash
# Update packages
sudo apt update -y
sudo apt install -y openjdk-17-jdk awscli snapd

# Install & enable SSM Agent (for Ubuntu)
sudo snap install amazon-ssm-agent --classic
sudo systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service

# Create the deployment script
cat <<'EOF' | sudo tee /opt/deploy.sh
#!/bin/bash
S3_BUCKET=$1
ARTIFACT_NAME=$2

echo "Deploying artifact from s3://$S3_BUCKET/$ARTIFACT_NAME" >> /tmp/deploy.log

# Copy artifact from S3
aws s3 cp s3://$S3_BUCKET/$ARTIFACT_NAME /home/ubuntu/application.jar

# Restart Spring Boot service
sudo systemctl restart spring-boot-app
EOF

sudo chmod +x /opt/deploy.sh

# Create systemd service file
cat <<'EOF' | sudo tee /etc/systemd/system/spring-boot-app.service
[Unit]
Description=Spring Boot Demo Application
After=network.target

[Service]
User=ubuntu
ExecStart=/usr/bin/java -jar /home/ubuntu/application.jar
Restart=always
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

# Enable & start the service
sudo systemctl daemon-reload
sudo systemctl enable spring-boot-app
sudo systemctl start spring-boot-app