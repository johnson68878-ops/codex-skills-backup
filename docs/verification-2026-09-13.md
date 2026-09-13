# Backup and runtime verification — 2026-09-13

Scope: 46 personal Skill roots and 524 included files. Plugin files and account credentials are outside the portable backup; 56 plugin-provided Skills are inventoried separately.

## Backup integrity

- Backup-module tests: 27 assertions passed.
- Source verification against the generated manifest: 46 passed.
- Skill credential-pattern scan: zero findings. This is a heuristic scan, not a general security audit of every dependency.
- The staged Git tree was archived as ZIP and extracted into a new temporary directory.
- The extracted installer restored all 46 Skills into an empty temporary Codex home.
- The extracted verifier accepted all 46 restored Skills by SHA-256 digest.
- Archived Skill file count: 524, equal to the manifest and staged tracked file count.
- The analysis document links every one of the 46 Skill roots.

Module coverage includes two-source backup, restoration into one Skill directory, stable manifest generation, preservation of an overwritten Skill, WhatIf, rejection of modified installed content, duplicate-name rejection before snapshot changes, and credential-like fixture detection with reviewed non-secret exceptions.

## Local runtime readiness

- Health-audit tests: 7 assertions passed.
- Installed Skill audit: 46/46 discovered, zero broken local Markdown references, zero missing known command dependencies.
- Installed core runtimes include Node.js 24.19.0, npm/npx 11.17.0, Python, uv, Graphviz, ImageMagick, FFmpeg/FFprobe 9.0.1, Browser Use, Browser Harness, Firecrawl, Defuddle, HyperFrames, Agent Reach, mcporter, yt-dlp, editppt and Obsidian CLI.
- Browser Use opened `https://example.com` through an isolated headless Chrome CDP session and returned page information.
- Defuddle parsed `https://example.com` to Markdown.
- Agent Reach called Exa through mcporter and returned an official Obsidian CLI result.
- Obsidian 1.13.7 was installed, its CLI was registered, and both `obsidian version` and `obsidian help` completed successfully.
- editppt setup and doctor passed. codex-ppt runtime bootstrap and doctor passed.
- GitHub CLI authentication for `johnson68878-ops` passed.
- The official Figma plugin 2.0.21 is installed and enabled; its 12 provided Skills are included in the plugin inventory.

Run the repeatable checks in PowerShell 7.2 or newer:

```powershell
.\tests\SkillsBackup.Tests.ps1
.\tests\SkillsHealth.Tests.ps1
.\scripts\verify.ps1 -AdditionalSkillsRoot "$env:USERPROFILE\.agents\skills"
.\scripts\Test-SkillsHealth.ps1 -SkillRoots "$env:USERPROFILE\.codex\skills","$env:USERPROFILE\.agents\skills" -ExpectedCount 46 -UseKnownRuntimeRequirements
```

On a restored computer containing every Skill in `.codex\skills`, omit `-AdditionalSkillsRoot` and audit that single root.

## External activation still required

The 46/46 result proves local Skill structure and known command availability. It does not grant service accounts, API entitlements, browser cookies, access to company instruments, or access to private documents.

- Firecrawl and Superdesign commands run but require their respective account login for live service calls.
- Speech and Transcribe scripts run, but live generation/transcription requires `OPENAI_API_KEY` to be configured locally.
- Figma requires a new Codex task or app restart to load the newly installed plugin tools, followed by Figma account/document authorization.
- Attaching Browser Use to the everyday Chrome profile requires the user to enable Chrome remote debugging. The isolated smoke-test path is already operational.
- Agent Reach public Exa search works. Twitter, LinkedIn, Xiaohongshu and other login-bound sources require their cookies, account connection, MCP or OpenCLI browser extension as applicable.
- A direct public YouTube smoke test was blocked by YouTube's sign-in/anti-bot challenge; the local yt-dlp runtime and Agent Reach channel check are installed and healthy.
- HyperFrames core browser and FFmpeg dependencies pass; Docker, whisper-cpp, Kokoro TTS and MusicGen remain optional feature dependencies.

These boundaries are external authentication or service behavior, so they cannot be completed or preserved safely inside this credential-free Git backup.
