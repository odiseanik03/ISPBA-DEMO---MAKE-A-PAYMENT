#!/usr/bin/env bash
set -euo pipefail

STRICT_FINAL_PHASE=${STRICT_FINAL_PHASE:-false}

echo "[final-phase] starting combined sprint"
if [[ "$STRICT_FINAL_PHASE" == "true" ]]; then
  STRICT_VALIDATION=true ./scripts/phase-validate.sh
else
  STRICT_VALIDATION=false ./scripts/phase-validate.sh
fi

echo "[final-phase] combined sprint completed"
echo "[final-phase] verify CI checklist in docs/RUNBOOK.md section 6 for 95–100% closure"
