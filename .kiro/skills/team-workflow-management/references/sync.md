# Synchronization

Read this reference before assigning or changing anything in the team context,
and when the user asks how up to date it is.

Git is the source of truth. The assistant uses it, it does not replace it. Explain
each step in plain words the first time (see `references/team-setup.md`).

## Never do

Without an explicit, specific request from the user, never run: `git push --force`
(or `--force-with-lease`), `git reset --hard`, `git clean`, `git checkout --`,
`git restore` on a shared file, `git stash drop`, `git rebase`, `git commit
--amend` on a pushed commit, or delete a branch. Never use `git add -A` or
`git add .` in the team context.

## Before assigning or changing anything shared

1. **Fetch.** Run `git fetch` in the team context. It changes nothing locally, so
   it needs no confirmation.
2. **Compare.** If the clone is behind, say so and offer to bring it up to date
   with a fast-forward only (`git pull --ff-only`). Do it without asking when the
   working tree is clean; ask when it has local changes. Never merge or rebase.
3. **Then act,** on the fresh state.

## Committing: only what belongs

Only these paths may be committed in the team context: `roadmap/`, `tasks/`,
`coordination/`, `RECAP.md`, `README.md`, `.gitignore`, and
`.workflow-config.json`.

Before every commit:

1. run `git status` and look at what changed;
2. add **only the files for this change**, by name (`git add <file>`);
3. if anything outside the allow-list is changed or untracked, do not commit it:
   tell the user, and leave it alone;
4. re-read what you are about to share: a task text may contain something
   personal or confidential that the user pasted. Ask them to check it if in
   doubt.

## After assigning or changing

An assignment counts only once it is pushed:

1. commit with a short message naming the task identifier;
2. **show the user the list of files and ask before pushing**, unless they already
   agreed to push this same kind of change in this session;
3. push;
4. if the push is refused, find out why before saying anything: someone changed
   the same task (fetch, re-read, and tell the user, for example "already taken by
   Marco"); or a permission, network, login, or protected-branch problem (report
   it as such and stop). Do not force anything.

## Showing how fresh it is

At the start of a session that involves the team context, show one line, for
example: "Team context: updated 12 minutes ago, 3 commits behind". Keep the time
of the last fetch in `.team-sync` inside the team context. That file is local and
listed in `.gitignore`; never commit it.

## When Git is not available

If Git cannot be run (not installed, blocked by the machine, no network, login
required), do not keep trying. Tell the user which command to run by hand and
wait, for example `git fetch`, then `git pull --ff-only`. For a login problem,
say to ask the person who manages the repository; never invent credentials. Do
not assign or change a shared task while the state of the clone is unknown.

## Conflicts

Because each task is its own file, conflicts are rare. Two people who create a
task with the same name on the same day meet a conflict only when they sync:
keep both, with the second renamed to a more precise name. For any other
conflict, show both versions in plain words and let the user or a coordinator
decide. Never resolve a conflict by discarding the other person's text.
