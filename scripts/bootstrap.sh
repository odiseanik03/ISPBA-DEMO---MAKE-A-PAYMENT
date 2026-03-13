#!/usr/bin/env bash
set -euo pipefail
cp -n .env.example .env || true
cp -n backend-java/.env.example backend-java/.env || true
cp -n analytics-python/.env.example analytics-python/.env || true
echo "Bootstrap complete. Run: docker compose up --build"
