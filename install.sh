#!/usr/bin/env bash
# install.sh — deploy the ipd-framework Copilot CLI skills to ~/.copilot/skills/
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# init-ipd skill — scaffolds .ipd/ into a repo (one-shot setup)
INIT_DEST="$HOME/.copilot/skills/init-ipd"
mkdir -p "$INIT_DEST"
cp "$SCRIPT_DIR/src/skills/init-ipd/SKILL.md" "$INIT_DEST/SKILL.md"
cp "$SCRIPT_DIR/src/skills/init-ipd/init-ipd.sh" "$INIT_DEST/init-ipd.sh"
chmod +x "$INIT_DEST/init-ipd.sh"

# ipd skill — runtime router; surfaces gitignored ./.ipd/ to agents
IPD_DEST="$HOME/.copilot/skills/ipd"
mkdir -p "$IPD_DEST"
cp "$SCRIPT_DIR/src/skills/ipd/SKILL.md" "$IPD_DEST/SKILL.md"

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
echo "✅ ipd-framework skills installed."
echo "   Skills:    $INIT_DEST"
echo "             $IPD_DEST"
echo "   Scripts:   $SCRIPTS_DEST"
echo "   Templates: $TEMPLATES_DEST"
echo ""
echo "Open a repo and run: init-ipd   (one-time setup)"
echo "Then operate with:   /ipd <new|plan|work|done|status|help>"
