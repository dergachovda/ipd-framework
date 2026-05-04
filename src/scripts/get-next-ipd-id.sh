#!/usr/bin/env bash
# get-next-ipd-id.sh — atomically claim the next IPD ID and register a session.
#
# Prints the next NNNN number (zero-padded to 4 digits) and advances
# .ipd/nextid. Uses a GUID lock file so concurrent agents each get
# a unique number without colliding.
#
# Usage:
#   ID=$(bash .ipd/scripts/get-next-ipd-id.sh [description])
#   # create .ipd/ideas/${ID}-my-slug.md, .ipd/plans/${ID}-my-slug.md, etc.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
IPD_DIR="$REPO_ROOT/.ipd"
NEXT_ID_FILE="$IPD_DIR/nextid"
LOCK_FILE="$IPD_DIR/nextid.lock"
SESSIONS_DIR="$IPD_DIR/.sessions"
SESSION_ID_FILE="${HOME}/.copilot/ipd-session-id"
DESCRIPTION="${1:-pending}"

if [[ ! -f "$NEXT_ID_FILE" ]]; then
  echo "ERROR: $NEXT_ID_FILE not found. Run init-ipd first." >&2
  exit 1
fi

# Resolve or create a persistent session GUID for this shell window
_make_guid() {
  if command -v uuidgen &>/dev/null; then uuidgen
  elif [[ -r /proc/sys/kernel/random/uuid ]]; then cat /proc/sys/kernel/random/uuid
  elif command -v python3 &>/dev/null; then python3 -c "import uuid; print(uuid.uuid4())"
  elif command -v python &>/dev/null; then python -c "import uuid; print(uuid.uuid4())"
  else printf '%s\n' "${$}-$(date +%s)-${RANDOM}"; fi
}

mkdir -p "$(dirname "$SESSION_ID_FILE")"
[[ -f "$SESSION_ID_FILE" ]] || _make_guid > "$SESSION_ID_FILE"
SESSION_GUID=$(tr -d '[:space:]' < "$SESSION_ID_FILE")
MY_GUID="$SESSION_GUID"

cleanup() { rm -f "$LOCK_FILE"; }
trap cleanup EXIT

# Acquire lock
while true; do
  if (set -o noclobber; printf '%s\n' "$MY_GUID" > "$LOCK_FILE") 2>/dev/null; then break; fi
  echo "Lock held by another agent, waiting 10s..." >&2
  sleep 10
done

next_id=$(tr -d '[:space:]' < "$NEXT_ID_FILE")
printf '%04d\n' $((10#$next_id + 1)) > "$NEXT_ID_FILE"

mkdir -p "$SESSIONS_DIR"
printf 'session %s\nplan    %s\nstatus  booked\ndesc    %s\nstarted %s\n' \
  "$SESSION_GUID" "$next_id" "$DESCRIPTION" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  > "$SESSIONS_DIR/$next_id"

printf '%s\n' "$next_id"
