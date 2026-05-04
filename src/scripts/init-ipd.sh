#!/usr/bin/env bash
# init-ipd.sh — scaffold the IPD workflow (.ipd/ folder) into a target repository.
#
# Usage: init-ipd.sh [--dir <path>] [--project <name>] [--owner <name>]
#
# Creates (idempotently):
#   <dir>/.ipd/AGENTS.md
#   <dir>/.ipd/log.md
#   <dir>/.ipd/nextid
#   <dir>/.ipd/scripts/get-next-ipd-id.sh
#   <dir>/.ipd/scripts/session-status.sh
#   <dir>/.ipd/ideas/0000-template.md
#   <dir>/.ipd/plans/0000-template.md
#   <dir>/.ipd/decisions/0000-template.md
#   Appends ".ipd/" to <dir>/.gitignore
set -euo pipefail

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
TARGET_DIR="$PWD"
PROJECT="My Project"
OWNER="$(git config user.name 2>/dev/null || echo "Unknown")"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir)     TARGET_DIR="$2"; shift 2 ;;
    --project) PROJECT="$2";    shift 2 ;;
    --owner)   OWNER="$2";      shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

mkdir -p "$TARGET_DIR"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
IPD="$TARGET_DIR/.ipd"
TODAY="$(date +%Y-%m-%d)"
TEMPLATES_DIR="${BASH_SOURCE[0]%/*}"
# Resolve installed templates location (sibling of scripts/)
TEMPLATES_SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/../templates" 2>/dev/null && pwd || echo "")"
if [[ -z "$TEMPLATES_SRC" ]]; then
  TEMPLATES_SRC="$HOME/.ipd-framework/templates"
fi

echo "[init-ipd] Scaffolding .ipd/ in: $TARGET_DIR"
echo "[init-ipd] Project: $PROJECT | Owner: $OWNER"

# ---------------------------------------------------------------------------
# Create directory structure
# ---------------------------------------------------------------------------
mkdir -p "$IPD/ideas" "$IPD/plans" "$IPD/decisions" "$IPD/scripts" "$IPD/.sessions"

# ---------------------------------------------------------------------------
# nextid counter
# ---------------------------------------------------------------------------
if [[ ! -f "$IPD/nextid" ]]; then
  printf '0001\n' > "$IPD/nextid"
  echo "[init-ipd] Created .ipd/nextid"
else
  echo "[init-ipd] Skipped .ipd/nextid (already exists)"
fi

# ---------------------------------------------------------------------------
# log.md
# ---------------------------------------------------------------------------
if [[ ! -f "$IPD/log.md" ]]; then
  cat > "$IPD/log.md" << EOF
# IPD Log — $PROJECT

Index of all ideas, plans, and decisions.

| ID   | Kind | Status | Title | Files |
|------|------|--------|-------|-------|

<!-- Rows are added by the agent as work items are created/completed. -->
EOF
  echo "[init-ipd] Created .ipd/log.md"
else
  echo "[init-ipd] Skipped .ipd/log.md (already exists)"
fi

# ---------------------------------------------------------------------------
# AGENTS.md
# ---------------------------------------------------------------------------
if [[ ! -f "$IPD/AGENTS.md" ]]; then
  cp "$HOME/.ipd-framework/templates/AGENTS.md" "$IPD/AGENTS.md"
  # Substitute project/owner placeholders
  sed -i "s/{{PROJECT}}/$PROJECT/g; s/{{OWNER}}/$OWNER/g; s/{{DATE}}/$TODAY/g" "$IPD/AGENTS.md" 2>/dev/null \
    || perl -pi -e "s/\{\{PROJECT\}\}/$PROJECT/g; s/\{\{OWNER\}\}/$OWNER/g; s/\{\{DATE\}\}/$TODAY/g" "$IPD/AGENTS.md"
  echo "[init-ipd] Created .ipd/AGENTS.md"
else
  echo "[init-ipd] Skipped .ipd/AGENTS.md (already exists)"
fi

# ---------------------------------------------------------------------------
# Templates
# ---------------------------------------------------------------------------
for tpl in 0000-idea.md 0000-plan.md 0000-decision.md; do
  subdir="${tpl/0000-/}"; subdir="${subdir/.md/}s"
  dest="$IPD/$subdir/0000-template.md"
  if [[ ! -f "$dest" ]]; then
    cp "$HOME/.ipd-framework/templates/$tpl" "$dest"
    echo "[init-ipd] Created .ipd/$subdir/0000-template.md"
  else
    echo "[init-ipd] Skipped .ipd/$subdir/0000-template.md (already exists)"
  fi
done

# ---------------------------------------------------------------------------
# Scripts
# ---------------------------------------------------------------------------
for script in get-next-ipd-id.sh session-status.sh; do
  dest="$IPD/scripts/$script"
  if [[ ! -f "$dest" ]]; then
    cp "$HOME/.ipd-framework/scripts/$script" "$dest"
    chmod +x "$dest"
    echo "[init-ipd] Created .ipd/scripts/$script"
  else
    echo "[init-ipd] Skipped .ipd/scripts/$script (already exists)"
  fi
done

# ---------------------------------------------------------------------------
# .gitignore
# ---------------------------------------------------------------------------
GITIGNORE="$TARGET_DIR/.gitignore"
if [[ ! -f "$GITIGNORE" ]] || ! grep -qF '.ipd/' "$GITIGNORE"; then
  printf '\n# IPD workflow — local-only, like .vscode/ or .idea/\n.ipd/\n' >> "$GITIGNORE"
  echo "[init-ipd] Added .ipd/ to .gitignore"
else
  echo "[init-ipd] Skipped .gitignore (.ipd/ already present)"
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo ""
echo "[init-ipd] Done. IPD workflow scaffolded at: $TARGET_DIR/.ipd/"
echo ""
echo "  Agent manifest:  $TARGET_DIR/.ipd/AGENTS.md"
echo "  Work log:        $TARGET_DIR/.ipd/log.md"
echo "  Claim next ID:   bash $TARGET_DIR/.ipd/scripts/get-next-ipd-id.sh"
echo ""
echo "  Open an LLM session and read .ipd/AGENTS.md to get started."
