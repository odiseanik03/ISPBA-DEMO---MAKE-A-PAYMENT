# AccountFlow Final Phase Plan

## Progress estimate

Current estimated completion: **~78%**.

Target after this final phase: **~95–100%**.

## One final phase (combined sprint)

Run one unified completion sprint that executes all remaining tracks together:

1. Integrated runtime proof
   - Run full stack and validate live health + smoke + persistence checks.
2. Backend/analytics reliability
   - Execute unit/integration tests and close edge-case failures.
3. Frontend production polish
   - Final responsive/accessibility pass and widget/form/navigation confidence.
4. Release closure
   - Enforce go/no-go checklist with CI as source of truth.

## Final-phase definition of done

To claim 95–100%, all of the following must be true:

- `python-tests` is green in CI.
- `python-postgres-integration` is green in CI.
- `java-tests` is green in CI.
- `flutter-tests` is green in CI.
- `shell-checks` is green in CI.
- `compose-smoke` is green in CI.
- `./scripts/e2e-compose-check.sh` passes in a runnable environment.
- API docs/contracts are synced with implementation.

## Remaining open risks until completion

- Environment/package network restrictions can block local dependency installs.
- Missing runtime tools (Docker/Flutter) can block local end-to-end proof.
- CI must be used as the final pass/fail authority where local environment is limited.
