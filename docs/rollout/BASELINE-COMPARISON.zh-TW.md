# 本機與 GitHub 基準比對

日期：2026-10-26；GitHub 基準 `7bc24da5869af1605b840bd637a73f01a40a041d`。

以相同的目錄 SHA-256 演算法比較使用者技能目錄；排除 `.system` 與外掛快取。

| 指標 | 數量 |
|---|---:|
| GitHub 原有個人 Skills | 86 |
| 本機個人 Skills（含新複製的模板與 review-agent） | 62 |
| 兩邊同名且內容完全一致 | 34 |
| 同名但內容不同 | 0 |
| 僅 GitHub 保留 | 52 |
| 僅本機存在 | 28 |

這是發布前的基準快照，不是每週動態值。本週新增 embedded-systems 後，倉庫收錄數為 87。

## 處理原則

- 保留倉庫的 52 個歷史技能；本機未安裝不是刪除依據。
- 6 個新 GitHub 技能按六個主題分週收錄；DeepTutor CLI 歸在第六週。
- 20 個 artifact-template 與 review-agent 屬已複製至本機的外掛／系統來源內容。沿用本倉庫原有「外掛與系統不整包備份」政策，列為整合清單與使用路由，不將其來源資產當作自研技能重複發布。
- 另有外掛提供的圖表、Figma、文件、試算表等能力；其帳號與服務連線不可用 Skill 檔案還原。
- 本機有檔案、聊天可發現、依賴已安裝、功能已驗證，是不同狀態。

## 兩邊一致（34）

`5why-root-cause`, `action-priority-ap`, `agent-reach`, `apqp`, `architecture-blueprint-generator`, `architecture-decision-records`, `bom`, `breakdown-feature-prd`, `bus-drivers-i2c-spi`, `control-plan`, `create-github-issues-for-unmet-specification-requirements`, `dfmea-design`, `dvp-test-plan`, `emc`, `fishbone-analysis`, `fmea-reviewer`, `freecad-scripts`, `github-actions-efficiency`, `github-actions-hardening`, `gtm-technical-product-pricing`, `is-is-not-scoping`, `kicad`, `matlab-analyze-em`, `matlab-analyze-pcb-pdn`, `matlab-analyze-spectrum`, `matlab-deploy-embedded-code`, `matlab-integrate-pcb-circuit`, `matlab-read-pcb-layout`, `mcp-security-audit`, `pfmea-process`, `ppap`, `prd`, `spice`, `supply-chain-security`

## 僅倉庫保留（52）

`advanced-evaluation`, `awesome-skills`, `brainstorming`, `browser-use`, `cli-creator`, `code-review`, `codex-ppt`, `defuddle`, `dispatching-parallel-agents`, `evaluation`, `executing-plans`, `figma`, `find-skills`, `finishing-a-development-branch`, `firecrawl`, `frontend-design`, `gh-fix-ci`, `guizang-ppt-skill`, `huggingface-community-evals`, `huggingface-llm-trainer`, `huggingface-local-models`, `humanizer`, `humanizer-zh`, `hyperframes`, `image-to-editable-ppt`, `json-canvas`, `jupyter-notebook`, `mcp-builder`, `mechanical-cad-review`, `obsidian-bases`, `obsidian-cli`, `obsidian-markdown`, `pcb-eda-review`, `planning-with-files`, `receiving-code-review`, `remotion-best-practices`, `requesting-code-review`, `screenshot`, `soc-architecture`, `speech`, `subagent-driven-development`, `superdesign`, `systematic-debugging`, `test-driven-development`, `transcribe`, `ui-ux-pro-max`, `using-git-worktrees`, `using-superpowers`, `verification-before-completion`, `webapp-testing`, `writing-plans`, `writing-skills`

## 僅本機存在（28）

`artifact-template-analytics-dashboard`, `artifact-template-business-review`, `artifact-template-design-report`, `artifact-template-experiment-analysis`, `artifact-template-financial-budget`, `artifact-template-investment-committee-memo`, `artifact-template-legal-memorandum`, `artifact-template-market-trends-report`, `artifact-template-minimal-letterhead`, `artifact-template-operating-calendar`, `artifact-template-operating-review`, `artifact-template-project-kickoff`, `artifact-template-project-tracker`, `artifact-template-sales-pipeline`, `artifact-template-simple-dark-mode`, `artifact-template-simple-light-mode`, `artifact-template-strategy-memorandum`, `artifact-template-system-design`, `artifact-template-team-alignment`, `artifact-template-three-statement-forecast`, `deeptutor-cli`, `embedded-systems`, `experimental-design`, `neurokit2`, `review-agent`, `scientific-visualization`, `statistical-analysis`, `theme-factory`
