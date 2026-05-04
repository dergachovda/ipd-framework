#!/usr/bin/env bash
# session-status.sh — show all active session claims in .ipd/.sessions/
#
# Usage: bash .ipd/scripts/session-status.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SESSIONS_DIR="$REPO_ROOT/.ipd/.sessions"
SESSION_ID_FILE="${HOME}/.copilot/ipd-session-id"

MY_SESSION=""
[[ -f "$SESSION_ID_FILE" ]] && MY_SESSION=$(tr -d '[:space:]' < "$SESSION_ID_FILE")

if [[ ! -d "$SESSIONS_DIR" ]] || [[ -z "$(ls -A "$SESSIONS_DIR" 2>/dev/null)" ]]; then
  echo "No active sessions."; exit 0
fi

printf '\n%-6s  %-8s  %-12s  %-20s  %s\n' "ID" "STATUS" "SESSION" "STARTED" "DESC"
printf '%s\n' "------  --------  ------------  --------------------  ----"

for f in "$SESSIONS_DIR"/*; do
  [[ -f "$f" ]] || continue
  plan=$(grep '^plan'    "$f" 2>/dev/null | awk '{print $2}')
  status=$(grep '^status' "$f" 2>/dev/null | awk '{print $2}')
  session=$(grep '^session' "$f" 2>/dev/null | awk '{print $2}')
  started=$(grep '^started' "$f" 2>/dev/null | awk '{print $2}')
  desc=$(grep '^desc'    "$f" 2>/dev/null | sed 's/^desc[[:space:]]*//')
  short="${session:0:8}"
  [[ -n "$MY_SESSION" && "$session" == "$MY_SESSION" ]] && short="$short (you)"
  printf '%-6s  %-8s  %-12s  %-20s  %s\n' \
    "${plan:-?}" "${status:-?}" "$short" "${started:-?}" "${desc:-?}"
done
printf '\n'
