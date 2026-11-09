#!/usr/bin/env bash
set -euo pipefail
test -x /usr/bin/node
chown -R devopsdemo:devopsdemo /opt/devops-demo
systemctl daemon-reload
