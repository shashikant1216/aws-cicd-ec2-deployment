#!/usr/bin/env bash
set -euo pipefail
for i in $(seq 1 20); do
  if curl --fail --silent http://127.0.0.1:3000/health; then exit 0; fi
  sleep 3
done
exit 1
