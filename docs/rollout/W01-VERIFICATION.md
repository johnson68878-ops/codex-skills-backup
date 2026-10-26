# W01 verification — 2026-10-26

Scope: repository snapshot integrity and backup tooling. This is not an all-Skill runtime certification.

| Check | Result |
|---|---|
| Snapshot hashes using `scripts/verify.ps1 -RepositoryRoot . -CodexHome .` | 87 / 87 passed |
| `tests/SkillsBackup.Tests.ps1` | 28 assertions passed |
| `tests/SkillsHealth.Tests.ps1` | 7 assertions passed; tests exercise fixtures, not every installed runtime |
| New `embedded-systems` package | SKILL.md, five reference files and MIT LICENSE present |
| New skill credential-pattern scan | No findings from repository scanner |
| MCU SDK / compilation / hardware measurements | Not performed; deliberately outside this release |

The original checkout omitted `skills/huggingface-community-evals/examples/.env.example` even though its bytes were included in the existing manifest. The local retained copy contains only comments and a placeholder Hugging Face token. This release restores that file and adds an exact ignore-rule exception. The original manifest hash is unchanged and now verifies in a clean checkout.

Known-command health tests validate the audit implementation with fixtures. They do not establish that the current workstation has all 87 external toolchains, credentials or services.
