# Backup verification — 2026-09-13

Scope: 46 personal Skill roots, 523 included files. Plugin files and account authorization are outside this backup.

- Existing and new backup-module tests: 27 assertions passed.
- Source verification against the generated manifest: 46 passed.
- Skill credential-pattern scan: zero findings. This is a heuristic scan, not a general security audit of every dependency.
- Staged Git tree archived as ZIP and extracted into a new temporary directory.
- Extracted installer run against an empty temporary Codex home.
- Extracted verifier: 46 restored Skills passed SHA-256 verification.
- Archived Skill file count: 523, equal to the manifest and staged tracked file count.
- Analysis document contains links for every one of the 46 Skill roots.
- Staged whitespace checks passed; vendored Skill whitespace is preserved intentionally.

Module coverage includes two-source backup, restoration into one Skill directory, unchanged manifest generation, preserving an overwritten Skill, WhatIf, rejecting modified installed content, rejecting duplicate names before changing the snapshot, and detecting credential-like fixtures while allowing two reviewed non-secret source expressions.

Run locally in PowerShell 7.2 or newer:

```powershell
.\tests\SkillsBackup.Tests.ps1
.\scripts\verify.ps1 -AdditionalSkillsRoot "$env:USERPROFILE\.agents\skills"
```

On a restored computer containing every Skill in `.codex\skills`, omit `-AdditionalSkillsRoot`.

External CLIs, hardware, model services, API keys and plugin account connections were not provisioned or exhaustively tested. These checks prove snapshot completeness and restoration, not that every external integration is operational.
