# IDEA-0010: Make Claude skills install support for IPD

**Date:** 2026-09-15
**Status:** Planned → PLAN-0010

## Summary

Extend the IPD framework installer so the IPD skills and supporting assets can be installed for Claude-based agents as well as the current Copilot CLI layout.

## Motivation

The repository already provides a `CLAUDE.md` pointer when scaffolding a target repository, but `install.sh` only installs skills under `~/.copilot/skills/`. Claude users therefore cannot discover or invoke the IPD workflow through their native skills installation path without manual setup.

## Open Questions

- Which Claude skills directory and file layout should be treated as the supported installation target?
- Should installation support both Copilot and Claude by default, or expose explicit flags for each agent?
- Which shared scripts and templates need compatibility adjustments for Claude's skill runtime?
