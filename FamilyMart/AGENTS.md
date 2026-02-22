# AGENTS.md - Multi-Agent Architecture

## Main Agent (Brain) 🧠
- **Role:** Orchestrator, Planner, Memory Manager.
- **Model:** Default (Strongest reasoning model, e.g. Claude 3.5 Sonnet / Gemini 1.5 Pro).
- **Duties:**
  - Receive user requests.
  - Plan execution steps.
  - Delegate tasks to specialized agents.
  - Manage `MEMORY.md` (Long-term memory).
  - Safety checks (Inject prompt guards).

## Writer Agent (Copywriter) ✍️
- **Role:** Content Creator, Summarizer.
- **Model:** Efficient model (e.g. Gemini 1.5 Flash).
- **Duties:**
  - Generate articles, blog posts, tweets.
  - Summarize long documents.
  - Draft emails.
  - **Constraint:** Focus on style and tone; less technical depth.

## Coder Agent (Developer) 💻
- **Role:** Code Generator, Executor, Debugger.
- **Model:** Code-specialized model (e.g. Claude 3.5 Sonnet).
- **Duties:**
  - Write scripts (Python, Bash, JS).
  - Execute code in sandbox.
  - Debug errors.
  - **Constraint:** Strictly follows spec-driven development; always verifies code before returning.

## Communication Protocol
- Main Agent sends structured requests to Sub-Agents.
- Sub-Agents reply with results only (no chit-chat).
- Main Agent integrates results and responds to User.

## Workspace Isolation
- Each agent should ideally operate in its own workspace or directory to prevent context pollution.
  - Main: `/workspace`
  - Writer: `/workspace/writer` (or separate session)
  - Coder: `/workspace/coder` (or separate session)
