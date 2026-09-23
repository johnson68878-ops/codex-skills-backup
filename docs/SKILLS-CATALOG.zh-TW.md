# Codex Skills 完整分類指南（86 個）

更新日期：2026-09-23

這份文件是 `codex-skills-backup` 的公司內部分享版目錄，整理倉庫內可備份、可安裝的 **86 個個人 Skills**。Skill 是一組讓 Codex 在特定任務中遵循的工作流程、領域規則與工具使用說明；它不是模型權重，也不代表安裝後就自動取得外部系統權限。

## 快速理解

- **個人 Skill（本文件的 86 個）**：原始檔已收錄在本倉庫，可透過安裝腳本搬移到另一台電腦。
- **系統 Skill**：由 Codex 提供與維護，不納入個人備份。
- **外掛 Skill**：由已安裝的 Plugin 提供，通常還需要重新安裝外掛、登入帳號或授權服務，因此不以複製檔案方式還原。
- **外部依賴**：部分 Skills 需要 CLI、桌面軟體、API Key、模型、MCP Server 或帳號權限；安裝 Skill 本身不等於已具備這些依賴。

## 分類總覽

| 類別 | 數量 | 主要用途 |
|---|---:|---|
| 品質管理與汽車產業流程 | 11 | 8D、FMEA、APQP、PPAP、Control Plan 與根因分析 |
| 電子、PCB、嵌入式與 CAD | 15 | 電路／PCB 審查、EMC、SPICE、MATLAB、機構與 SoC |
| 軟體工程、架構與測試 | 12 | 架構文件、程式審查、除錯、測試與 GitHub CI |
| Agent 規劃與執行工作流 | 9 | 規劃、平行協作、隔離開發、驗證與交付 |
| AI／LLM 訓練與評估 | 5 | 評測系統、模型訓練、在地推論與 Hugging Face |
| 網路研究與瀏覽器自動化 | 4 | 跨平台研究、爬取、內容抽取與瀏覽器操作 |
| UI／UX、簡報、影像、影音與語音 | 12 | 介面設計、PPT、影片、截圖、語音與轉錄 |
| 產品管理與商業策略 | 3 | PRD、功能拆解與技術產品定價 |
| 知識管理與資料工作區 | 5 | Obsidian、Canvas 與 Jupyter Notebook |
| Skill、CLI 與 MCP 擴充 | 5 | 尋找／撰寫 Skills、建立 CLI 與 MCP Server |
| 安全與供應鏈治理 | 3 | GitHub Actions、MCP 與軟體供應鏈安全 |
| 文字潤飾與自然化 | 2 | 中英文去除 AI 腔並維持原意 |
| **合計** | **86** | |

## 1. 品質管理與汽車產業流程（11）

這一組可串成完整的品質閉環：先界定問題與發散原因，再確認根因；設計端與製程端分別建立 FMEA，接著連動 DVP、Control Plan、APQP 與 PPAP。

| Skill | 功能介紹 | 適合使用情境 |
|---|---|---|
| `5why-root-cause` | 建立有證據的 5 Why 因果鏈，檢查跳步與循環論證。 | 8D D4、CAPA、客訴與失效根因調查 |
| `action-priority-ap` | 依 AIAG-VDA 規則判定 H／M／L Action Priority。 | PFMEA、DFMEA 風險分級與稽核 |
| `apqp` | 規劃 APQP 五階段、交付物與 Gate Review。 | 新產品導入、量產前品質規劃 |
| `control-plan` | 建立或稽核 Prototype、Pre-launch、Production Control Plan。 | 將 PFMEA 風險落到製程管制與反應計畫 |
| `dfmea-design` | 以 AIAG-VDA 七步法進行設計風險與介面分析。 | 新設計、設計變更、場域失效改善 |
| `dvp-test-plan` | 將 DFMEA 失效模式連結到測試、判定標準、樣本數與時程。 | DVP&R 建立、供應商測試計畫審查 |
| `fishbone-analysis` | 以人、機、料、法、測、環的 6M 魚骨圖發散可能原因。 | 8D、CAPA、跨部門原因腦力激盪 |
| `fmea-reviewer` | 稽核 DFMEA／PFMEA 的失效模式、AP、特殊特性與管制計畫連結。 | PPAP 前審查、客戶或內部稽核準備 |
| `is-is-not-scoping` | 用 Is／Is Not 對照界定問題邊界並排除不符假設。 | 8D D2、異常範圍確認、假設收斂 |
| `pfmea-process` | 依 AIAG-VDA 七步法建立製程 FMEA 與改善行動。 | 新製程、製程變更、逃逸問題回饋 |
| `ppap` | 檢查 PPAP 等級與 18 項交付物，協助準備 PSW。 | 供應商送樣、量產核准、PPAP 完整性稽核 |

## 2. 電子、PCB、嵌入式與 CAD（15）

涵蓋從元件選型、原理圖／PCB 審查、模擬與 EMC，到機構 CAD、SoC 架構及嵌入式程式的工程工作。

| Skill | 功能介紹 | 適合使用情境 |
|---|---|---|
| `bom` | 統一管理電子 BOM、料號、數量、成本與供應來源。 | 詢價、備料、JLCPCB／PCBWay 生產資料準備 |
| `bus-drivers-i2c-spi` | 協助撰寫 Linux I2C／SPI client driver、regmap 與 DT／ACPI 綁定。 | 感測器、周邊晶片與匯流排驅動開發 |
| `emc` | 對 KiCad PCB 執行 EMC 預相容風險分析與測試規劃。 | FCC、CISPR、車規 EMI／EMC 設計審查 |
| `freecad-scripts` | 以 FreeCAD Python API 建立參數化模型、巨集與工具。 | 3D 自動建模、FeaturePython、工作台擴充 |
| `kicad` | 分析 KiCad／PDF 原理圖、PCB、Gerber、BOM、DRC／ERC 與電源樹。 | 投板前審查、除錯、DFM 與電路理解 |
| `matlab-analyze-em` | 進行 RF PCB 的 S 參數、場、電流、網格與求解器分析。 | 插入損耗、回波損耗與電磁性能驗證 |
| `matlab-analyze-pcb-pdn` | 分析 PCB 電源網路的 IR Drop、電流密度與設計規則。 | 電源完整性、壓降與多電源網批次分析 |
| `matlab-analyze-spectrum` | 使用 MATLAB 進行 FFT、PSD、頻譜峰值、頻寬與串流頻譜分析。 | 訊號頻域分析、視窗選擇與洩漏判讀 |
| `matlab-deploy-embedded-code` | 設定 Embedded Coder、SIL／PIL 與硬體目標部署。 | STM32、ARM Cortex、Raspberry Pi 程式碼生成 |
| `matlab-integrate-pcb-circuit` | 串接 PCB 元件、加入 RLC、輸出 Touchstone 並整合後續分析。 | RF PCB 級聯、電路整合與 S 參數交換 |
| `matlab-read-pcb-layout` | 匯入 Gerber、ODB++、Allegro `.brd`／`.mcm` 並檢視網路與層疊。 | 將既有 PCB 資料帶入 MATLAB 分析 |
| `mechanical-cad-review` | 審查 Creo／SOLIDWORKS 零件、組件、圖面、BOM 與干涉報告。 | GD&T、DFM／DFA、版本比較與放行準備 |
| `pcb-eda-review` | 審查 OrCAD、Allegro、PADS 的原理圖、約束、DRC 與生產輸出。 | PCB 版本比較、問題分流與 Release Readiness |
| `soc-architecture` | 建立與審查 SoC 方塊、介面、位址、時鐘、電源與 PPA 預算。 | SoC 架構探索、規格一致性與驗證交接 |
| `spice` | 自動產生測試平台並以 ngspice／LTspice／Xyce 驗證子電路。 | 濾波器、分壓器、OP Amp、LC、晶振模擬 |

## 3. 軟體工程、架構與測試（12）

這一組支援從架構決策、需求落地、測試驅動到 Code Review、CI 修復與分支收尾的軟體交付流程。

| Skill | 功能介紹 | 適合使用情境 |
|---|---|---|
| `architecture-blueprint-generator` | 掃描程式庫並產生技術棧、架構模式、圖表與實作藍圖。 | 新人導讀、系統盤點、架構文件補齊 |
| `architecture-decision-records` | 撰寫與維護 Architecture Decision Record（ADR）。 | 記錄重大技術選擇、替代方案與後果 |
| `code-review` | 從標準符合度與需求符合度兩條軸線審查變更。 | 分支、PR、工作中差異與指定基準點審查 |
| `create-github-issues-for-unmet-specification-requirements` | 將規格中未實作的需求轉成 GitHub Issues。 | 規格差距盤點與需求追蹤 |
| `finishing-a-development-branch` | 在功能完成、測試通過後協助決定整合與清理方式。 | Merge／PR／保留分支前的收尾 |
| `gh-fix-ci` | 透過 GitHub CLI 分析 GitHub Actions 失敗並規劃修復。 | PR Checks 失敗、CI Log 排查 |
| `github-actions-efficiency` | 稽核 Workflow 執行效率與成本。 | 降低 GitHub Actions 分鐘數與重複工作 |
| `receiving-code-review` | 嚴謹驗證 Code Review 意見後再落實修改。 | 意見不清楚、可能不正確或牽涉取捨時 |
| `requesting-code-review` | 在重大功能完成或合併前安排結構化審查。 | 交付前品質閘門 |
| `systematic-debugging` | 先蒐證、重現與定位根因，再提出修復。 | Bug、測試失敗、非預期行為 |
| `test-driven-development` | 以先寫失敗測試、再實作與重構的節奏開發。 | 新功能、Bugfix、回歸保護 |
| `webapp-testing` | 使用 Playwright 操作與測試本機 Web App、截圖並查看瀏覽器日誌。 | 前端功能驗證與 UI 除錯 |

## 4. Agent 規劃與執行工作流（9）

用於管理複雜任務的思考、拆解、執行、隔離、協作與驗證，讓長任務的進度和證據可追蹤。

| Skill | 功能介紹 | 適合使用情境 |
|---|---|---|
| `brainstorming` | 在創作或改變功能前探索目的、限制與設計方向。 | 需求模糊、需要先比較方案時 |
| `dispatching-parallel-agents` | 將互不依賴的工作分派給多個 Agent 平行進行。 | 兩項以上可獨立完成的研究或實作 |
| `executing-plans` | 依既有書面計畫分階段執行並設置審查點。 | 跨 Session 的長程實作 |
| `planning-with-files` | 以 `task_plan.md`、`findings.md`、`progress.md` 保存長任務狀態。 | 需要五次以上工具操作的研究或工程任務 |
| `subagent-driven-development` | 在同一個 Session 中以獨立子任務推進實作計畫。 | 可拆分模組的開發工作 |
| `using-git-worktrees` | 建立隔離的 Git Worktree，避免干擾目前工作區。 | 平行功能開發、實驗性修改 |
| `using-superpowers` | 建立優先尋找並套用 Skills 的通用工作方式。 | 任務開始時選擇正確專業流程 |
| `verification-before-completion` | 在宣告完成、提交或建立 PR 前要求實際驗證證據。 | 防止未測試即宣稱成功 |
| `writing-plans` | 在動手修改前把多步驟需求寫成可執行計畫。 | 有明確規格的中大型任務 |

## 5. AI／LLM 訓練與評估（5）

適合建立 AI 品質量測、比較模型、微調模型，以及在本機部署量化模型。

| Skill | 功能介紹 | 適合使用情境 |
|---|---|---|
| `advanced-evaluation` | 建立 LLM-as-judge、成對比較、校準與偏差控制。 | 複雜主觀品質評估與自動打分 |
| `evaluation` | 建立確定性檢查、回歸集、Rubric、品質閘門與監控。 | Agent／LLM Pipeline 的持續評測 |
| `huggingface-community-evals` | 使用 inspect-ai／lighteval 在本機評測 Hugging Face 模型。 | 本機 GPU 評測與後端選擇 |
| `huggingface-llm-trainer` | 透過 TRL／Unsloth 執行 SFT、DPO、GRPO、Reward Modeling。 | 雲端 GPU 微調、資料準備與 GGUF 轉換 |
| `huggingface-local-models` | 選擇 GGUF、量化等級與 llama.cpp 執行方式。 | CPU、Metal、CUDA、ROCm 本機推論服務 |

## 6. 網路研究與瀏覽器自動化（4）

這一組處理跨網站搜尋、內容清理、結構化擷取與瀏覽器互動。使用時仍須遵守公司資料治理、網站條款與存取權限。

| Skill | 功能介紹 | 適合使用情境 |
|---|---|---|
| `agent-reach` | 依平台路由研究工具，涵蓋社群、影片、職涯、開發與財經來源。 | 多平台公開資訊調研與討論蒐集 |
| `browser-use` | 透過 CDP 控制瀏覽器進行操作、擷取、測試與截圖。 | 需要真實頁面互動的 Web 任務 |
| `defuddle` | 將一般網頁抽取為乾淨 Markdown，移除導覽與雜訊。 | 閱讀文章、文件與部落格內容 |
| `firecrawl` | 使用 Firecrawl CLI 搜尋、爬取、Map、Crawl 與結構化擷取。 | 大範圍網站研究、資料收集與監測 |

## 7. UI／UX、簡報、影像、影音與語音（12）

涵蓋從介面設計到簡報、影片、語音與轉錄的內容製作流程。

| Skill | 功能介紹 | 適合使用情境 |
|---|---|---|
| `codex-ppt` | 將文章、報告、論文或大綱製作成視覺一致的 PPTX。 | 提案、內訓、研究報告簡報 |
| `figma` | 讀取 Figma 設計、變數與素材並轉換成產品程式碼。 | Design-to-Code、Figma MCP 設定與除錯 |
| `frontend-design` | 提供有辨識度的視覺方向、字體與版面決策。 | 新 UI 或既有介面改版 |
| `guizang-ppt-skill` | 製作可橫向翻頁、含講者模式的單檔 HTML 網頁簡報。 | 發表會、分享會、雜誌風／瑞士風簡報 |
| `hyperframes` | 建立、編輯、驗證與渲染影片、動畫及 Motion Graphics。 | Promo、Explainer、字幕短片與互動 Deck |
| `image-to-editable-ppt` | 把圖片、掃描 PDF 或不可編輯投影片重建為物件級 PPTX。 | 舊簡報重製、截圖轉可編輯投影片 |
| `remotion-best-practices` | 將 Remotion 影片任務路由到適當的最佳實務。 | React／Remotion 程式化影片 |
| `screenshot` | 擷取全螢幕、指定視窗或像素區域。 | 文件佐證、操作教學、問題回報 |
| `speech` | 透過 OpenAI Audio API 產生旁白與批次語音。 | 無障礙朗讀、影片 Voice-over、語音提示 |
| `superdesign` | 在 Superdesign 畫布上設計或重設頁面、流程與視覺變體。 | 無程式碼介面探索、設計系統與行銷圖 |
| `transcribe` | 將音訊／影片轉成文字，可做講者分離與已知講者提示。 | 會議記錄、訪談、課程與字幕 |
| `ui-ux-pro-max` | 提供樣式、配色、字體、UX 規則、動效與圖表的設計資料庫。 | Web／Mobile UI 設計、實作與審查 |

## 8. 產品管理與商業策略（3）

| Skill | 功能介紹 | 適合使用情境 |
|---|---|---|
| `breakdown-feature-prd` | 從 Epic 拆出 Feature 等級的 PRD。 | 大需求拆分、功能邊界與驗收條件整理 |
| `gtm-technical-product-pricing` | 設計使用量／席次定價、Freemium 門檻與企業方案。 | 技術產品上市、漲價與定位策略 |
| `prd` | 產出包含摘要、User Story、技術規格與風險的完整 PRD。 | 軟體系統與 AI 功能規劃 |

## 9. 知識管理與資料工作區（5）

| Skill | 功能介紹 | 適合使用情境 |
|---|---|---|
| `json-canvas` | 建立與編輯含節點、群組和連線的 `.canvas` 檔。 | Obsidian Canvas、心智圖、流程圖 |
| `jupyter-notebook` | 以範本建立乾淨的 `.ipynb`，支援實驗與教學。 | 資料探索、分析紀錄、可重現示範 |
| `obsidian-bases` | 建立 `.base` 的 View、Filter、Formula 與 Summary。 | 把筆記做成表格、卡片或資料庫視圖 |
| `obsidian-cli` | 透過 CLI 讀寫、搜尋與管理 Vault，並協助外掛／主題開發。 | 大量筆記操作、任務管理、Obsidian 除錯 |
| `obsidian-markdown` | 編輯 Wikilink、Embed、Callout、Properties 等 Obsidian Markdown。 | 建立符合 Obsidian 語法的知識文件 |

## 10. Skill、CLI 與 MCP 擴充（5）

| Skill | 功能介紹 | 適合使用情境 |
|---|---|---|
| `awesome-skills` | 從技能清單探索並安裝適合的專業 Skill。 | 現有能力不足、尋找可重用工作流 |
| `cli-creator` | 從 API 文件、OpenAPI、SDK 或既有腳本建立可組合 CLI。 | 把服務能力包裝成跨專案命令列工具 |
| `find-skills` | 根據「如何完成某事」的需求尋找可安裝 Skill。 | 擴充 Codex 能力、避免重造工作流 |
| `mcp-builder` | 指導以 Python 或 TypeScript 建立高品質 MCP Server。 | 讓模型安全地連接內外部 API 與服務 |
| `writing-skills` | 建立、修改並驗證 Skill 的觸發條件、流程與資源。 | 企業內部標準流程封裝與維護 |

## 11. 安全與供應鏈治理（3）

| Skill | 功能介紹 | 適合使用情境 |
|---|---|---|
| `github-actions-hardening` | 檢查輸入注入、特權 Trigger、權限過大、未釘版本與 Secret 風險。 | 新增或稽核 GitHub Actions Workflow |
| `mcp-security-audit` | 稽核 MCP 設定中的 Secret、Shell Injection、版本與核准清單。 | `.mcp.json` 安全與治理檢查 |
| `supply-chain-security` | 提供 OpenSSF Scorecard、SLSA、Sigstore、SBOM 等安全框架。 | 軟體供應鏈現況盤點與改善 Backlog |

## 12. 文字潤飾與自然化（2）

| Skill | 功能介紹 | 適合使用情境 |
|---|---|---|
| `humanizer` | 在不改變意思的前提下移除英文 AI 寫作痕跡。 | 報告、Email、文件與對外文字潤飾 |
| `humanizer-zh` | 辨識並修正中文的誇大、模板化、過度連接與 AI 腔。 | 中文提案、說明文件與公司溝通 |

## 建議的公司導入方式

1. **先選場景，不要一次啟用所有流程**：依部門建立最小 Skill 組合，例如品質部使用 FMEA／APQP 組，硬體部使用 KiCad／EMC／SPICE 組。
2. **指定責任人與版本**：每個關鍵 Skill 應有維護人，更新後重新驗證並留下版本紀錄。
3. **把 Skill 視為工作指引，不是最終核准者**：法規、安規、設計放行、客戶文件與量產決策仍需由合格人員審查。
4. **先處理依賴與權限**：CLI、API Key、MCP、GitHub、Figma、EDA、MATLAB 等需由 IT 或系統擁有者依公司政策配置。
5. **保護公司資料**：使用網路研究、雲端 API、外掛或外部模型前，先確認資料分級、供應商條款與公司資安政策。

## 安裝與驗證

完整安裝方式請參考 [Install all 86 Skills with Codex](INSTALL-WITH-CODEX.zh-TW.md)。安裝完成後執行：

```powershell
.\scripts\verify.ps1
```

驗證通過代表 Skill 檔案與倉庫清單一致；不代表其外部軟體、帳號、API 或授權已可用。
