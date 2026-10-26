# Codex Skills — Wearable Systems Architecture

[![Skills](https://img.shields.io/badge/Vendored%20Skills-87-00bcd4)](manifests/personal-skills.json)
[![Rollout](https://img.shields.io/badge/AI%20Skills%20Rollout-Week%201%20of%206-2563eb)](docs/rollout/SIX-WEEK-PLAN.zh-TW.md)

A curated, reproducible collection of AI workflows for wearable-system architecture: hardware, firmware, quality, software delivery, data analysis and technical communication. Third-party Skills retain their upstream authorship and license terms.

## 本週進度｜2026-10-26

**第 1 週：嵌入式架構與低功耗工作流整合。** 新增 `embedded-systems`；倉庫由 86 增至 **87 個個人 Skills**。已建立架構 review 檢核表、本機差異基準與六週導入計畫。MCU SDK 與實機驗證尚未執行。

- [本週更新與可分享說明](docs/rollout/W01-2026-10-26.zh-TW.md)
- [目前功能分布與完整名稱清單](docs/rollout/CAPABILITIES.zh-TW.md)
- [六週分批導入計畫](docs/rollout/SIX-WEEK-PLAN.zh-TW.md)
- [本機與 GitHub 基準比對](docs/rollout/BASELINE-COMPARISON.zh-TW.md)
- [本週檔案驗證紀錄](docs/rollout/W01-VERIFICATION.md)

| 能力領域 | 已收錄 Skills |
|---|---:|
| 硬體與嵌入式架構 | 16 |
| 品質與驗證 | 11 |
| 軟體交付與治理 | 24 |
| 資料、AI 與知識工作流 | 15 |
| 技術溝通與視覺呈現 | 14 |
| 需求、商業與技術調研 | 7 |
| **合計** | **87** |

每項只計入一個主要領域；模板副本、系統技能、外掛服務與未來計畫另列，不重複計數。收錄與檔案驗證不等於外部工具、帳號或目標硬體已通過驗證。

## Install and verify

PowerShell 7.2 or later:

```powershell
git clone https://github.com/johnson68878-ops/codex-skills-backup.git
Set-Location .\codex-skills-backup
.\scripts\install.ps1 -WhatIf
.\scripts\install.ps1
.\scripts\verify.ps1
```

The installer restores the current manifest into `%USERPROFILE%\.codex\skills`, skips unchanged entries and backs up differing existing entries before replacement. Compare any same-named entries in `.agents\skills` first. Skills do not install external CLIs, SDKs or service credentials. Refresh skill discovery in Codex after installation.

## Weekly release policy

Only the due batch is published each week. Existing repository-only Skills remain preserved. Each batch includes source attribution, applicable validation, updated counts and a Traditional Chinese progress note. The six-week plan targets 93 vendored Skills, subject to validation; that is a future target, not the current inventory.

Do not run `scripts/update-backup.ps1` during this staged rollout: it rebuilds the entire snapshot and can remove repository-only Skills. Use the explicit weekly allowlist in `manifests/six-week-rollout.json` instead.

The repository excludes `.system`, authentication data, conversations, browser profiles and plugin caches. Plugin-origin templates and the locally copied system review skill are documented as integrations; their cached assets are not republished as original personal Skills. Reconnect GitHub, Google Drive, Figma and other integrations separately.

## Historical documentation

- [September 2026 catalog: original 86 Skills](docs/SKILLS-CATALOG.zh-TW.md)
- [September installation guide](docs/INSTALL-WITH-CODEX.zh-TW.md) — historical counts; the current manifest controls installation.
- [September verification report](docs/verification-2026-09-15.md) — historical runtime audit, not current-machine validation.
- [Original skill analysis](docs/SKILLS-46-ANALYSIS.zh-TW.md)

`.gitattributes` preserves source bytes for stable hashes. The original repair of three planning-with-files templates is documented in the historical backup records.
