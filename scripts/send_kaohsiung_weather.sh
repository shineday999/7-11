#!/usr/bin/env bash
set -euo pipefail

# Script: 取得最新 AI 新聞並透過 Telegram 機器人發送
# 依賴: jq, curl

BOT_TOKEN=$(jq -r '.channels.telegram.botToken // empty' ~/.clawdbot/clawdbot.json 2>/dev/null || echo "")
if [ -z "$BOT_TOKEN" ]; then
  echo "Error: 無法從 ~/.clawdbot/clawdbot.json 取得 Telegram bot token" >&2
  exit 1
fi

CONFIG_FILE=~/.clawdbot/schedules/weather_config.json
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: config 檔不存在：$CONFIG_FILE" >&2
  exit 1
fi

CHAT_ID=$(jq -r '.chat_id // empty' "$CONFIG_FILE")
if [ -z "$CHAT_ID" ]; then
  echo "Error: 請在 $CONFIG_FILE 設定 chat_id" >&2
  exit 1
fi

# 優先使用 Gemini Pro 3（若在 $CONFIG_FILE 或環境變數中設定），否則回退到 Google News RSS
# 支援的設定：在 $CONFIG_FILE 新增 "gemini": { "api_key": "...", "api_url": "https://..." }
GEMINI_API_KEY=$(jq -r '.gemini.api_key // empty' "$CONFIG_FILE" 2>/dev/null || echo "${GEMINI_API_KEY:-}")
GEMINI_API_URL=$(jq -r '.gemini.api_url // empty' "$CONFIG_FILE" 2>/dev/null || echo "${GEMINI_API_URL:-}")

NEWS_TEXT=""
if [ -n "$GEMINI_API_KEY" ] && [ -n "$GEMINI_API_URL" ]; then
  PROMPT="請列出最近 5 則有關 AI 的新聞標題與來源連結，每行一則，僅回傳標題與網址。"
  PAYLOAD=$(jq -nc --arg p "$PROMPT" '{prompt: $p, max_output_tokens: 800}')
  RESPONSE=$(curl -fsS -X POST "$GEMINI_API_URL" \
    -H "Authorization: Bearer $GEMINI_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD" 2>/dev/null || true)

  if [ -n "$RESPONSE" ]; then
    # 嘗試用 jq 抽取常見欄位，若失敗則用原始回應
    NEWS_TEXT=$(printf "%s" "$RESPONSE" | jq -r '(.output[0].content[0].text // .candidates[0].content // .text // .response // "")' 2>/dev/null || true)
    if [ -z "$NEWS_TEXT" ]; then
      NEWS_TEXT="$RESPONSE"
    fi
  fi
fi

if [ -z "$NEWS_TEXT" ]; then
  RSS_URL='https://news.google.com/rss/search?q=AI+artificial+intelligence&hl=en-US&gl=US&ceid=US:en'
  RSS_RAW=$(curl -fsS "$RSS_URL" 2>/dev/null || true)
  NEWS_TEXT=$(printf "%s" "$RSS_RAW" | awk -F'<title>|</title>' '/<title>/{print $2}' | sed '1d' | head -n 5 | nl -w1 -s'. ' | sed 's/^/ /' || true)
  if [ -z "$NEWS_TEXT" ]; then
    NEWS_TEXT="無法取得 AI 新聞"
  fi
fi

MSG="[AI 新聞]\n$NEWS_TEXT"

# 發送 Telegram 消息並檢查響應
TELEGRAM_RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d chat_id="$CHAT_ID" \
  -d text="$MSG")

# 檢查 Telegram API 回應
if echo "$TELEGRAM_RESPONSE" | grep -q '"ok":true'; then
  echo "✓ Telegram 消息已發送成功"
  exit 0
else
  echo "✗ Telegram 發送失敗"
  echo "Response: $TELEGRAM_RESPONSE" >&2
  exit 1
fi
