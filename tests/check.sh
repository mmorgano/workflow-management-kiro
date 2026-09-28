#!/usr/bin/env bash
# check.sh — Consistency checks for the Kiro package. No network needed.
#   1. shared files match the core (sync-from-core.sh --check)
#   2. every SKILL.md has valid frontmatter, and its name matches its folder
#   3. no references to specific products, employers, clients, projects, or
#      personal machine paths and user names
#   4. every reference file mentioned by a SKILL.md exists
#
# Usage: tests/check.sh [CORE_DIR]

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

"$ROOT/sync-from-core.sh" --check ${1:+"$1"}

for skill in .kiro/skills/*/SKILL.md; do
    dir="$(dirname "$skill")"
    text="$(tr -d '\r' < "$skill")"
    [[ "$(printf '%s\n' "$text" | head -1)" == "---" ]] \
        || { echo "ERROR: $skill: frontmatter must start with ---" >&2; exit 1; }
    name="$(printf '%s\n' "$text" | sed -n 's/^name: *//p' | head -1)"
    [[ "$name" == "$(basename "$dir")" ]] \
        || { echo "ERROR: $skill: name '$name' does not match folder '$(basename "$dir")'" >&2; exit 1; }
    [[ "$name" =~ ^[a-z0-9-]{1,64}$ ]] \
        || { echo "ERROR: $skill: name must be lowercase letters, digits, hyphens, max 64" >&2; exit 1; }
    desc="$(printf '%s\n' "$text" | sed -n 's/^description: *//p' | head -1)"
    (( ${#desc} >= 80 && ${#desc} <= 1024 )) \
        || { echo "ERROR: $skill: description must be 80-1024 characters (is ${#desc})" >&2; exit 1; }
done

# The package must stay generic: no specific employer, client, project, or
# hosting-product names. This is a safety net, not a review: read the package
# before making it public. Extend the pattern when a new leak class is found.
FORBIDDEN='eurostat|\bfame\b|sogeti|statelier|gitlab|jira|4gl|riper7401|bitbucket|\bdell\b|c:\users\[a-z]'
if git ls-files -z --cached --others --exclude-standard \
    | grep -zvE '(^|/)(LICENSE|check\.sh)$' \
    | xargs -0 grep -nIiE "$FORBIDDEN"; then
    echo "ERROR: forbidden reference found (see above)" >&2
    exit 1
fi

for skill in .kiro/skills/*/SKILL.md; do
    dir="$(dirname "$skill")"
    # Join wrapped lines so a path split across two lines is still found.
    refs="$(tr -d '\r' < "$skill" | tr '\n' ' ' | sed 's/ \+/ /g' \
        | grep -oE '(\.\./[a-z-]+/)?references/[A-Za-z0-9._-]+\.md' | sort -u || true)"
    for ref in $refs; do
        [[ -f "$dir/$ref" ]] || { echo "ERROR: $skill mentions missing $ref" >&2; exit 1; }
    done
done

echo "Kiro package checks passed."
