---
name: ipd
description: Detect a gitignored ./.ipd/ folder in the current repo, load its AGENTS.md, and route /ipd <subcommand> to the existing .ipd/scripts/* tooling. Use whenever the user invokes /ipd or mentions IPD workflow commands (new, plan, work, done, status, lint, fix) in a repo that may contain a scaffolded .ipd/ folder.
allowed-tools: shell
---

# ipd

Operate the **Ideas → Plans → Decisions** workflow in any repo where `./.ipd/` has been scaffolded (typically by the `init-ipd` skill).

The full workflow specification lives inside the (gitignored) `./.ipd/AGENTS.md` file — this skill is a thin loader and command router on top of it. **Never duplicate the spec here** — `.ipd/AGENTS.md` is the single source of truth.

---

## When to Use

Trigger this skill when:

- The user invokes any `/ipd <subcommand>` (e.g. `/ipd new`, `/ipd plan`, `/ipd work`, `/ipd done`, `/ipd status`).
- The user references IPD commands in any form (`ipd:new`, "claim an idea", "what's in progress", "mark NNNN done") inside a repo that may contain a `.ipd/` folder.

If you are not sure whether the repo has `.ipd/` scaffolded, run the **Detection** step first.

---

## Step 1 — Detection

```bash
test -f ./.ipd/AGENTS.md && echo "IPD_FOUND" || echo "IPD_MISSING"
```

- **`IPD_FOUND`** → continue to Step 2.
- **`IPD_MISSING`** → **stop and prompt the user.** Ask:

  > `./.ipd/AGENTS.md` was not found in this repo. The `/ipd` skill requires a scaffolded IPD workflow. Do you want me to run `init-ipd` first to scaffold it?

  Do **not** auto-run `init-ipd`. Wait for explicit confirmation.

---

## Step 2 — Load the Workflow Spec

Read `./.ipd/AGENTS.md`. That file is the complete, standalone specification for the IPD workflow. Follow its rules verbatim — especially:

- ID rules (claim with `get-next-ipd-id.sh`, never hand-edit `nextid`, never reuse IDs).
- Session-start ritual (`bash .ipd/scripts/session-status.sh`).
- Commit convention (`[NNNN]: short description`).
- Status values and stage transitions (Idea → Plan → Decision/ADR).

If `.ipd/AGENTS.md` references any rules you don't understand, re-read it — do not invent.

---

## Step 3 — Mandatory Session Start

**Every session must begin with:**

```bash
bash .ipd/scripts/session-status.sh
```

Then check `.ipd/log.md` — if the current work already has an ID, reuse it. Only call `get-next-ipd-id.sh` for brand-new work.

---

## Step 4 — Command Surface

The skill routes `/ipd <subcommand>` to actions defined in `.ipd/AGENTS.md`. Subcommands:

| Command | Action | Source of truth |
|---------|--------|-----------------|
| `/ipd help` | Print this table + the relevant section of `.ipd/AGENTS.md`. | this skill |
| `/ipd status` | Run `bash .ipd/scripts/session-status.sh` and read `.ipd/log.md`. | .ipd/scripts + .ipd/AGENTS.md |
| `/ipd new <title>` | Claim an ID, create `.ipd/ideas/NNNN-<slug>.md` from the idea template, append a row to `.ipd/log.md`, stage `.ipd/nextid`. | .ipd/AGENTS.md → "New Idea" |
| `/ipd idea <title>` | Alias of `/ipd new`. | .ipd/AGENTS.md |
| `/ipd plan <NNNN>` | Create `.ipd/plans/NNNN-<slug>.md` from the plan template (same NNNN), update idea + log. | .ipd/AGENTS.md → "Ready to Implement" |
| `/ipd work <NNNN>` | Set plan status to `In Progress`, mark the session claim. | .ipd/AGENTS.md → "While Working" |
| `/ipd done <NNNN>` | Create the ADR, update plan + log to `Implemented`, remove the session claim. | .ipd/AGENTS.md → "On Completion" |
| `/ipd lint` | Verify log.md ↔ files on disk; check status consistency; report any drift. (No script — manual cross-check.) | .ipd/AGENTS.md |
| `/ipd fix` | Auto-fix ID-conflict and reference issues found by `/ipd lint`. | .ipd/AGENTS.md |

### How to route a command

1. Parse `<subcommand>` and its arguments.
2. Follow the matching section in `.ipd/AGENTS.md` verbatim — the skill never overrides the workflow spec.
3. Use the existing `.ipd/scripts/get-next-ipd-id.sh` to claim IDs; never hand-edit `.ipd/nextid`.
4. After each mutation, update `.ipd/log.md` (one row per work item).
5. **Never commit** — per `.ipd/AGENTS.md` agent rule. Stage with `git add`, summarize, stop and wait for owner approval.

---

## Step 5 — When to Escalate

Stop and ask the user if:

- `.ipd/AGENTS.md` is missing (Step 1) — never auto-initialize.
- The user asks you to delete or move an idea/plan/decision file (against the rules — mark superseded instead).
- A command would require editing `.ipd/nextid` by hand.
- You're unsure whether the requested subcommand matches anything in the table.

---

## What This Skill Is NOT

- It is **not** a replacement for `.ipd/AGENTS.md` — that file is authoritative.
- It does **not** scaffold `.ipd/` into a fresh repo — use the `init-ipd` skill for that.
- It does **not** create or manage `.ipd/.sessions/<id>` claim files directly — the workflow spec owns that.

---

## See Also

- `init-ipd` skill — scaffolds `.ipd/` (one-shot setup).
- `.ipd/AGENTS.md` — complete workflow specification (load this on every invocation).