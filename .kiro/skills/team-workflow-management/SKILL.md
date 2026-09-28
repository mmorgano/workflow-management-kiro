---
name: team-workflow-management
description: EXPERIMENTAL, untested beta. Manage a shared team context alongside a personal workflow context, including a shared roadmap, unassigned and assigned tasks, task outcomes such as duplicates, coordinators, and synchronization through Git. Use when the user says they work with colleagues or in a team, when a team shares work, when a shared task or roadmap must change, or when the user wants to create or join a team context.
---

# Team Workflow Management

> **Experimental beta.** This skill has not been tested yet. Tell the user so the
> first time it is used in a session, encourage them to try it on a scratch
> folder and repository first, and ask them to report anything that goes wrong.

Use this skill only when work is shared by more than one person. It sits on top
of the `workflow-management` skill and never replaces it: each person keeps a
**personal** context, and the team keeps one **shared** context. The shared
context is deliberately small.

## Where this skill's files are

`references/...` sit in the folder that contains this `SKILL.md`:
`.kiro/skills/team-workflow-management/` in the workspace, or
`~/.kiro/skills/team-workflow-management/` in the user's home folder. Read them
from there with the file-read tool. Do not search the workspace for them, and do
not conclude that they are missing before trying both places.

## Order of work

1. **Personal context first.** Before any team step, make sure a personal context
   resolves (`workflow-management`, `CORE.md`). If none does, stop here, load
   `workflow-management`, and create the personal context first. Then come back.
2. **Read `references/team-setup.md`** before creating anything.
3. **The team context is a separate Git repository**, in a folder **beside** the
   project and the personal context, named `ai_context_TEAM_<prj_name>`. Never
   create it inside the project folder or inside another repository, and never
   create it in a folder that already is a Git repository: it will hold names and
   email addresses.
4. This skill creates workflow records only. Do not create project scaffolding
   (`src/`, `docs/`, `tests/`), virtual environments, or configuration files other
   than the team `.workflow-config.json` described in `team-setup.md`.

## The model

- **Personal context** (`ai_context_<name>`): your sessions, notes, focus,
  RECAP, and private tasks. Never shared.
- **Team context** (`ai_context_TEAM_<prj_name>`): a dedicated Git repository,
  cloned locally and added as a root of the workspace next to the personal
  context. It holds only the roadmap, unassigned tasks, and assignments.
- The team context has `"role": "team"` in `.workflow-config.json`, written in
  English unless the team decides otherwise (`record_language`).

## Rules that always apply

1. **Nothing personal in the team context.** `sessions/`, `LAST_SESSION.md`,
   `focus/`, and personal notes are refused there. The team `.gitignore` also
   blocks them (see `references/team-setup.md`).
2. **Personal context is primary.** The team context never becomes the
   context a session is recorded in.
3. **Inspect before writing, preserve the rest.** People edit the roadmap and
   tasks by hand; never overwrite their work.
4. **Git is the source of truth.** Follow `references/sync.md` before you assign
   or change anything shared, and after you do.
5. **Roles are a convention, not access control.** Real permissions are the
   repository's. Say so if asked.
6. **Never invent** remotes, credentials, hosting names, or access rules. Ask.

## Which reference to read

- Creating or joining a team context, the onboarding team question, naming, the
  `.gitignore`: `references/team-setup.md`.
- Creating, assigning, closing, postponing, or discarding a shared task,
  duplicates, identifiers, the shared RECAP: `references/team-tasks.md`.
- Coordinators, who may change the roadmap or confirm a duplicate, handing over
  the role: `references/coordination.md`.
- Fetching, pulling, claiming a task, conflicts, when Git is unavailable:
  `references/sync.md`.

Read only what the request needs.
