# Limits — Production Rollout Runbook

This runbook walks through enabling limits enforcement for a new action key.
Use it once per (service, action) pair.

## Stages

```
off → shadow → enforce
```

Never skip shadow. Shadow mode is the only way to detect false positives
(policies that would block legitimate operations) without customer impact.

## Stage 1 — off (initial deployment)

1. Deploy the consumer service with the limits Gate code in place but
   `LIMITS_GATE_MODE_<action>=off`. The Gate is a no-op: it does not call
   Reserve at all. Handler runs unchanged.
2. Verify deployment health: error rates, latency, business KPIs steady.

## Stage 2 — shadow (24-72 hours, depending on volume)

1. Set `LIMITS_GATE_MODE_<action>=shadow` and redeploy (or rolling-restart
   pods). The Gate now calls Reserve but does not enforce.
2. Watch for shadow-outcome logs. Specifically:
   - Aggregate count of `shadow_outcome=would_block` per action_key per hour.
   - Top subject_ids triggering would_block.
   - Top policy_ids cited in verdicts.
3. **Threshold for "ready to enforce":**
   - would_block rate is <0.1% of total operations, OR
   - the operations triggering would_block are explicable (matched the
     policy intent) and reviewed with stakeholders.
4. **If the rate is too high:** loosen the policy, or carve out exceptions
   via `policies disable <id>` for the offending policy. Repeat the
   24-72h soak before flipping to enforce.

## Stage 3 — enforce

1. Set `LIMITS_GATE_MODE_<action>=enforce` and redeploy.
2. Watch for:
   - HTTP 412 (FailedPrecondition) and 429 (ResourceExhausted) on the
     consumer service's Connect endpoints.
   - Approval queue depth (`limits-admin reservations list --status=APPROVAL_STATUS_PENDING`).
   - Customer support tickets about blocked operations.
3. Have an on-call operator with `limits-admin approvals approve` ready
   for legitimate-but-blocked cases. Document the override workflow in
   the consumer service's customer-facing runbook.

## Rollback

If enforce mode causes incidents:

1. **Fastest:** flip `LIMITS_GATE_MODE_<action>` back to `shadow` and
   redeploy. Operations stop being blocked but observability stays on.
2. **Slower:** disable the offending policy via
   `limits-admin policies disable <id>`. Gate still fires Reserve but the
   verdict comes back ALLOW for everything.
3. **Coldest:** flip to `off`. Useful only if Reserve itself is unhealthy.

## Per-action keys

| Service     | Env var                                      | Subject       |
|-------------|----------------------------------------------|---------------|
| loans       | LIMITS_GATE_MODE_LOAN_DISBURSEMENT          | borrower      |
| loans       | LIMITS_GATE_MODE_LOAN_REQUEST_APPROVAL      | borrower      |
| loans       | LIMITS_GATE_MODE_LOAN_REPAYMENT             | borrower      |
| savings     | LIMITS_GATE_MODE_SAVINGS_DEPOSIT            | account       |
| savings     | LIMITS_GATE_MODE_SAVINGS_WITHDRAWAL         | account       |
| operations  | LIMITS_GATE_MODE_OPERATIONS_TRANSFER        | source acct   |
| funding     | LIMITS_GATE_MODE_FUNDING_DEPOSIT            | invest acct   |
| funding     | LIMITS_GATE_MODE_FUNDING_WITHDRAW           | invest acct   |
| stawi       | LIMITS_GATE_MODE_STAWI_LOAN_DISBURSEMENT    | member        |

## Escalation

- Slack: #fintech-limits
- On-call: limits-oncall (PagerDuty)
- Emergency disable: see "Rollback" above; any of the three modes
  resolves an incident in under 5 minutes.
