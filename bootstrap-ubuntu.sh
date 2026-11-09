#!/usr/bin/env bash
set -euo pipefail
: "${AWS_REGION:?Set AWS_REGION to the EC2 deployment region}"
apt-get update
apt-get install -y curl ruby-full wget ca-certificates
# Installs distro-packaged Node.js; verify it is >=22 before deployment.
apt-get install -y nodejs npm
node --version
cd /tmp
wget -O codedeploy-install "https://aws-codedeploy-${AWS_REGION}.s3.${AWS_REGION}.amazonaws.com/latest/install"
chmod +x codedeploy-install
./codedeploy-install auto
systemctl enable --now codedeploy-agent
