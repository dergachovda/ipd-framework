#!/usr/bin/env bash
# init-ipd skill entry-point — thin wrapper around ~/.ipd-framework/scripts/init-ipd.sh
set -euo pipefail
exec bash "$HOME/.ipd-framework/scripts/init-ipd.sh" "$@"
