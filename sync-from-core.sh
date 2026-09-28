#!/usr/bin/env bash
# sync-from-core.sh — Copy the shared workflow-management files from the core
# repository into .kiro/skills/workflow-management/ and record which core
# commit they came from in CORE_VERSION.
#
# Only SKILL.md (the Kiro adapter) is specific to this repository and is never
# touched here.
#
# Usage:
#   ./sync-from-core.sh [CORE_DIR]           # copy core -> package
#   ./sync-from-core.sh --check [CORE_DIR]   # report drift, change nothing, exit 1 if any
#
# CORE_DIR defaults to ../workflow-management-skill (a clone of the core repo).

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
TARGET="$ROOT/.kiro/skills/workflow-management"

CHECK_ONLY=false
if [[ "${1:-}" == "--check" ]]; then
    CHECK_ONLY=true
    shift
fi
CORE_ARG="${1:-$ROOT/../workflow-management-skill}"
if [[ ! -d "$CORE_ARG" ]]; then
    echo "ERROR: core directory not found: $CORE_ARG" >&2
    echo "       Pass the path of a clone of workflow-management-skill." >&2
    exit 1
fi
CORE="$(cd "$CORE_ARG" && pwd)"

# Keep this list in step with SHARED_FILES in the core sync-codex-package.sh.
SHARED_FILES=(
    CORE.md
    conventions.md
    setup-skills.sh
    setup-skills.ps1
    compact-sessions.sh
    references/sessions.md
    references/tasks.md
    references/planning-and-notes.md
    references/steering.md
    references/tracking.md
    references/bootstrap.md
    references/recap-maintenance.md
    references/setup-guided.md
    references/onboarding.md
    references/compaction.md
    examples/basic-ai-context/README.md
    examples/basic-ai-context/RECAP.md
    examples/basic-ai-context/tasks/INDEX.md
)

# Files that exist only in this Kiro package: never copied from the core, never
# reported as stale. Keep this list short and document each one in the README.
KIRO_ONLY_FILES=(
    init-session.ps1
)

if [[ ! -f "$CORE/CORE.md" ]] || ! git -C "$CORE" rev-parse HEAD >/dev/null 2>&1; then
    echo "ERROR: not a workflow-management core checkout: $CORE" >&2
    exit 1
fi

# Verify every source first, so a failure never leaves a half-copied package.
for file in "${SHARED_FILES[@]}"; do
    [[ -f "$CORE/$file" ]] || { echo "ERROR: missing in core: $file" >&2; exit 1; }
done

CORE_COMMIT="$(git -C "$CORE" rev-parse HEAD)"
drift=0

# CORE_VERSION names a commit, so the core files must match that commit.
if [[ -n "$(git -C "$CORE" status --porcelain -- "${SHARED_FILES[@]}")" ]]; then
    echo "WARNING: the core has uncommitted changes in shared files;" >&2
    echo "         CORE_VERSION would not describe what is copied." >&2
    $CHECK_ONLY || exit 1
    drift=1
fi

for file in "${SHARED_FILES[@]}"; do
    src="$CORE/$file"
    dst="$TARGET/$file"
    if [[ ! -f "$dst" ]] || ! cmp -s <(tr -d '\r' < "$src") <(tr -d '\r' < "$dst"); then
        drift=1
        if $CHECK_ONLY; then
            echo "DRIFT: $file"
        else
            mkdir -p "$(dirname "$dst")"
            cp "$src" "$dst"
            echo "updated: $file"
        fi
    fi
done

# Files that are in the package but no longer in the shared list (removed or
# renamed in the core) would silently go stale.
while IFS= read -r extra; do
    rel="${extra#"$TARGET"/}"
    [[ "$rel" == "SKILL.md" ]] && continue
    listed=false
    for file in "${KIRO_ONLY_FILES[@]}"; do [[ "$file" == "$rel" ]] && listed=true; done
    for file in "${SHARED_FILES[@]}"; do [[ "$file" == "$rel" ]] && listed=true; done
    if ! $listed; then
        drift=1
        echo "EXTRA (not in the shared list): $rel"
    fi
done < <(find "$TARGET" -type f)

recorded="$(tr -d '\r\n' < "$ROOT/CORE_VERSION" 2>/dev/null || true)"
if [[ "$recorded" != "$CORE_COMMIT" ]]; then
    drift=1
    if $CHECK_ONLY; then
        echo "DRIFT: CORE_VERSION ($recorded, core is $CORE_COMMIT)"
    else
        printf '%s\n' "$CORE_COMMIT" > "$ROOT/CORE_VERSION"
        echo "CORE_VERSION -> $CORE_COMMIT"
    fi
fi

if $CHECK_ONLY; then
    if [[ $drift -eq 0 ]]; then
        echo "Kiro package is in sync with core $CORE_COMMIT."
    else
        exit 1
    fi
fi
