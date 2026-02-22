# Skill: Healthcheck & Self-Repair

## Description
A critical system skill to diagnose connection issues, repair Gateway failures, and ensure the agent (7-11) remains operational.

## Diagnosis
- Checks Gateway status.
- Verifies network connectivity (Telegram, Browser).
- Detects zombie processes.

## Usage
Run the repair script to attempt an automatic fix.

```bash
bash skills/healthcheck/repair.sh
```

## Protocol (Self-Repair)
1.  **Stop Service**: Gracefully stop the gateway service.
2.  **Kill Zombies**: Identify and kill any lingering processes.
3.  **Start Service**: Restart the gateway.
4.  **Verify**: Check logs and status post-restart.

## Notes
- This skill should be invoked when:
    - `browser` tool fails with "pairing required".
    - `telegram` fails to connect.
    - System feels unresponsive.
