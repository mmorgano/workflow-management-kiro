# Shared Tasks

Read this reference to create, assign, close, postpone, or discard a shared
task, to handle duplicates, or to update the shared RECAP.

## Identifier

A shared task is one file named `<date>-<short-name>.md`, for example
`2026-10-05-login-timeout.md`. The identifier is the file name without `.md`.
There is no central counter, so two people can create tasks on the same day
without a conflict. If the name already exists, choose a more precise name. A
readable number, if the team wants one, is given later by a coordinator and is
recorded in the file, never used as the file name.

## Task file

Use a small header, then free text (goal, context, success criteria):

```markdown
---
id: 2026-10-05-login-timeout
title: Login times out after five minutes
status: proposed
assigned_to:
proposed_by: <name>
created: 2026-10-05
---
```

Closing fields, added only when the task ends: `outcome`, `reason`,
`duplicate_of`, `closed`. Postponing adds `review_on`.

## Statuses and outcomes

- **Active statuses:** `proposed`, `accepted`, `assigned`, `in-progress`,
  `postponed`. Active tasks stay in `tasks/todo/`. A postponed task carries
  `review_on` and a reason.
- **Outcomes** (task ends, never deleted):
  - `done` — completed; the file moves to `tasks/done/`.
  - `duplicate`, `solved-elsewhere`, `not-useful`, `not-reproducible` — the file
    moves to `tasks/discarded/`.
- **A `reason` is mandatory for every outcome except `done`.** A `duplicate`
  also needs `duplicate_of`. Refuse to close without them.
- **The folder must match the state.** A task with an outcome lives in `done/` or
  `discarded/`; an active task lives in `todo/`. If a file's status and folder
  disagree (for example `status: done` in `todo/`), tell the user and propose the
  move; do not fix it silently.
- **Who does what** is in `references/coordination.md`: who accepts a proposed
  task, who may discard, and who may close.
- The header is text a person may edit by hand. If it looks broken, ask before
  repairing it.

## Assignment

`assigned_to` holds one canonical name per person: the display name they have in
`coordination/COORDINATORS.md` if they are listed, otherwise their Git
`user.name`. Ask when unsure, so "Marco" and "marco r." do not both appear. It
can change without renaming the file; empty means unassigned. Before assigning, or assigning yourself, follow
`references/sync.md`: fetch first, and the assignment counts only once it has
been pushed. If the push is refused, say the task is already taken and by whom.

## Duplicates

Anyone can flag a task with `possible_duplicate_of: <id>` and a short reason.
A coordinator confirms it (see `references/coordination.md`). On confirmation:

1. the task that stays gets a note: "Absorbs `<id>`: <why this one was kept>";
2. the other moves to `tasks/discarded/` with `outcome: duplicate`,
   `duplicate_of: <kept id>` and a reason;
3. nothing is deleted, and nothing is renamed.

## Shared RECAP

`RECAP.md` in the team context is a **derived view**, written only by a
coordinator: active tasks by person and area, postponed tasks with their review
date, and counts of done and discarded tasks with a link to the folders. It never
holds detail that a task file already holds. Keep it operational: when it grows,
follow `workflow-management`'s `references/recap-maintenance.md`, with history
under `archive/recap/`. Open tasks are never moved out of it.

## What never goes here

Personal notes, session records, private tasks, and anything the user has not
agreed to share. If the user asks to put such material here, refuse and explain
where it belongs (the personal context).
