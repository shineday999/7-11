#!/bin/bash
# guardian.sh - Cross-monitoring script for 7-11 and FamilyMart

TARGET_PROFILE=$1
TARGET_PORT=$2

if [ -z "$TARGET_PROFILE" ] || [ -z "$TARGET_PORT" ]; then
    echo "Usage: $0 <profile_name> <port>"
    exit 1
fi

# 檢查目標端口是否正在監聽
if ! lsof -i -P -n | grep LISTEN | grep ":$TARGET_PORT " > /dev/null; then
    echo "$(date): [ALERT] Classmate $TARGET_PROFILE (Port $TARGET_PORT) is DOWN!"
    echo "$(date): [ACTION] Reviving $TARGET_PROFILE..."
    
    if [ "$TARGET_PROFILE" == "main" ]; then
        openclaw gateway start
    else
        openclaw --profile "$TARGET_PROFILE" gateway start
    fi
    
    # 傳送通知給 Anderson (如果 Telegram 可用)
    # 這裡預留擴展空間
else
    echo "$(date): [OK] Classmate $TARGET_PROFILE is breathing fine."
fi
