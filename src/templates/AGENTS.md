# .ipd/AGENTS.md — {{PROJECT}}

This file is the **complete and standalone specification** for the IPD workflow in this repository.
An LLM with only this file should be able to operate the full workflow correctly.

Scaffolded by [ipd-framework](https://github.com/dergachovda/ipd-framework) on {{DATE}}.
Owner: {{OWNER}}

---

## What Is IPD

**IPD** = **Ideas → Plans → Decisions**. Every piece of work follows this three-stage lifecycle:

```
.ipd/ideas/NNNN-<slug>.md  →  .ipd/plans/NNNN-<slug>.md  →  .ipd/decisions/NNNN-<slug>.md
```

All three stages share **one atomic NNNN ID** claimed at idea creation. Numbers are never reused.

---

## Structure

```
.ipd/                       ← gitignored — local to this developer
  AGENTS.md                 ← this file
  ideas/NNNN-<slug>.md      ← idea captures
  plans/NNNN-<slug>.md      ← actionable work items
  decisions/NNNN-<slug>.md  ← ADRs written on completion
  log.md                    ← index of all work items
  nextid                    ← plain-text atomic counter
  nextid.lock               ← GUID lock file (transient — deleted after use)
  scripts/
    get-next-ipd-id.sh      ← claim the next ID atomically
    session-status.sh       ← show active session slots
  .sessions/<NNNN>          ← local session claim files (transient, never commit)
```

---

## Variables

| Variable | Value |
|----------|-------|
| `ipd_dir` | `.ipd` |
| `scripts_dir` | `.ipd/scripts` |

---

## ID Rules

- `0000` is reserved for templates — never use for real work.
- **Always** claim a new ID with `get-next-ipd-id.sh` — never hand-edit `nextid`.
- An idea, its plan, and its ADR all share **the same NNNN**.
- IDs are never reused, even if a file is deleted.
- Check `log.md` first — if this work already has an ID, use it directly.

---

## Session Start

**Every agent session must start with:**

```bash
bash .ipd/scripts/session-status.sh   # see what's already in progress
```

Then check `.ipd/log.md` — if this work already exists, use the existing NNNN. Only call `get-next-ipd-id.sh` for brand-new work.

---

## Workflows

### New Idea

1. Claim an ID: `ID=$(bash .ipd/scripts/get-next-ipd-id.sh "brief description")`
2. Create `.ipd/ideas/${ID}-<slug>.md` from the template. Fill in Status, Summary, Motivation.
3. Add a row to `.ipd/log.md`: `| NNNN | Idea | Idea | <title> | [idea](...) |`
4. **Stage `.ipd/nextid` in the same commit as the idea file.** (The counter was incremented.)

### Ready to Implement

1. Create `.ipd/plans/${ID}-<slug>.md` using the **same NNNN** as the idea.
2. Fill in: Status (Draft), Goal, Steps, `Linked IPD: IPD-${ID}`.
3. Update `.ipd/log.md`: set Kind to `Idea+Plan`, Status to `In Progress`.
4. Update the idea file: set `Status: Planned → PLAN-${ID}`.

### While Working

- Keep the plan's Steps list current — check off items as they complete.
- Set plan `Status: In Progress` before touching any other files.

### On Completion

1. Create `.ipd/decisions/${ID}-<slug>.md` using the **same NNNN**.
   - Fill in: Context, Decision, Alternatives Considered, Consequences, Learnings.
   - Set `Status: Accepted`.
2. Update the plan: set `Status: Implemented`, add `Linked ADR: IPD-${ID}`.
3. Update `.ipd/log.md`: Kind → `Idea+Plan+ADR`, Status → `Implemented`, add ADR link.
4. Remove the session claim: `rm .ipd/.sessions/${ID}`

### Reversing a Decision

- Do **not** edit the old ADR.
- Create a new ADR with `Status: Accepted`. Reference the old one in Context.
- Update the old ADR's Status to `Superseded by IPD-NNNN`.

---

## Status Values

**Idea:**
| Status | Meaning |
|--------|---------|
| `Idea` | Captured, not yet planned |
| `Planned → PLAN-NNNN` | Plan file created |
| `Implemented` | Plan completed, ADR written |

**Plan:**
| Status | Meaning |
|--------|---------|
| `Draft` | Designed, not started |
| `In Progress` | Actively being worked on |
| `Implemented` | Done; ADR written |

---

## Commit Convention

```
[NNNN]: short description
```

- `NNNN` — the booked work-item ID
- Description — 1–7 words, lowercase, no full stop

Examples:
```
[0003]: add user authentication
[0007]: fix null pointer in parser
```

Use the same `[NNNN]` for all commits belonging to the same work item.

---

## Agent Rules

- **Never commit without explicit owner approval.** Stage changes, summarize, stop and wait.
- Check `.ipd/log.md` at session start — reuse existing IDs, never double-book.
- Stage `.ipd/nextid` in the same commit as any new idea/plan/decision file.
- Never commit `.ipd/.sessions/` files — they are local-only state.
- Never delete or move idea/plan/decision files — mark superseded items with a status update.
