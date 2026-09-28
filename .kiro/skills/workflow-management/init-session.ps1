[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ContextRoot,

    [Parameter(Mandatory = $true)]
    [string]$WorkspacePath,

    [ValidateNotNullOrEmpty()]
    [string]$RecordLanguage = 'English',

    # Do not write the user-local pointer.
    # Use this when the context is attached through a .code-workspace root.
    [switch]$Here,

    # Overwrite an existing .workflow-config.json.
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Why this script exists
# ---------------------------------------------------------------------------
#
# Kiro's fs_write tool crashes with ENOENT on Windows whenever the target is
# an absolute path: its session-snapshot mechanism appends the absolute path
# onto the snapshot base directory instead of resolving it, which also drops
# the path separator between the home directory and the next segment (e.g.
# "C:\Users\<name>.kiro" instead of "C:\Users\<name>\.kiro"). The target file is
# still written correctly, but the tool call reports an error that interrupts
# the agent's flow on every write. See kirodotdev/Kiro#11636.
#
# This script performs the whole first-time context setup (folders, config,
# user-local pointer, initial operational records) through .NET file APIs
# invoked via execute_pwsh, bypassing fs_write entirely for this step.

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

function Write-Utf8NoBom {
    param(
        [Parameter(Mandatory = $true)] [string]$LiteralPath,
        [Parameter(Mandatory = $true)] [string]$Content
    )
    $enc = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($LiteralPath, $Content, $enc)
}

function Ensure-Dir {
    param([Parameter(Mandatory = $true)] [string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Output "  [+] $Path"
    } else {
        Write-Output "  [=] $Path (already present)"
    }
}

# ---------------------------------------------------------------------------
# Path resolution - never concatenate strings by hand
# ---------------------------------------------------------------------------

$resolvedRoot      = [System.IO.Path]::GetFullPath($ContextRoot)
$resolvedWorkspace = [System.IO.Path]::GetFullPath($WorkspacePath)

$userProfile = [Environment]::GetFolderPath('UserProfile')
if ([string]::IsNullOrWhiteSpace($userProfile)) {
    throw "Could not determine the user profile directory (UserProfile is empty)."
}

$platformConfigRoot = if (-not [string]::IsNullOrWhiteSpace($env:XDG_CONFIG_HOME)) {
    [System.IO.Path]::GetFullPath($env:XDG_CONFIG_HOME)
} else {
    Join-Path $userProfile '.config'
}

$pointerDirectory = Join-Path $platformConfigRoot 'skill-workflow-management'
$pointerFile      = Join-Path $pointerDirectory   'context-path.json'
$configFile       = Join-Path $resolvedRoot        '.workflow-config.json'

# ---------------------------------------------------------------------------
# Guards
# ---------------------------------------------------------------------------

if ((Test-Path -LiteralPath $configFile -PathType Leaf) -and -not $Force) {
    throw "Configuration already exists: $configFile. Use -Force to overwrite."
}

# ---------------------------------------------------------------------------
# Step 1 - Folder structure
# ---------------------------------------------------------------------------

Write-Output ''
Write-Output '=== Step 1: Folder structure ==='

$dirs = @(
    $resolvedRoot,
    (Join-Path $resolvedRoot 'sessions'),
    (Join-Path (Join-Path $resolvedRoot 'sessions') 'archive'),
    (Join-Path $resolvedRoot 'tasks'),
    (Join-Path (Join-Path $resolvedRoot 'tasks') 'todo'),
    (Join-Path (Join-Path $resolvedRoot 'tasks') 'done'),
    (Join-Path $resolvedRoot 'sprints'),
    (Join-Path $resolvedRoot 'focus'),
    (Join-Path $resolvedRoot 'meetings'),
    (Join-Path $resolvedRoot 'roadmap')
)
foreach ($d in $dirs) { Ensure-Dir $d }

if (-not $Here) { Ensure-Dir $pointerDirectory }

# ---------------------------------------------------------------------------
# Step 2 - .workflow-config.json
# ---------------------------------------------------------------------------

Write-Output ''
Write-Output '=== Step 2: .workflow-config.json ==='

$config = [ordered]@{
    version         = '1.2.0'
    ai_context_root = $resolvedRoot
    sprint          = [ordered]@{ enabled = $false; duration_weeks = 2 }
    compaction      = [ordered]@{ enabled = $true; retention_days = 30; group_by = 'month' }
    record_language = $RecordLanguage
}

$configJson = ($config | ConvertTo-Json -Depth 4) + [Environment]::NewLine
Write-Utf8NoBom -LiteralPath $configFile -Content $configJson
Write-Output "  [+] $configFile"

# ---------------------------------------------------------------------------
# Step 3 - User-local pointer (only when not -Here)
# ---------------------------------------------------------------------------

Write-Output ''
Write-Output '=== Step 3: User-local pointer ==='

if ($Here) {
    Write-Output '  [i] Skipped (-Here: attached through .code-workspace).'
} else {
    # Load existing entries, if any.
    $contexts = [ordered]@{}
    $defaultRoot = $resolvedRoot

    if (Test-Path -LiteralPath $pointerFile -PathType Leaf) {
        $existingRaw = Get-Content -Raw -LiteralPath $pointerFile | ConvertFrom-Json
        $propNames   = $existingRaw.PSObject.Properties.Name

        if ($propNames -contains 'contexts') {
            foreach ($k in $existingRaw.contexts.PSObject.Properties.Name) {
                $contexts[$k] = $existingRaw.contexts.$k
            }
        } elseif ($propNames -contains 'ai_context_root') {
            Write-Output '  [i] Legacy pointer found, converted to map form.'
        }

        if ($propNames -contains 'default') {
            $defaultRoot = [string]$existingRaw.default
        } elseif ($propNames -contains 'ai_context_root') {
            $defaultRoot = [string]$existingRaw.ai_context_root
        }
    }

    # Add or update the entry for this workspace.
    $contexts[$resolvedWorkspace] = $resolvedRoot

    $pointer = [ordered]@{
        contexts = $contexts
        default  = $defaultRoot
    }

    $pointerJson = ($pointer | ConvertTo-Json -Depth 4) + [Environment]::NewLine
    Write-Utf8NoBom -LiteralPath $pointerFile -Content $pointerJson
    Write-Output "  [+] $pointerFile"
}

# ---------------------------------------------------------------------------
# Step 4 - Initial operational records
# ---------------------------------------------------------------------------

Write-Output ''
Write-Output '=== Step 4: Operational records ==='

# RECAP.md
$recapFile = Join-Path $resolvedRoot 'RECAP.md'
if (-not (Test-Path -LiteralPath $recapFile -PathType Leaf)) {
    $recap = @"
# Recap - Open items

## General

| Ticket | Description | Status | Notes |
|--------|-------------|--------|-------|
"@
    Write-Utf8NoBom -LiteralPath $recapFile -Content ($recap + [Environment]::NewLine)
    Write-Output '  [+] RECAP.md'
} else {
    Write-Output '  [=] RECAP.md (already present)'
}

# tasks/INDEX.md
$indexFile = Join-Path (Join-Path $resolvedRoot 'tasks') 'INDEX.md'
if (-not (Test-Path -LiteralPath $indexFile -PathType Leaf)) {
    $index = @"
# Task Index

Next available number: 1
"@
    Write-Utf8NoBom -LiteralPath $indexFile -Content ($index + [Environment]::NewLine)
    Write-Output '  [+] tasks/INDEX.md'
} else {
    Write-Output '  [=] tasks/INDEX.md (already present)'
}

# Today's session
$today       = Get-Date -Format 'yyyy-MM-dd'
$sessionFile = Join-Path (Join-Path $resolvedRoot 'sessions') "SESSION_$today.md"
if (-not (Test-Path -LiteralPath $sessionFile -PathType Leaf)) {
    $session = @"
# Session $today

- **Focus**: to be defined with the user.

## Work done

<!-- workflow:work-done -->
- Context initialized with init-session.ps1.

## Decisions

-

## Blockers

-

## Next steps

-

## Timesheet

| Time | Activity |
|------|----------|
"@
    Write-Utf8NoBom -LiteralPath $sessionFile -Content ($session + [Environment]::NewLine)
    Write-Output "  [+] sessions/SESSION_$today.md"
} else {
    Write-Output "  [=] sessions/SESSION_$today.md (already present)"
}

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

Write-Output ''
Write-Output '============================================'
Write-Output '  Initialization complete.'
Write-Output ''
Write-Output "  Context  : $resolvedRoot"
Write-Output "  Workspace: $resolvedWorkspace"
Write-Output "  Language : $RecordLanguage"
Write-Output ''
Write-Output '  Folders:'
Write-Output '    sessions/  -- one note per working day'
Write-Output '    tasks/     -- open and closed tasks'
Write-Output '    sprints/   -- period plans (optional)'
Write-Output '    focus/     -- exploratory notes (optional)'
Write-Output '    meetings/  -- meeting outcomes (optional)'
Write-Output '    roadmap/   -- goals and decisions (optional)'
Write-Output ''
Write-Output '  Only sessions/ and tasks/ are used from day one.'
Write-Output '  Feel free to ask what any other folder is for.'
Write-Output '============================================'
