# MEMORY.md - Long-Term Memory

## 核心指令 (Core Directives)
- **User:** Anderson
- **Agent Name:** 7-11 (Robot, 24/7 service style)
- **Language:** **Traditional Chinese (繁體中文) ONLY**
- **Repository:** `git@github.com:shineday999/7-11.git`

## 經驗與教訓 (Lessons Learned)

### 1. GitHub SSH Key 配置 (2026-02-22)
- **問題:** GitHub 報錯 `Key is invalid. You must supply a key in OpenSSH public key format.`。
- **原因:** 複製公鑰時混入了隱藏的換行符或空格，導致格式校驗失敗。
- **解決方案:**
  1. 使用 `ssh-keygen -t ed25519` 生成較短的金鑰。
  2. 使用 `cat` 命令直接讀取檔案內容，不經過 markdown 格式化。
  3. 複製時嚴格選取 `ssh-ed25519` 開頭至結尾，確保無多餘空格。

### 2. Gateway 配對與瀏覽器模組 (2026-02-22)
- **問題:** `browser` 工具與 CLI 皆報錯 `gateway closed (1008): pairing required`。
- **原因:** CLI 客戶端與 Gateway 服務未配對，且 HTTP 儀表板因安全上下文 (Non-Secure Context) 限制無法生成設備身份。
- **暫時解法:**
  - 放棄 `browser` 工具，改用 `web_fetch` 讀取靜態頁面內容。
  - 使用 `web_search` 獲取資訊 (需 Brave API Key)。
  - **安全考量：** 雖然可以嘗試修改配對資料庫或強制繞過，但在無法確保安全的情況下，選擇放棄並專注於其他不需要配對的任務。
- **待辦優化:**
  - 需在 Gateway 主機本機使用 `http://127.0.0.1:18789/` 進行配對。
  - 或者研究如何生成 Admin Token 直接在 CLI 認證。

### 3. OpenClaw 架構學習 (2026-02-22)
- **核心:** 規格驅動開發 (Spec-Driven Development)。
- **策略:**
  - 多 Agent 分工 (主腦/畫師/寫手)。
  - 獨立 Workspace 避免記憶污染。
  - 安全掃描 (防 Prompt 注入)。
- **多 Agent 架構實作 (Phase 3):**
  - 已建立 `skills/writer` 與 `skills/coder` 及其 `SKILL.md`。
  - 已建立 `agents/writer` 與 `agents/coder` 及其 `IDENTITY.md` / `SOUL.md`。
  - 已建立 `skills/healthcheck` 與 `repair.sh` (Detached Mode)。

## 待辦事項 (Todo)
- [ ] 實作多 Agent 架構的實際生成 (Phase 4: Validation)。
- [ ] 實作 `Weather` 技能 (驗證 `skill-creator`)。
- [ ] 修復 Gateway 配對問題 (長期目標)。
