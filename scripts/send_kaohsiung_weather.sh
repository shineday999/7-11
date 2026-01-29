#!/usr/bin/env bash
set -euo pipefail

# Script: 取得高雄天氣並透過 Telegram 機器人發送
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

# 取得簡要天氣（wttr.in 不需要 API key）
WEATHER=$(curl -fsS 'https://wttr.in/Kaohsiung?format=3' || true)
if [ -z "$WEATHER" ]; then
  WEATHER="無法取得天氣資訊"
fi

TEXT="[高雄天氣] $WEATHER"

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d chat_id="$CHAT_ID" \
  -d text="$TEXT" >/dev/null || true

exit 0
