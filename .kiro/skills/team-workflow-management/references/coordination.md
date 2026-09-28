# Coordination

Read this reference for who may change the shared roadmap, accept or close tasks,
confirm duplicates, or write the shared RECAP, and for handing over the role.

## Coordinators

`coordination/COORDINATORS.md` lists the coordinators, one per line: a display
name and an email, plus the mode. There is no limit on how many there are. The
repository is private to the team; say so when adding an email.

```markdown
# Coordinators

Mode: open

- <Name> <email>
```

## Modes

- **`open`** — everyone is a coordinator. This suits a small team that
  coordinates itself, and is the default. The file may then list only the
  people who choose to be named.
- **`named`** — only the people listed have the coordinator powers below.
  Everyone else can propose tasks and assign themselves to unassigned ones.

Move from `open` to `named` when the team grows or when changes to the roadmap
start colliding. Changing the mode, or adding or removing a coordinator, is done
by a coordinator and needs the user's confirmation.

## What only coordinators do (in `named` mode)

- change the shared roadmap;
- confirm a duplicate, or discard a task as `not-useful`, `not-reproducible`, or
  `solved-elsewhere`;
- move a task from `proposed` to `accepted`;
- write the shared RECAP.

Anyone may close their own assigned task as `done`. A coordinator may close any.

## Rules

1. In `named` mode there is always at least one coordinator; the last one cannot
   leave without naming another. In `open` mode everyone is one, so the rule
   does not apply.
2. To know who the current person is, read the Git email in effect for the team
   repository (`git config user.email` run inside it, which includes global
   settings). Compare emails ignoring case, never names. If there is no email, or
   it is not in the list in `named` mode, treat the person as a non-coordinator
   and say why.
3. A non-coordinator who asks for a coordinator action is offered a proposal
   instead (a task or a note to the coordinators).
4. This is a convention that the assistant follows, not security. A Git name or
   email is only a declaration, and a commit does not prove who wrote it. The list
   is an agreement of the team. Real permissions are the repository's; a team that
   needs enforcement sets it there.

## Handing over

When a coordinator leaves the role or is away for long, write a short handover
in `coordination/handover-<date>.md`: open risks and decisions, what is
postponed and why, and where the roadmap stands. The incoming coordinator adds a
line saying they have read it.
