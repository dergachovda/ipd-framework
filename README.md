# ipd-framework

A lightweight, AI-friendly **Ideas → Plans → Decisions** workflow you can drop into any repository in seconds.

Inspired by the [llm-wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) by Andrej Karpathy — a self-contained `AGENTS.md` manifest is all an LLM needs to operate the full workflow correctly.

## The Concept

Every piece of work follows a three-stage lifecycle:

```
.ipd/ideas/NNNN-<slug>.md  →  .ipd/plans/NNNN-<slug>.md  →  .ipd/decisions/NNNN-<slug>.md
```

All three stages share **one atomic NNNN ID** claimed at idea creation. The entire workflow lives in a hidden, gitignored `.ipd/` folder — like `.vscode/` or `.idea/` — so your project tree stays clean.

## Quick Start

### Via Copilot CLI skill (after install)

```
init-ipd
```

### Via script

```bash
bash src/scripts/init-ipd.sh [--dir <path>] [--project <name>] [--owner <name>]
```

Both default to the current working directory.

## What Gets Scaffolded

```
.ipd/                         ← gitignored by default
  AGENTS.md                   ← standalone agent manifest (the full workflow spec)
  ideas/
    0000-template.md
  plans/
    0000-template.md
  decisions/
    0000-template.md
  log.md                      ← index of all work items
  nextid                      ← atomic counter (seeded at 0001)
  scripts/
    get-next-ipd-id.sh        ← claim the next ID atomically
    session-status.sh         ← show active session slots
  .sessions/                  ← local session claim files (transient)
```

`.ipd/` is appended to the target repo's `.gitignore` automatically.

## The Workflow (Human)

1. **New idea** → run `get-next-ipd-id.sh`, create `.ipd/ideas/NNNN-slug.md`
2. **Ready to implement** → create `.ipd/plans/NNNN-slug.md` (same NNNN)
3. **Done** → write `.ipd/decisions/NNNN-slug.md` (same NNNN), update log

## The Workflow (LLM Agent)

Open an LLM session in your repo and say:

| Say this... | What happens |
|-------------|-------------|
| `new idea: <concept>` | Agent claims an ID, writes the idea file, updates log |
| `plan NNNN` | Agent creates the plan file for an existing idea |
| `what's in progress?` | Agent reads `.ipd/log.md`, reports active items |
| `mark NNNN done` | Agent writes the ADR, closes out the work item |

The full agent rules live in `.ipd/AGENTS.md` — the LLM reads that file to know exactly how to operate.

## Install

```bash
# Copy the init-ipd skill to ~/.copilot/skills/
bash install.sh
```

## Commit Convention

```
[NNNN]: short description   ← 1–7 words, lowercase, no full stop
```

## Owner

Dmytro Derhachov — dergachovda@gmail.com
