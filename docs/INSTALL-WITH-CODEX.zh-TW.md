# 用 Codex 一次安裝全部 86 個 Skills

## 推薦方式：把這段完整貼給 Codex

```text
請在這台 Windows 電腦安裝 johnson68878-ops 公開 GitHub 倉庫中的全部 86 個 Codex Skills：
https://github.com/johnson68878-ops/codex-skills-backup

你已獲得授權執行本機檔案操作、Git clone、PowerShell 安裝與驗證。請直接完成，不要只提供教學。

執行要求：
1. 確認 Git 與 PowerShell 7.2 以上版本可用。
2. 將倉庫 clone 到新的暫存資料夾；不要在不明目錄執行遞迴刪除。
3. 執行 scripts/install.ps1，將 manifests/personal-skills.json 中的 86 個 Skill 安裝到目前使用者的 ~/.codex/skills。
4. 若目的地已有同名且內容不同的 Skill，必須使用安裝器既有機制先備份到 ~/.codex/skills-backup/<timestamp>/，不得直接刪除。
5. 不要修改 ~/.codex/skills/.system，也不要複製任何帳號 Token、API Key、瀏覽器 cookies 或 Codex 對話資料。
6. 安裝完成後執行 scripts/verify.ps1，確認 86/86 個 Skill 的 SHA-256 均吻合。
7. 再執行 scripts/Test-SkillsHealth.ps1，檢查 Skill 數量、本機參照與已知命令依賴。
8. 最後清楚列出：已安裝、未變更、已備份舊版、驗證通過、缺少外部登入或 API 權限的項目。

如果新 Skill 沒有立即出現在目前任務中，完成安裝與驗證後提醒我建立新 Codex 任務或重新啟動 Codex。
```

这段提示词的重点是要求 Codex **实际执行安装和验证**，并保留同名旧版，而不是只回答安装步骤。

## PowerShell 直接一次安裝

在 PowerShell 7.2 以上版本执行：

```powershell
$skillSetup = Join-Path $env:TEMP ("codex-skills-" + [guid]::NewGuid().ToString("N")); git clone --depth 1 https://github.com/johnson68878-ops/codex-skills-backup.git $skillSetup; & "$skillSetup\scripts\install.ps1"; & "$skillSetup\scripts\verify.ps1"
```

安装器会把仓库中的 86 个个人 Skill 还原到：

```text
%USERPROFILE%\.codex\skills
```

若存在同名但内容不同的版本，旧版会先保存在：

```text
%USERPROFILE%\.codex\skills-backup\<timestamp>\
```

## 完整健康检查

安装后可继续执行：

```powershell
& "$skillSetup\scripts\Test-SkillsHealth.ps1" -SkillRoots "$env:USERPROFILE\.codex\skills" -ExpectedCount 86 -UseKnownRuntimeRequirements
```

健康检查应显示：

| 项目 | 预期结果 |
|---|---:|
| Skills | 86 |
| countMatches | True |
| brokenReferences | 0 |
| missingCommands | 0，或列出该电脑尚未安装的外部命令 |

Skill 文件安装完成不等于外部帐号已经授权。Firecrawl、Figma、Superdesign、Hugging Face Jobs、OpenAI 语音服务及部分社群网站可能仍需各自登入、Token 或 cookies。
