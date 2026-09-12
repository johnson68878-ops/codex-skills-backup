# Codex Skills GitHub Backup Design

## Goal

Create a private GitHub repository that can reproduce this computer's personal Codex Skills on another Windows computer with one PowerShell command, without uploading credentials, account data, caches, or machine-specific state.

## Scope

The repository will vendor every directory directly under `%USERPROFILE%\.codex\skills` that contains a `SKILL.md`, excluding `.system`. This currently represents 34 personal or manually installed Skills.

Codex-bundled and plugin-provided Skills under `%USERPROFILE%\.codex\plugins\cache` will be recorded in an inventory rather than copied. Copying plugin cache files would not recreate their MCP servers, app connections, permissions, or account authentication. The README will identify those capabilities as separate plugin reconnection steps.

## Repository Layout

```text
codex-skills-backup/
  skills/                 Vendored personal Skill directories
  manifests/
    personal-skills.json  Name, relative path, file count, size, hash
    plugin-skills.json    Installed plugin-provided Skill inventory
  scripts/
    install.ps1           Restore personal Skills on Windows
    verify.ps1            Compare installed Skills with the manifest
    update-backup.ps1     Refresh the repository from the current PC
  README.md               Setup and recovery instructions
  .gitignore              Excludes secrets, caches, and temporary data
```

## Backup Flow

`update-backup.ps1` enumerates direct child Skill directories, validates that each contains `SKILL.md`, scans candidate text files for likely credentials, copies approved directories into `skills/`, and regenerates deterministic manifests. It never reads or copies Codex authentication files, configuration credentials, plugin caches, conversation data, or browser profiles.

The initial backup will use the same inclusion and exclusion logic directly, then run the generated verification script before committing.

## Restore Flow

On the company computer, the user clones or downloads the private repository and runs `scripts\install.ps1`. The script creates `%USERPROFILE%\.codex\skills`, installs each vendored Skill, and preserves any conflicting destination directory by renaming it with a timestamp before replacement. It does not modify `.system` or plugin caches.

After restoration, `scripts\verify.ps1` checks Skill names and content hashes. The user then restarts Codex App and reconnects required plugins such as GitHub or Google Drive through the app.

## Security

- GitHub repository visibility is private.
- Secret-like filenames and content patterns are scanned before commit.
- `.gitignore` excludes environment files, keys, credentials, browser data, caches, logs, and generated planning files.
- Only Skill directories are copied; `%USERPROFILE%\.codex` is never mirrored wholesale.
- The final staged Git diff is reviewed for suspicious paths before push.

## GitHub Publication

The preferred repository name is `codex-skills-backup`. The connected GitHub app will be used when it supports repository creation and file upload. If repository creation is unavailable through the connector, GitHub's authenticated web interface will be used. The repository URL will be returned after the default `main` branch is populated.

## Verification Criteria

The backup is complete when:

1. Every current personal Skill with a `SKILL.md` appears under `skills/`.
2. No `.system`, plugin cache, credentials, tokens, or account data are staged.
3. `verify.ps1` passes against the repository snapshot.
4. The private GitHub repository exists and its `main` branch contains the committed snapshot.
5. README instructions provide a copy-paste restore command for the company computer.
