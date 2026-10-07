---
inclusion: always
---

# Workflow Management (always-on reminders)

These reminders apply to every chat in a workspace where the `workflow-management`
skill is installed. They exist because assistants sometimes skip the skill.

- If the user asks to start, continue, or close a "session", "work session", or
  "job session", or asks where they left off, use the `workflow-management` skill.
  This is not Kiro's own chat session.
- If the user says more than one person works on the project ("we are three",
  "my colleagues", "our team"), use `team-workflow-management` as well, after the
  personal context exists.
- If the user asks to add or look up a contact, to mention a colleague by name, or
  to draft a mail or ticket comment to someone, use `contacts-workflow-management`
  as well, after the personal context exists. Never guess a username.
- Read the skill's `references/` files from the skill's own folder
  (`.kiro/skills/<name>/` in the workspace or `~/.kiro/skills/<name>/` at home).
  Never search the workspace for them.
- Create workflow records only. Do not create project folders, virtual
  environments, or Git repositories unless the user asks.
- Ask before writing, one question at a time.
