---
name: init-ipd
description: Scaffold the Ideas→Plans→Decisions (.ipd) workflow into any repository. Creates a hidden .ipd/ folder with templates and scripts, plus a root AGENTS.md for quick reference — all gitignored so project tree stays clean.
allowed-tools: shell
---

# init-ipd

Bootstrap any repository with the AI-friendly **Ideas → Plans → Decisions** workflow.

The entire workflow lives in a hidden `.ipd/` folder — gitignored like `.vscode/` or `.idea/` — so your project tree stays clean.

## Usage

```
# Via Copilot skill
init-ipd [--dir <path>] [--project <name>] [--owner <name>]
```

`--dir` defaults to the current working directory.

## What Gets Scaffolded

```
AGENTS.md                 ← root agent manifest (quick reference)
.ipd/
  AGENTS.md              ← full workflow spec
  ideas/
    0000-template.md
  plans/
    0000-template.md
  decisions/
    0000-template.md
  log.md
  nextid                 ← atomic counter (starts at 0001)
  scripts/
    get-next-ipd-id.sh
    session-status.sh
  .sessions/
```

`.ipd/` is appended to the repo's `.gitignore` automatically.

## Examples

```
# Scaffold into the current repo
init-ipd

# Scaffold into another repo
init-ipd --dir ~/dev/my-project --project "My Project" --owner "Jane Doe"
```

## After Scaffolding

Open an LLM session and read `.ipd/AGENTS.md` — that file is the complete specification for operating the workflow.
