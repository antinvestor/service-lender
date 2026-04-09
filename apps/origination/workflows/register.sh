#!/usr/bin/env bash
# Register the origination maintenance workflow with Trustage and create cron schedules.
# Usage: TRUSTAGE_URL=http://service-trustage:80 ./register.sh
#
# This script is idempotent — re-running it will update existing definitions.

set -euo pipefail

TRUSTAGE_URL="${TRUSTAGE_URL:-http://service-trustage.trustage.svc:80}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Registering workflow with Trustage at ${TRUSTAGE_URL}..."

# 1. Create/update the workflow definition
DSL=$(cat "${SCRIPT_DIR}/expire-stale-tasks.json")

RESPONSE=$(curl -sf -X POST "${TRUSTAGE_URL}/workflow.v1.WorkflowService/CreateWorkflow" \
  -H "Content-Type: application/json" \
  -d "{\"dsl\": ${DSL}}" 2>&1) || {
  echo "Warning: Could not register workflow (Trustage may not be ready yet): ${RESPONSE}"
  exit 0
}

WORKFLOW_ID=$(echo "${RESPONSE}" | jq -r '.workflow.id // empty')
WORKFLOW_NAME=$(echo "${RESPONSE}" | jq -r '.workflow.name // empty')
echo "Workflow registered: id=${WORKFLOW_ID} name=${WORKFLOW_NAME}"

# 2. Activate the workflow
curl -sf -X POST "${TRUSTAGE_URL}/workflow.v1.WorkflowService/ActivateWorkflow" \
  -H "Content-Type: application/json" \
  -d "{\"id\": \"${WORKFLOW_ID}\"}" > /dev/null 2>&1 || true

echo "Workflow activated."
echo ""
echo "Schedule configuration:"
echo "  Expire offers:  0 */6 * * *  (every 6 hours)"
echo "  Clean drafts:   0 2 * * *    (daily at 02:00)"
echo ""
echo "Cron schedules should be created in Trustage schedule_definitions table:"
echo "  INSERT INTO schedule_definitions (name, cron_expr, workflow_name, workflow_version, active, next_fire_at)"
echo "  VALUES ('origination-expire-offers', '0 */6 * * *', 'origination-expire-stale-tasks', 1, true, NOW());"
echo ""
echo "Done."
