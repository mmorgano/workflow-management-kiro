---
name: workflow-management
description: Maintain durable, file-based work context across AI sessions, including session logs, RECAP, workflow tasks, sprints, saved notes, meeting outcomes, roadmaps, and archives. Use when the user asks to start, resume, or close a work session ("start a session", "new work session", "job session", "start of the day", "where did we leave off"), to preserve, resume, or organize context beyond the current conversation, or to start a new project, repository, or component from scratch. A work session here is recorded in files in the context folder; it is not Kiro's own chat session. Do not use for ordinary coding or one-off questions with no request for durable records.
---

# Workflow Management for Kiro

Use this skill only for durable workflow context: managed sessions, persistent
task records, saved or resumed notes, meeting outcomes, sprints, roadmaps,
steering documents, decision records, long-running project tracking, RECAP
review, session archives, or bootstrapping a new repository or component. A
request to start a managed work session must activate this workflow instead of
becoming a general workspace analysis. Do not turn an ordinary coding request,
one-off explanation, or transient to-do list into workflow records.

## Where this skill's files are

The files named below (`CORE.md`, `conventions.md`, `references/...`) sit in the
folder that contains this `SKILL.md`: `.kiro/skills/workflow-management/` in the
workspace, or `~/.kiro/skills/workflow-management/` in the user's home folder.
Read them from there with the file-read tool. Do not search the workspace for
them, and do not conclude that they are missing before trying both places.

## What this skill never does

It creates workflow records only: the context folder, `.workflow-config.json`,
`RECAP.md`, `tasks/`, `sessions/` and similar. Do not create project scaffolding
(`src/`, `docs/`, `tests/`, `scripts/`), virtual environments, other
configuration files, or a Git repository unless the user asks for them.

## In Kiro, "session" is ambiguous

When the user asks to start, continue, or close a "session", "job session", or
"work session", this is that request: follow this skill. Do not answer with
Kiro's own session update, and do not turn it into a general question about what
to build. If it is truly unclear, ask one short question that names this skill as
the first option.

Before changing the workflow context:

1. Read `CORE.md` for context resolution and shared invariants.
2. Read `conventions.md` before writing records.
3. Read only the references relevant to the request:
   - `references/sessions.md` for session lifecycle;
   - `references/tasks.md` for tasks and RECAP;
   - `references/recap-maintenance.md` for oversized RECAP or task-index
     maintenance;
   - `references/planning-and-notes.md` for sprints, saved notes, meetings, or
     roadmaps;
   - `references/steering.md` for project intake, steering documents, decision
     records, session rituals, or documentation hygiene;
   - `references/tracking.md` for the `long-vision` tracking tier, status
     reports, a Risk & Issue register, phase-gates, or the extended closure
     checks;
   - `references/bootstrap.md` for starting a new repository, component,
     package, or service from scratch;
   - `references/setup-guided.md` for agent-guided context initialization;
   - `references/onboarding.md` for the first-run introduction when no context
     resolves, or for plain-language answers about folders, what else the skill
     can do, or tasks versus a long project;
   - `references/compaction.md` for retention and archives.

For session start or close, also read the task rules because session lifecycle
can initialize or update RECAP. Read planning rules only when sprints are
enabled or another planning record is involved.

## Configuration

The runtime configuration is `<AI_CONTEXT_ROOT>/.workflow-config.json`. Prefer
agent-guided setup (`references/setup-guided.md`): create the configuration and
directory layout directly with the available file tools, asking before
overwriting anything. The setup scripts are an optional fallback for technical
users.

Follow the context resolution order in `CORE.md`. Do not infer the context by
broadly analyzing the workspace, and never attach a context that belongs to a
different workspace. If no workspace is open at all (no folder, or only a plain
directory that was not opened as a workspace) and the order resolves nothing,
follow `references/sessions.md` § "No workspace at all" first: say so in one
sentence, offer to open a workspace folder or to use an explicit path, and create
nothing until the user answers. If nothing resolves, follow
`references/sessions.md` § "When no context resolves".

## Team support (optional)

This edition adds an optional shared team context. It is handled by the
separate `team-workflow-management` skill in this package. If that skill is
not installed, ignore this section and behave exactly as described above.

When it is installed:

- **Team signals: act on them.** If the user says or implies that more than one
  person works on this project ("we are three", "my colleagues", "our team",
  "shared tasks", "assign this to ..."), do not carry on with a personal-only
  setup. In that same turn read the `team-workflow-management` skill and follow
  its setup questions. This applies even if the personal context already exists
  and even if the user never says "team context". Skipping it silently is a
  mistake: at least tell the user the team option exists and ask.
- **What is a team context.** A folder is a team context when its
  `.workflow-config.json` has `"role": "team"`, **or** when its name starts with
  `ai_context_TEAM_` and it is a Git repository, even if its configuration is
  missing or unreadable. A team context does not need `ai_context_root`
  (that path would be different on every machine).
- **Resolution.** A team context is never the primary context, at any step of
  the resolution order in `CORE.md`: not as a workspace root (step 2), not as
  the working directory (step 3), and not through the user-local pointer
  (step 4); never write the pointer so that it points to a team context. Pick the
  primary context among the non-team candidates using the same order.
  - Personal context plus team context: the personal one is primary; the team
    one is an extra view. Do not ask "which one?" because a team folder is
    present.
  - Two or more personal contexts: ask which one, as `CORE.md` says.
  - Only a team context, no personal one: read it, but record nothing in it.
    Treat it as "no context resolves" and offer to create a personal context
    (`references/onboarding.md`, then `references/sessions.md`).
  - No context at all: `references/onboarding.md`.
- **Privacy boundary.** Sessions, `LAST_SESSION.md`, focus notes, and the
  personal `RECAP.md` stay in the personal context. Never write them into a team
  context.
- **Onboarding.** This step is mandatory when the team skill is installed. After
  step 4 of `references/onboarding.md`, ask the team question described in
  `../team-workflow-management/references/team-setup.md`. That reference says
  the core edition creates a personal context only; in this edition the team
  question replaces that sentence. A person who already has a personal context
  and later asks to add or join a team context is handled directly by
  `team-workflow-management`; onboarding does not run again.
- **Team tasks.** Team contexts have no `tasks/INDEX.md` or task numbers. For
  shared tasks follow `../team-workflow-management/references/team-tasks.md`,
  not `references/tasks.md`.
- **Shared work.** Before creating, assigning, or changing shared tasks or the
  shared roadmap, read the `team-workflow-management` skill.

## Kiro behavior

- Treat the context directory as user data: inspect before changing it.
- Keep records proportional to the request and preserve unrelated content.
- Ask for confirmation before compaction, deletion, external publication, or
  execution of a non-trivial plan when approval has not already been given.
- Prefer a dry run before real compaction.
- Never invent remotes, credentials, or access rules.
- Report what was verified and what remains unverified.

## Windows: fs_write ENOENT during setup (known Kiro bug)

On Windows, `fs_write` (and any tool call that produces a session snapshot)
can fail with an ENOENT error whenever the target is an absolute path — the
file is still written correctly, but the error interrupts the flow on every
call. This is a Kiro platform bug in the session-snapshot path construction,
not something these instructions can prevent from inside a single `fs_write`
call. Tracked upstream at kirodotdev/Kiro#11636 (related: #670, #10897).

If this happens:

- For the first-time context setup described in `references/setup-guided.md`,
  run `init-session.ps1` (in this skill's folder) through `execute_pwsh`
  instead of writing each file with `fs_write`. It creates the folder layout,
  `.workflow-config.json`, the user-local pointer (unless `-Here` is passed),
  and the initial `RECAP.md` / `tasks/INDEX.md` / today's session file in one
  call, using `[System.IO.File]::WriteAllText()` so the snapshot system is
  never involved. Confirm `ContextRoot`, `WorkspacePath`, and
  `RecordLanguage` with the user first, exactly as `setup-guided.md` already
  requires.
- For any other single write that hits this error, fall back to
  `execute_pwsh` with `[System.IO.File]::WriteAllText(<path>, <content>,
  (New-Object System.Text.UTF8Encoding($false)))` instead of retrying
  `fs_write`.
- Always report to the user that the fallback was used and why, rather than
  silently switching tools.
