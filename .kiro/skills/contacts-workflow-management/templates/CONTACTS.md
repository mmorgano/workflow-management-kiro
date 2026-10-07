# <Project> — Contacts

Reference for tracker mentions and team communication. Private: this file holds
personal data and stays in the personal context.

Note: trackers may assign non-standard usernames to avoid duplicates. Always
verify the username from the person's tracker profile — do NOT guess it from the
name. `—` means unknown, `TBD` means the username is not verified yet.

## Example Unit

| Name | Role | Tracker username | System user | Email | Notes |
|------|------|------------------|-------------|-------|-------|
| Alex Example | Team lead | aexample | — | — | Example row, replace it |
| Sam Sample | Developer | ssample | — | — | Example row, replace it |

> ⚠️ Homonym warning (example): "Alex Example" (`aexample`) is a DIFFERENT person
> from "Alex Exemplar" (`aexemplar`). Do not confuse them in mentions.

## External

| Name | Role | Tracker username | Notes |
|------|------|------------------|-------|
| Pat Placeholder | Contact in another unit | TBD | Example row, replace it |

## Templates

### default

- Purpose: everyday mail or ticket comment.
- Greeting: `Dear {recipient},`
- Sign-off: `Best regards, {sender}`
- Tone: brief, neutral.

## How to find a tracker username

1. Open any ticket where the person is reporter or assignee.
2. Click their name to open the profile.
3. Copy the "Username" field and use it for mentions.

## Mention syntax

The format is set by `mention_format` in `.workflow-config.json` (for example
`@{username}`). Always confirm the recipient before sending: the intended
recipient may differ from the reporter or assignee of the ticket.
