# Changelog

All notable changes to this project will be documented in this file.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)

## [Unreleased]

## [0.3.0] - 2026-07-27

### Added
- `src/skills/ipd/SKILL.md` — runtime `ipd` skill. Detects a gitignored `./.ipd/AGENTS.md`, loads it as the authoritative workflow spec, and routes `/ipd <subcommand>` (`new`, `idea`, `plan`, `work`, `done`, `status`, `lint`, `fix`, `help`) to the existing `.ipd/scripts/*` tooling. When `.ipd/` is absent, prompts the user before running `init-ipd` — never auto-initializes.

### Changed
- `install.sh`, `install.ps1` — deploy the new `ipd` skill to `~/.copilot/skills/ipd/` alongside `init-ipd`.
- Root `AGENTS.md` — now lists both shipped skills in a new **Available Skills** table.

## [0.1.3] - 2026-06-17

### Added
- `src/templates/ROOT_AGENTS.md` — routing-layer template for root `AGENTS.md` (project overview + workflow directory)
- `src/templates/CLAUDE.md` — pointer template (`See AGENTS.md`) for co-agents pattern
- `CLAUDE.md` at repo root — ipd-framework now uses the pattern itself

### Changed
- `init-ipd.sh`: root `AGENTS.md` is now generated from `ROOT_AGENTS.md` (routing layer) instead of being a copy of `.ipd/AGENTS.md`; generation is idempotent (skipped if file exists)
- `init-ipd.sh`: now also generates `CLAUDE.md` in the target repo root (idempotent)
- `AGENTS.md` at repo root: refactored to routing layer (project conventions + workflow directory table); IPD workflow mechanics remain in `.ipd/AGENTS.md`



## [0.1.0] - 2026-05-04

### Added
- Initial release: `init-ipd` Copilot CLI skill
- `get-next-ipd-id.sh` — atomic ID counter with GUID lock
- `session-status.sh` — show active session slots
- Templates: idea, plan, decision
- `.ipd/AGENTS.md` template — standalone agent manifest
