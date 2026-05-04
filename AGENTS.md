# AGENTS.md — ipd-framework

AI agent instructions for working in the `ipd-framework` repository itself.

## Purpose

This repo scaffolds the IPD workflow into other repos. Work on it follows the same IPD pattern.

## Structure

```
src/skills/init-ipd/     ← Copilot CLI skill definition (SKILL.md + thin wrapper)
src/scripts/             ← init-ipd.sh, get-next-ipd-id.sh, session-status.sh
src/templates/           ← template files copied into target repos
install.sh / install.ps1 ← deploy skill to ~/.copilot/skills/
```

## Agent Rules

- **Never commit without explicit owner approval.** Stage with `git add`, summarize changes, stop and wait.
- **Commit format:** `[NNNN]: short description` — 1–7 words, lowercase, no full stop.
- When modifying `src/scripts/` scripts, verify the corresponding `src/templates/AGENTS.md` is still consistent.
- `VERSION` is a plain text file with one semantic version number. Bump it on release.
- `CHANGELOG.md` follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
