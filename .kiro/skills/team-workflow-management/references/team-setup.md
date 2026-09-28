# Team Setup

Read this reference to create a team context, join an existing one, or ask the
onboarding team question.

## Say it in plain words first

Many people have never used Git. Before any technical step, say in the user's
language, in a sentence or two:

> A team context is a shared folder that the whole team uses to keep the
> roadmap and the list of tasks. It is kept in sync with a tool called Git. I'll
> guide you step by step and tell you exactly what to type, if anything.

Explain a technical word the first time you use it: a *repository* is the shared
folder kept by Git; to *clone* is to download your own copy of it; to *push* is to
send your changes back to the shared copy. Give commands as text the user can
copy, and say what each one does. If Git is not installed, say so and ask the
user to install it or to ask a colleague; do not try to install it.

## The onboarding team question

Ask it once, after step 4 of `workflow-management`'s `references/onboarding.md`,
as one question with "not now" as an easy answer:

> Do you work with other people on this project and want a shared team context
> as well? You can add one later at any time.

- **No or not now:** continue with the personal context only. Do not ask again
  in this session.
- **Yes, create one:** ask for the project name, then follow "Create".
- **Yes, one already exists:** ask for its repository address or local folder,
  then follow "Join".

Never assume a hosting service. Ask where the shared repository lives. The team
repository must be private to the team: ask the user to confirm it is not public,
because it contains names and email addresses (see `references/coordination.md`).

## Naming

The team context folder is `ai_context_TEAM_<prj_name>`, where `<prj_name>` is
short, lowercase words joined by underscores. Propose it and let the user change
it.

## Create

Do these one at a time and ask before each write:

1. Confirm the project name, the local folder (beside the personal context, and
   outside the project's own code repository), and whether a shared repository
   already exists. If it does not, offer to prepare a local Git repository; do
   not create a remote or push anything unless the user asks and the
   environment already supports it.
2. Create the layout. Git does not keep empty folders, so put an empty file
   named `.gitkeep` in every folder that would otherwise be empty:

   ```text
   ai_context_TEAM_<prj_name>/
     .workflow-config.json
     .gitignore
     README.md
     RECAP.md
     coordination/COORDINATORS.md
     roadmap/.gitkeep
     tasks/todo/.gitkeep
     tasks/done/.gitkeep
     tasks/discarded/.gitkeep
   ```

3. Write `.workflow-config.json`. It has the role and English records, and
   **no `ai_context_root`**: that path would be different on every machine and
   would leak local folder names into the shared repository.

   ```json
   {
     "version": "1.2.0",
     "role": "team",
     "record_language": "English",
     "sprint": { "enabled": false, "duration_weeks": 2 },
     "compaction": { "enabled": false }
   }
   ```

4. Write `.gitignore` so common personal material is not committed by accident:

   ```gitignore
   sessions/
   LAST_SESSION.md
   focus/
   meetings/
   .team-sync
   ```

   This is only a safety net. The real protection is the rule in
   `references/sync.md`: only files on the allow-list are ever committed.

5. Write `coordination/COORDINATORS.md` (see `references/coordination.md`) with
   the creator as the first coordinator, mode `open`.
6. Write a short `README.md` that says what the folder is, that it is the shared
   team context, that personal notes never go here, and how to sync.
7. Add the folder to the workspace. Explain it simply: "the workspace is the set
   of folders Kiro has open; we add the team folder to it". In the editor this is
   usually *File > Add Folder to Workspace...* (check the exact wording in the
   user's Kiro). If the user has a saved workspace file, print the `folders`
   entry to add and do not edit the file yourself. Then ask them to reload.

The team context has no numbering file: shared tasks are identified by date and
name (see `references/team-tasks.md`).

## Join

1. Confirm the repository address or local folder with the user.
2. If a local copy does not exist, ask before cloning, and clone only what the
   user names. If the clone asks for a login, do not guess credentials: tell the
   user to ask the person who manages the repository.
3. Check it is a team context: `.workflow-config.json` says `"role": "team"`. If
   the file is missing or unreadable but the folder name starts with
   `ai_context_TEAM_` and it is a Git repository, treat it as a team context and
   tell the user what is wrong. Otherwise stop and ask. Do not require
   `ai_context_root`.
4. Read `coordination/COORDINATORS.md` if it exists and tell the user their role;
   if it is missing, say so and offer to create it (mode `open`) after asking.
5. Check that `.gitignore` still contains the lines above, and restore any that
   are missing after asking.
6. Add the folder to the workspace, as in Create step 7.

## Missing pieces

If `RECAP.md`, `.team-sync`, or one of the `tasks/` folders is missing, create it
after asking; never treat a missing file as an error that stops the user.

## Existing personal context

Adding a team context never changes the personal one. If the personal
`.workflow-config.json` is missing, set that up first with
`workflow-management`.
