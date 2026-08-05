---
name: ipd
description: Detect a gitignored ./.ipd/ or ./ipd/ folder in the current repo, load its AGENTS.md, and route /ipd <subcommand> to the existing .ipd/scripts/* tooling. Use whenever the user invokes /ipd or mentions IPD workflow commands (new, plan, work, done, status, lint, fix) in a repo that may contain a scaffolded .ipd/ or ipd/ folder.
allowed-tools: shell
---

# ipd

Operate the **Ideas → Plans → Decisions** workflow in any repo where `./.ipd/` or `./ipd/` has been scaffolded (typically by the `init-ipd` skill).

The full workflow specification lives inside the (gitignored) `./.ipd/AGENTS.md` file — this skill is a thin loader and command router on top of it. **Never duplicate the spec here** — `.ipd/AGENTS.md` is the single source of truth.

---

## When to Use

Trigger this skill when:

- The user invokes any `/ipd <subcommand>` (e.g. `/ipd new`, `/ipd plan`, `/ipd work`, `/ipd done`, `/ipd status`).
- The user references IPD commands in any form (`ipd:new`, "claim an idea", "what's in progress", "mark NNNN done") inside a repo that may contain a `.ipd/` folder.

If you are not sure whether the repo has `.ipd/` scaffolded, run the **Detection** step first.

---

## Step 1 — Detection

Detect both `.ipd/` and `ipd/` folders using a reliable POSIX-compatible pattern:

```bash
ipd_dir=""
for dir in .ipd ipd; do
  if [ -f "$dir/AGENTS.md" ]; then
    ipd_dir="$dir"
    break
  fi
done

if [ -n "$ipd_dir" ]; then
  echo "IPD_FOUND:$ipd_dir"
else
  echo "IPD_MISSING"
fi
```

- **`IPD_FOUND:<folder>`** → capture the folder name (`.ipd` or `ipd`), continue to Step 2 using the captured folder name.
- **`IPD_MISSING`** → **stop and prompt the user.** Ask:

  > Neither `.ipd/` nor `ipd/` was found in this repo. The `/ipd` skill requires a scaffolded IPD workflow. Do you want me to run `init-ipd` first to scaffold it?

  Do **not** auto-run `init-ipd`. Wait for explicit confirmation.

---

## Step 2 — Load the Workflow Spec

Parse the captured folder name from Step 1 detection result (`$ipd_dir`).

Read `$ipd_dir/AGENTS.md`. That file is the complete, standalone specification for the IPD workflow. Follow its rules verbatim — especially:

- ID rules (claim with `$ipd_dir/scripts/get-next-ipd-id.sh`, never hand-edit `$ipd_dir/nextid`, never reuse IDs).
- Session-start ritual (`bash $ipd_dir/scripts/session-status.sh`).
- Commit convention (`[NNNN]: short description`).
- Status values and stage transitions (Idea → Plan → Decision/ADR).

If `$ipd_dir/AGENTS.md` references any rules you don't understand, re-read it — do not invent.

---

## Step 3 — Mandatory Session Start

**Every session must begin with:**

```bash
bash $ipd_dir/scripts/session-status.sh
```

Then check `$ipd_dir/log.md` — if the current work already has an ID, reuse it. Only call `$ipd_dir/scripts/get-next-ipd-id.sh` for brand-new work.

---

## Step 4 — Command Surface

The skill routes `/ipd <subcommand>` to actions defined in `$ipd_dir/AGENTS.md`. Subcommands (replace `$ipd_dir` with detected folder: `.ipd` or `ipd`):

| Command | Action | Source of truth |
|---------|--------|-----------------|
| `/ipd help` | Print this table + the relevant section of `$ipd_dir/AGENTS.md`. | this skill |
| `/ipd status` | Run `bash $ipd_dir/scripts/session-status.sh` and read `$ipd_dir/log.md`. | $ipd_dir/scripts + $ipd_dir/AGENTS.md |
| `/ipd new <title>` | Claim an ID, create `$ipd_dir/ideas/NNNN-<slug>.md` from the idea template, append a row to `$ipd_dir/log.md`, stage `$ipd_dir/nextid`. | $ipd_dir/AGENTS.md → "New Idea" |
| `/ipd idea <title>` | Alias of `/ipd new`. | $ipd_dir/AGENTS.md |
| `/ipd plan <NNNN>` | Create `$ipd_dir/plans/NNNN-<slug>.md` from the plan template (same NNNN), update idea + log. | $ipd_dir/AGENTS.md → "Ready to Implement" |
| `/ipd work <NNNN>` | Set plan status to `In Progress`, mark the session claim. | $ipd_dir/AGENTS.md → "While Working" |
| `/ipd done <NNNN>` | Create the ADR, update plan + log to `Implemented`, remove the session claim. | $ipd_dir/AGENTS.md → "On Completion" |
| `/ipd lint` | Verify `$ipd_dir/log.md` ↔ files on disk; check status consistency; report any drift. (No script — manual cross-check.) | $ipd_dir/AGENTS.md |
| `/ipd fix` | Auto-fix ID-conflict and reference issues found by `/ipd lint`. | $ipd_dir/AGENTS.md |

### How to route a command

1. Parse `<subcommand>` and its arguments.
2. Follow the matching section in `$ipd_dir/AGENTS.md` verbatim — the skill never overrides the workflow spec.
3. Use the existing `$ipd_dir/scripts/get-next-ipd-id.sh` to claim IDs; never hand-edit `$ipd_dir/nextid`.
4. After each mutation, update `$ipd_dir/log.md` (one row per work item).
5. **Never commit** — per `$ipd_dir/AGENTS.md` agent rule. Stage with `git add`, summarize, stop and wait for owner approval.

---

## Step 5 — When to Escalate

Stop and ask the user if:

- `$ipd_dir/AGENTS.md` is missing (Step 1) — never auto-initialize.
- The user asks you to delete or move an idea/plan/decision file (against the rules — mark superseded instead).
- A command would require editing `$ipd_dir/nextid` by hand.
- You're unsure whether the requested subcommand matches anything in the table.

---

## What This Skill Is NOT

- It is **not** a replacement for `$ipd_dir/AGENTS.md` — that file is authoritative.
- It does **not** scaffold `.ipd/` or `ipd/` into a fresh repo — use the `init-ipd` skill for that.
- It does **not** create or manage `$ipd_dir/.sessions/<id>` claim files directly — the workflow spec owns that.

---

## See Also

- `init-ipd` skill — scaffolds `.ipd/` or `ipd/` (one-shot setup).
- `$ipd_dir/AGENTS.md` — complete workflow specification (load this on every invocation).