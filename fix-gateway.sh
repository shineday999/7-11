#!/bin/bash
echo "Starting Gateway Self-Repair Protocol..."

# 1. Stop the gateway service
echo "[1/4] Stopping Gateway service..."
openclaw gateway stop
sleep 2

# 2. Check for zombie processes and kill them if necessary
echo "[2/4] Checking for lingering processes..."
pkill -f "openclaw-gateway" || echo "No lingering processes found."
sleep 1

# 3. Start the gateway service
echo "[3/4] Starting Gateway service..."
openclaw gateway start
sleep 5

# 4. Verify status
echo "[4/4] Verifying status..."
openclaw gateway status

echo "Gateway Self-Repair Protocol Complete."
