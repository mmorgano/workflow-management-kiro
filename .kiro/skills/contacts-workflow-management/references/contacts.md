# Contacts

Read this reference before reading, creating, or changing the address book, and
before drafting any message that names a person.

## Where the record lives

One record, `CONTACTS.md`, at the root of the **personal** context
(`ai_context_<name>`), next to `RECAP.md`. It is personal data about other people,
so it is private by default.

- Never create it in a team context (`ai_context_TEAM_<prj_name>`): the team
  context is shared, and this record must not be.
- Never create it inside a project's code repository.
- Before creating it, check whether the personal context has a Git remote. If it
  does, ask the user to confirm that the repository is **private**. If they are
  unsure or it is public, do not create the record there; offer a local-only
  alternative and let the user decide.
- If the personal context is a Git repository, offer to add `CONTACTS.md` to its
  `.gitignore` when the user does not want it pushed at all. Do not edit
  `.gitignore` without asking.

## Create on first use

Create `CONTACTS.md` only when the user asks to add a contact or to use the
address book, and only if it does not exist. Copy `templates/CONTACTS.md` from
this skill's folder, translate its headings and prose to `record_language`
(default English), keep the table column keys as written, and remove the example
rows after the user has added a real one. Never overwrite an existing file.

## Structure

```text
# <Project> — Contacts
<one-line purpose and the verify-don't-guess note>

## <Unit or group>          one section per unit or team
| Name | Role | Tracker username | System user | Email | Notes |

> Homonym warnings, one per pair

## External                  people outside the team
| Name | Role | Tracker username | Notes |

## Templates                 communication templates (see below)

## How to find a tracker username
## Mention syntax
```

- Use `—` for an unknown value; never leave a guess in a cell.
- `TBD` means "known to exist, username not verified yet". Treat it as unknown.
- Keep a person in one section only. Move them rather than duplicating them.
- Table column names and the section keys above stay as written in any language;
  headings and prose follow `record_language`.

## Usernames: verify, never guess

Trackers often assign non-standard usernames to avoid duplicates, so a username is
not derivable from a name.

- When a contact is added, ask for the username as shown in the tracker profile.
  If the user does not have it, record `TBD` and say how to find it (the "How to
  find a tracker username" section).
- When a draft needs a mention and the username is `—` or `TBD`, stop and ask. Do
  not construct one from the name.
- When the tracker, recipient, or ticket suggests a different person than the one
  in the record (for example the reporter differs from the intended recipient),
  say so and confirm.

## Homonyms

When two people have the same or similar names, add a blockquote warning right
under the table that names both with their usernames and states that they are
different people.

- Check for homonyms every time a contact is added: same first name, same family
  name, or one name contained in the other. If one exists, propose the warning
  and ask before writing it.
- When a draft or lookup matches more than one contact, never pick one silently:
  list the candidates with role and username and ask which one is meant.

## Templates

A template is a reusable message skeleton kept in the `## Templates` section of
`CONTACTS.md`, so the record stays self-contained.

Each template has: a name, a short purpose, the greeting line, the sign-off, and
the tone (for example "brief, neutral"). Placeholders:

| Placeholder | Replaced with |
|---|---|
| `{recipient}` | the mention for a ticket comment, or the display name for a mail |
| `{sender}` | the sender name from configuration, or the one the user gives |

Keep templates short. Add or change one only when the user asks.

## Configuration

An optional block in the personal context's `.workflow-config.json`:

```json
"contacts": {
  "default_template": "default",
  "mention_format": "@{username}",
  "sender": "Your Name"
}
```

| Field | Meaning | If absent |
|---|---|---|
| `default_template` | name of the template used when the user does not pick one | the first template in `CONTACTS.md`; if there is none, a plain greeting and sign-off with no placeholders invented |
| `mention_format` | how a username is written in a ticket comment; `{username}` is replaced | no mention syntax: write the display name and say that the tracker mention was not configured |
| `sender` | name used in the sign-off | ask the user once per draft; never take it from the machine or the Git identity |

Read the block, do not require it. Add or change it only when the user asks, and
preserve every other key in the file.

## Draft flow

When the user asks to draft a mail or a ticket comment:

1. Identify the recipients **from the request**. Resolve each against
   `CONTACTS.md`. No match: say so and ask; do not invent one. Several matches:
   see Homonyms.
2. Confirm the recipient and, for a ticket comment, the verified username.
3. Choose the template: the one the user names, else `default_template`, else the
   first one.
4. Write the draft by applying the template to the user's content. Do not add
   facts, commitments, or recipients the user did not give.
5. Show the draft and say who it is addressed to. The user reviews and sends it.
   Never claim it was sent.

An email address that is `—` is simply not available: leave it out and say so.

## Privacy boundary

- Real contacts appear only in `CONTACTS.md` in the personal context.
- Do not quote them in sessions, RECAP, tasks, focus notes, roadmaps, decision
  records, commit messages, or a team context. Refer to a person by role if a
  shared record needs to.
- If asked to put contacts into a team or shared record, refuse and explain that
  it would publish personal data; offer a role-only reference instead.
- Do not read contacts from outside the workspace or from any service. Only what
  the user typed or what is already in `CONTACTS.md`.

## Out of scope

Sending mail, posting comments, calendars, reading or scraping a tracker, looking
up people online, and synchronizing contacts with another tool.
