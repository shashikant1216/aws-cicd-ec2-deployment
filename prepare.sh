#!/usr/bin/env bash
set -euo pipefail
id devopsdemo >/dev/null 2>&1 || useradd --system --home /opt/devops-demo --shell /usr/sbin/nologin devopsdemo
mkdir -p /opt/devops-demo/app
