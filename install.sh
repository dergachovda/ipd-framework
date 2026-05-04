#!/usr/bin/env bash
# install.sh — deploy the init-ipd Copilot CLI skill to ~/.copilot/skills/
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.copilot/skills/init-ipd"

mkdir -p "$DEST"
cp "$SCRIPT_DIR/src/skills/init-ipd/SKILL.md" "$DEST/SKILL.md"
cp "$SCRIPT_DIR/src/skills/init-ipd/init-ipd.sh" "$DEST/init-ipd.sh"
chmod +x "$DEST/init-ipd.sh"

# Also install the scripts to ~/.ipd-framework/scripts/ so the skill wrapper can find them
SCRIPTS_DEST="$HOME/.ipd-framework/scripts"
mkdir -p "$SCRIPTS_DEST"
cp "$SCRIPT_DIR/src/scripts/init-ipd.sh" "$SCRIPTS_DEST/init-ipd.sh"
cp "$SCRIPT_DIR/src/scripts/get-next-ipd-id.sh" "$SCRIPTS_DEST/get-next-ipd-id.sh"
cp "$SCRIPT_DIR/src/scripts/session-status.sh" "$SCRIPTS_DEST/session-status.sh"
chmod +x "$SCRIPTS_DEST/"*.sh

# Copy templates
TEMPLATES_DEST="$HOME/.ipd-framework/templates"
mkdir -p "$TEMPLATES_DEST"
cp "$SCRIPT_DIR/src/templates/"* "$TEMPLATES_DEST/"

echo ""
echo "✅ init-ipd skill installed."
echo "   Skill:     $DEST"
echo "   Scripts:   $SCRIPTS_DEST"
echo "   Templates: $TEMPLATES_DEST"
echo ""
echo "Open a repo and run: init-ipd"
