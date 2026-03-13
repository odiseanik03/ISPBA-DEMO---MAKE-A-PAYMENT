# AccountFlow

AccountFlow is a portfolio-grade banking-style demo platform with:
- Flutter Web frontend
- Java Spring Boot core API
- Python FastAPI analytics service
- PostgreSQL
- Docker Compose orchestration

## Current status
This repository now includes **Phase 1 scaffolding** for all modules and baseline configuration.

## Quick start
1. Copy env templates:
   - `cp .env.example .env`
   - `cp backend-java/.env.example backend-java/.env`
   - `cp analytics-python/.env.example analytics-python/.env`
2. Start infrastructure and services:
   - `docker compose up --build`

## Entry UX rule
No full login form is implemented by design. The frontend uses a minimal entry action (`Enter Portal`) for demo-authenticated flow.
