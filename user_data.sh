#!/bin/bash
sudo apt update -y
sudo apt install openjdk-17-jdk -y
sudo apt install awscli -y
# Create the deployment script
cat <<'EOF' > /opt/deploy.sh
#!/bin/bash
S3_BUCKET=${1}
ARTIFACT_NAME=${2}

aws s3 cp s3://${S3_BUCKET}/${ARTIFACT_NAME} /home/ubuntu/application.jar

sudo systemctl restart spring-boot-app
EOF

chmod +x /opt/deploy.sh

# Create the systemd service file
cat <<'EOF' > /etc/systemd/system/spring-boot-app.service
[Unit]
Description=Spring Boot Demo Application
After=network.target

[Service]
User=ubuntu
ExecStart=/usr/bin/java -jar /home/ubuntu/application.jar
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

# Reload the systemd daemon and enable the service
sudo systemctl daemon-reload
sudo systemctl enable spring-boot-app
sudo systemctl start spring-boot-app
