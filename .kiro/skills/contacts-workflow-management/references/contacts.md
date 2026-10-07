# Contacts

Read this reference before reading, creating, or changing the address book, and
before drafting any message that names a person.

## Where the files live

Two files, both at the root of the **personal** context (`ai_context_<name>`),
next to `RECAP.md`:

- `CONTACTS.md`: the people.
- `CONTACTS.config.json`: the user's preferences (see "Configuration"). Optional.

Both are private. `CONTACTS.md` holds personal data about other people, and the
configuration belongs to the user. Keeping the configuration in its own file in
the context, and not in this skill's folder, means that updating or reinstalling
the skill never loses it. No setup script of `workflow-management` touches it.

- Never create either file in a team context (`ai_context_TEAM_<prj_name>`): the
  team context is shared, and these files must not be.
- Never create them inside a project's code repository.
- Before creating `CONTACTS.md`, check whether the personal context has a Git
  remote. If it does, ask the user to confirm that the repository is **private**.
  If they are unsure or it is public, do not create the file there; offer a
  local-only alternative and let the user decide.
- If the personal context is a Git repository, offer to add both files to its
  `.gitignore` when the user does not want them pushed at all. Do not edit
  `.gitignore` without asking.

## The format is a suggestion, the concepts are the contract

The skill proposes a minimal layout. The user may add, rename, or reorder
columns and group people any way they like. The rules below never depend on a
column name, only on these concepts:

| Concept | Standard column | Meaning |
|---|---|---|
| name | `Name` | how the person is called |
| username | `Username` | the verified identifier used for mentions in the user's system (a tracker today, possibly another system tomorrow) |
| role | `Role` | free text |
| email | `Email` | the address, or unknown |
| notes | `Notes` | free text: context, disambiguation, anything else |

Any other column is a **custom field** (for example a team, a domain, a project,
a system user). The skill carries it along and never interprets it, except to
show it when asked.

There is one table. Do not split people into sections such as internal and
external: if the user wants to tell them apart or group them, they add a column
(or use `Notes`). Group headings are allowed only if the user already has them.

## Create on first use

Create `CONTACTS.md` only when the user asks to add a contact or to use the
address book, and only if it does not exist.

1. Show the proposed layout (the standard columns above) and say that it is only
   a starting point.
2. Ask **one** question: whether they want extra fields of their own (a team, a
   domain, a project, anything). Add the columns they name.
3. Copy `templates/CONTACTS.md` from this skill's folder, translate its headings
   and prose to `record_language` (default English), keep the column names as
   written plus the user's extra ones, and remove the example rows once the user
   has added a real one.

Never overwrite an existing file. Keep the format marker line
(`<!-- contacts-format: 1 -->`) so a future version of the skill knows which
layout the file was created with.

## Read an existing file

The header row of the table is the schema. Do not assume the standard names.

1. Find the column for each concept: an exact standard name first; otherwise a
   header that contains `username`, or `user` when it is the only such column,
   for the username; `mail` for the email; `role` for the role; `note` for the
   notes; and the first column for the name.
2. If a concept is ambiguous (for example two columns that both contain `user`)
   or missing, ask the user which column it is. Never choose silently.
3. After the user answers, offer to remember it in `CONTACTS.config.json`
   (`columns`). Save it only with a yes.
4. If the username column is missing, say so: without it the skill cannot offer
   verified mentions. Offer to add the column; do not add it unasked.

## Align with the proposal and merge data

Do this only when the user asks, or once, the first time the skill is used with an
existing file. Never write before the user has seen the plan.

**Structure.** Compare the header with the standard columns and report, in plain
words, what differs: a standard column that is missing, one with a different name
(it is mapped, not renamed), and the custom columns that exist. Propose additions
only. Never delete, merge, or reorder a column or a row, and never rewrite the
user's text.

**Data.** When the user pastes or dictates a list of people, merge it into the
table instead of replacing it:

- The same person is recognised by `Username` first, then by `Name`. A match by
  name alone with a different username is a homonym or a different person: ask.
- A new person is added as a new row, filling the user's own columns and `—` where
  a value is unknown.
- A value that is missing in the table is filled in from the new data.
- A value that differs is a **conflict**: show both values for that person and ask
  whether to keep the current one, replace it, or keep the current one and write
  the other into `Notes`. Decide each conflict separately, and never overwrite on
  your own.
- The same person found in two rows is a possible duplicate: ask before merging.

The skill never reads a tracker or any other service to fill the table. It only
merges what the user gives it.

## Adding or changing a contact

- Follow the user's columns, in their order. Ask for each value; `—` means
  unknown. Do not add or drop a column, and do not reformat the rest of the table.
- `TBD` means "known to exist, username not verified yet". Treat any empty cell,
  `—`, `TBD`, or `?` as unknown. If another marker looks like a placeholder, ask.

## Usernames: verify, never guess

Systems often assign non-standard usernames to avoid duplicates, so a username is
not derivable from a name.

- When a contact is added, ask for the username as shown in the person's profile
  in the user's system. If the user does not have it yet, record `TBD`.
- When a draft needs a mention and the username is unknown, stop and ask. Do not
  construct one from the name.
- When the ticket, thread, or recipient suggests a different person than the one
  in the record (for example the reporter differs from the intended recipient),
  say so and confirm.

## Homonyms

When two people have the same or similar names, write a short warning in the
`Notes` of **both** rows, naming the other person and their username and saying
that they are different people. A note stays with its row when the user sorts or
moves rows; a block under the table does not.

- Check for homonyms every time a contact is added: same first name, same family
  name, or one name contained in the other. If one exists, propose the notes and
  ask before writing them.
- When a draft or lookup matches more than one contact, never pick one silently:
  list the candidates with role and username and ask which one is meant.

## Configuration

`CONTACTS.config.json` is optional. Create it only when there is something to
save and the user agrees. Read it if it exists; never require it. Preserve every
key you do not know, and never rewrite the file for a change that does not need
it.

```json
{
  "format": 1,
  "columns": { "username": "Login" },
  "mention_format": "@{username}",
  "sender": "Your Name",
  "default_template": "default",
  "templates": {
    "default": {
      "purpose": "everyday mail or ticket comment",
      "greeting": "Dear {recipient},",
      "signoff": "Best regards,\n{sender}",
      "tone": "brief, neutral"
    }
  }
}
```

| Field | Meaning | If absent |
|---|---|---|
| `columns` | which header holds each concept, only where it differs from the standard name | read the header as described in "Read an existing file", asking when unsure |
| `mention_format` | how a username is written in a ticket comment; `{username}` is replaced | no mention syntax: write the display name and say that the mention format was not configured |
| `sender` | name used in the sign-off | ask the user once per draft; never take it from the machine or the Git identity |
| `default_template` | name of the template used when none is chosen | the first template; if there are none, a plain greeting and sign-off with no placeholders invented |
| `templates` | reusable message skeletons: greeting, sign-off, tone | ask for the wording |

The example above is only an example of the shape. Never fill a value the user has
not given.

### Templates

A template is a reusable skeleton. Placeholders: `{recipient}` is the mention for
a ticket comment or the display name for a mail; `{sender}` is the sender name.
Keep templates short. Add or change one only when the user asks.

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

An unknown email is simply not available: leave it out and say so.

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
