#!/bin/bash
# skills/healthcheck/repair.sh
# Standard Healthcheck & Repair Tool for Agent 7-11 (Resilient Version)

# Ensure script runs detached from the agent process
if [ "$1" != "detached" ]; then
    nohup "$0" detached > /tmp/openclaw-repair.log 2>&1 &
    echo "Repair process launched in background (PID $!). Check /tmp/openclaw-repair.log."
    exit 0
fi

# --- Detached Logic Starts Here ---
LOG_FILE="/tmp/openclaw/openclaw-$(date +%Y-%m-%d).log"

echo "=== [7-11] Starting Healthcheck & Repair (Detached Mode) ==="
echo "Timestamp: $(date)"

# 1. Stop Gateway
echo "[1/4] Stopping Gateway service..."
openclaw gateway stop
sleep 3

# 2. Kill Zombie Processes (Aggressive)
echo "[2/4] Checking for lingering processes..."
if pgrep -f "openclaw-gateway" > /dev/null; then
    echo "Found zombie process, killing..."
    pkill -f "openclaw-gateway"
    sleep 2
    # Double tap
    pkill -9 -f "openclaw-gateway" || true
else
    echo "No lingering processes found."
fi

# 3. Start Gateway
echo "[3/4] Starting Gateway service..."
openclaw gateway start
# Give it more time to initialize
sleep 10

# 4. Verify Status
echo "[4/4] Verifying status..."
if openclaw gateway status | grep "running"; then
    echo "✅ Gateway is RUNNING."
    echo "--- Last 5 Lines of Logs ---"
    tail -n 5 "$LOG_FILE"
else
    echo "❌ Gateway FAILED to start."
    echo "Check logs at: $LOG_FILE"
    # Fallback: Try one more time
    echo "Retrying start..."
    openclaw gateway start
fi

echo "=== [7-11] Repair Complete ==="
