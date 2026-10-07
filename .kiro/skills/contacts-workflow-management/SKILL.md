---
name: contacts-workflow-management
description: Optional contacts layer. Keep a private address book of the people on a project (roles, usernames, emails) and reusable communication templates, and use them to draft mails or ticket comments without guessing usernames. Use when the user asks to add, look up, or change a contact, mentions a colleague by name for a mention or recipient, or asks to draft a message, mail, or ticket comment.
---

# Contacts Workflow Management

Use this skill only for contacts and communication drafting. It sits on top of
the `workflow-management` skill and never replaces it. The core skill works
exactly the same without it.

## Where this skill's files are

`references/...` and `templates/...` sit in the folder that contains this
`SKILL.md`: `.kiro/skills/contacts-workflow-management/` in the workspace, or
`~/.kiro/skills/contacts-workflow-management/` in the user's home folder. Read
them from there with the file-read tool. Do not search the workspace for them, and
do not conclude that they are missing before trying both places.

## Order of work

1. **Personal context first.** Make sure a personal context resolves
   (`workflow-management`, `CORE.md`). If none does, stop here, load
   `workflow-management`, and create it first. Then come back.
2. **Read `references/contacts.md`** before reading, creating, or changing
   anything.
3. This skill writes two files at the root of the **personal** context:
   `CONTACTS.md` (the people) and, only when the user agrees, `CONTACTS.config.json`
   (their preferences, kept outside the skill so an update never loses them).
   Nothing else: no project scaffolding, no other folders, and no change to
   `.workflow-config.json`.

## Rules that always apply

1. **Private by default.** `CONTACTS.md` holds names and email addresses, and
   `CONTACTS.config.json` holds the user's preferences. They live only in the
   personal context. Never write them into a team context, a project
   repository, or any shared or public repository, and never copy real contacts
   into examples, notes, commit messages, or other records.
2. **Never guess a username.** A username is never derived from a person's name.
   Use the value in `CONTACTS.md`, or ask the user to read it from the person's
   profile in their system.
3. **Never invent** a recipient, username, email address, or role. If it is not in
   the record, say so and ask.
4. **Draft only.** This skill produces text. It does not send mail, post comments,
   call a tracker, or read any service. The user sends it.
5. **The format is the user's.** The skill proposes five standard fields (name,
   username, role, email, notes); the user may add or rename columns. Read the
   header row and follow it. These rules depend on those concepts, never on exact
   column names.
6. **Inspect before writing, preserve the rest.** People edit `CONTACTS.md` by
   hand; never overwrite it, delete a column or a row, or reorder what you were
   not asked to change. On a conflict between two values, show both and ask.
7. **Ask before writing, one question at a time.** Confirm the recipient before
   handing over a draft.

## Which reference to read

- The layout, reading an existing file, aligning and merging data, usernames,
  homonyms, configuration, templates, the draft flow, and the privacy boundary:
  `references/contacts.md`.
- The starter record created on first use: `templates/CONTACTS.md`, and an example
  of the optional preferences file: `templates/CONTACTS.config.json`.
