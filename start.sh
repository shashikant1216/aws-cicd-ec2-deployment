#!/usr/bin/env bash
set -euo pipefail
systemctl enable devops-demo.service
systemctl restart devops-demo.service
