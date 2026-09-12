# Codex Skills Backup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and publish a private, security-scanned GitHub snapshot that restores all 34 personal Codex Skills on another Windows PC.

**Architecture:** A PowerShell module owns deterministic discovery, hashing, copying, security scanning, installation, and verification. Thin command scripts call that module. Personal Skill files are vendored; bundled/plugin Skills are inventoried because copying their cache cannot restore connector permissions or MCP services.

**Tech Stack:** PowerShell 7, Git, JSON manifests, SHA-256, GitHub web UI, Codex GitHub connector

**Spec:** `docs/superpowers/specs/2026-09-12-codex-skills-backup-design.md`

## Global Constraints

- The GitHub repository must be private and named `codex-skills-backup`.
- Include each direct child of `%USERPROFILE%\.codex\skills` containing `SKILL.md`; exclude `.system`.
- Never copy authentication files, Codex conversations, configuration credentials, plugin caches, browser profiles, or account data.
- Preserve conflicting destination Skills in a timestamped backup before replacement.
- All generated paths must be validated as descendants of their declared roots.

---

### Task 1: Backup and manifest engine

**Status:** complete

**Files:**
- Create: `scripts/SkillsBackup.psm1`
- Create: `tests/SkillsBackup.Tests.ps1`

**Interfaces:**
- Produces: `Get-SkillDirectories -Root <string> -Exclude <string[]> -> DirectoryInfo[]`
- Produces: `Get-DirectoryDigest -Path <string> -> string`
- Produces: `Test-SkillSecurity -Path <string> -> PSCustomObject[]`
- Produces: `Export-SkillsSnapshot -SourceRoot <string> -DestinationRoot <string> -> PSCustomObject[]`

- [x] **Step 1: Write failing tests**

Create fixtures for a valid Skill, `.system`, a missing `SKILL.md`, an `.env` file, and a private-key marker. Assert discovery includes only the valid Skill, security rejects both secret fixtures, and hashing is stable after files are copied.

- [x] **Step 2: Run tests and verify failure**

Run: `pwsh -NoProfile -File tests/SkillsBackup.Tests.ps1`
Expected: non-zero exit because `scripts/SkillsBackup.psm1` and exported functions do not exist.

- [x] **Step 3: Implement the module**

Use `Get-ChildItem -Directory`, `Resolve-Path`, and a descendant-path guard. Hash sorted relative paths plus each file SHA-256. Reject `.env*`, `*.pem`, `*.key`, `id_rsa*`, credential/secret filenames, private-key blocks, and concrete token prefixes. Ignore documented placeholders containing `example`, `your-`, `xxx`, `<...>`, or `placeholder`.

`Export-SkillsSnapshot` copies only files from approved Skill directories, skips `.git`, `__pycache__`, logs, and OS metadata, then emits objects with `name`, `source`, `fileCount`, `sizeBytes`, and `sha256`.

- [x] **Step 4: Run tests and verify pass**

Run: `pwsh -NoProfile -File tests/SkillsBackup.Tests.ps1`
Expected: `PASS: SkillsBackup module tests` and exit 0.

- [x] **Step 5: Commit**

Run: `git add scripts/SkillsBackup.psm1 tests/SkillsBackup.Tests.ps1 && git commit -m "feat: add secure skills snapshot engine"`

### Task 2: Backup, restore, and verification commands

**Status:** complete

**Files:**
- Create: `scripts/update-backup.ps1`
- Create: `scripts/install.ps1`
- Create: `scripts/verify.ps1`
- Modify: `tests/SkillsBackup.Tests.ps1`

**Interfaces:**
- `update-backup.ps1 -CodexHome <string> -RepositoryRoot <string>` regenerates `skills/` and both manifests.
- `install.ps1 -CodexHome <string> [-WhatIf]` restores `skills/` and backs up conflicts under `<CodexHome>/skills-backup/<timestamp>/`.
- `verify.ps1 -CodexHome <string>` exits 0 only when every manifest Skill exists and matches its digest.

- [x] **Step 1: Extend tests first**

Use temporary source, repository, and destination roots. Assert update writes deterministic JSON, install restores the fixture, a differing destination is moved to the backup root, `-WhatIf` makes no change, and verify detects both success and a modified file.

- [x] **Step 2: Run tests and verify failure**

Run: `pwsh -NoProfile -File tests/SkillsBackup.Tests.ps1`
Expected: non-zero exit because the command scripts are missing.

- [x] **Step 3: Implement command scripts**

Each script imports `SkillsBackup.psm1`, uses explicit parameters with defaults derived from `$env:USERPROFILE`, stops on errors, validates resolved paths, and emits concise status. `update-backup.ps1` inventories plugin-cache `SKILL.md` paths without copying their contents.

- [x] **Step 4: Run tests and verify pass**

Run: `pwsh -NoProfile -File tests/SkillsBackup.Tests.ps1`
Expected: all backup, install, conflict, WhatIf, and verification assertions pass.

- [x] **Step 5: Commit**

Run: `git add scripts tests && git commit -m "feat: add backup restore and verification commands"`

### Task 3: Create and audit the real snapshot

**Status:** complete

**Files:**
- Create: `skills/**`
- Create: `manifests/personal-skills.json`
- Create: `manifests/plugin-skills.json`
- Create: `.gitignore`
- Create: `README.md`

**Interfaces:**
- Consumes: Task 2 scripts.
- Produces: a self-contained snapshot and copy-paste company-PC restore instructions.

- [x] **Step 1: Run the backup command**

Run: `pwsh -NoProfile -File scripts/update-backup.ps1 -CodexHome "$env:USERPROFILE\.codex" -RepositoryRoot (Get-Location)`
Expected: 34 personal Skills copied and plugin inventory generated.

- [x] **Step 2: Write README and exclusions**

README must include clone/download instructions, `Set-ExecutionPolicy -Scope Process Bypass`, `scripts\install.ps1`, `scripts\verify.ps1`, Codex restart, and plugin reconnection notes. `.gitignore` excludes `.env*`, keys, credentials, caches, logs, planning ledgers, and temporary output.

- [x] **Step 3: Audit staged content**

Run the module's security scan across `skills/`, inspect `git status --short`, run `git diff --check`, and search tracked content for token/private-key patterns. Expected: no security findings and no excluded paths.

- [x] **Step 4: Verify snapshot**

Run: `pwsh -NoProfile -File scripts/verify.ps1 -CodexHome "$env:USERPROFILE\.codex"`
Expected: all 34 personal Skills match.

- [x] **Step 5: Commit**

Run: `git add .gitignore README.md skills manifests && git commit -m "backup: snapshot installed Codex skills"`

### Task 4: Publish and independently verify private GitHub repository

**Files:**
- Modify: local Git remote configuration only

**Interfaces:**
- Consumes: clean, verified `main` branch from Task 3.
- Produces: private repository `johnson68878-ops/codex-skills-backup` with matching HEAD.

- [ ] **Step 1: Create the private repository**

Use the authenticated GitHub web interface to create `codex-skills-backup` under `johnson68878-ops`, visibility Private, without initializing README, license, or `.gitignore`.

- [ ] **Step 2: Push main**

Add `https://github.com/johnson68878-ops/codex-skills-backup.git` as `origin` and push `main`. If shell authentication is unavailable, upload the committed tree through the connected GitHub contents APIs without exposing credentials.

- [ ] **Step 3: Verify publication**

Use the GitHub connector to fetch repository metadata and `README.md`; confirm visibility is private and remote content corresponds to local HEAD.

- [ ] **Step 4: Report restore command**

Return the private repository link and the exact company-PC clone/install/verify commands. Mention that plugin account connections still require authorization on the company PC.

## Execution Errors

| Error | Attempt | Resolution |
| --- | --- | --- |
| Mistyped `git worktree add` as an invalid Git subcommand | 1 | Re-ran the validated `git worktree add` command; isolated branch created successfully. |
| Real snapshot security scan blocked three upstream Skills | 1 | Root cause investigation found broad assignment-regex false positives: design tokens, runtime variables, environment references, and a public Algolia search key. Added regression coverage before changing the scanner. |
| First redacted diagnostic pipeline had an empty PowerShell pipe element | 1 | Captured loop output into an array before piping to formatting/JSON. |
