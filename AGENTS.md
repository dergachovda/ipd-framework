# AGENTS.md — ipd-framework

## Project Overview

`ipd-framework` scaffolds the IPD (Ideas → Plans → Decisions) workflow into any repository and ships the `/ipd` runtime skill that operates it.

## Available Skills

| Skill | Description | Source |
|-------|-------------|--------|
| `init-ipd` | Scaffold the `.ipd/` folder, scripts, and templates into a target repo. | [src/skills/init-ipd/SKILL.md](src/skills/init-ipd/SKILL.md) |
| `ipd` | Runtime router: detects a gitignored `./.ipd/`, loads its `AGENTS.md`, and dispatches `/ipd <subcommand>`. | [src/skills/ipd/SKILL.md](src/skills/ipd/SKILL.md) |

## Available Workflows

| Workflow | Description | Instructions |
|----------|-------------|--------------|
| IPD | Ideas → Plans → Decisions tracking | [.ipd/AGENTS.md](.ipd/AGENTS.md) |

## Tech Stack & Conventions

- Skills: `bash`, portable POSIX — no external deps
- `VERSION` — plain text semantic version; bump on release
- `CHANGELOG.md` — follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
- **Never commit without explicit owner approval.** Stage with `git add`, summarize, stop and wait.
- **Commit format:** `[NNNN]: short description` — 1–7 words, lowercase, no full stop
- When modifying `src/scripts/`, verify `src/templates/AGENTS.md` stays consistent

