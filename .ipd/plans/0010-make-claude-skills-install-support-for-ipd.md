# PLAN-0010: Make Claude skills install support for IPD

**Date:** 2026-09-15
**Status:** In Progress
**Linked IPD:** IPD-0010

## Goal

Extend `install.sh` so the IPD framework installs its skills for Claude-based agents while preserving the existing Copilot CLI installation. Keep shared scripts and templates in a consistent location, document the supported installation behavior, and verify both installation paths.

## Steps

- [x] Determine the supported Claude skills directory and expected skill file layout, including whether the existing `SKILL.md` files can be reused unchanged.
- [x] Update `install.sh` to install `init-ipd` and `ipd` into the Claude skills location while retaining the current Copilot destinations and shared asset installation.
- [x] Adjust installer output and any related documentation so users know how to install and invoke IPD from Copilot CLI and Claude.
- [x] Add or update focused checks for installer idempotency, destination paths, executable permissions, and required skill/template files.
- [x] Review the resulting changes for cross-platform shell compatibility and record the implementation decision.

## Notes

Claude Code's user-level skill directory is `~/.claude/skills/`; each installed
skill uses the existing directory-plus-`SKILL.md` layout. The installer keeps
Copilot and Claude destinations separate, preserves unrelated skills, and
shares scripts and templates through `~/.ipd-framework/`.

## Commit message

`[0010]: add claude skill installation` — 1–7 words, lowercase, no full stop.
