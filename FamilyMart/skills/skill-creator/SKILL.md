# Skill: Skill Creator

## Description
A meta-skill for creating and scaffolding new skills in the `skills/` directory. This ensures all new skills follow the "Spec-Driven Development" standard.

## Usage

Run this skill when you need to teach the agent a new capability.

## Protocol

1.  **Analyze Request**: Understand what the new skill should do.
2.  **Create Directory**: `mkdir -p skills/<skill-name>`
3.  **Create SKILL.md**: Write a `SKILL.md` file in that directory with the following structure:
    -   `# Skill: <Name>`
    -   `## Description`: What it does.
    -   `## Usage`: How to use it.
    -   `## Implementation`: (Optional) Scripts or commands.
4.  **Register**: Add the skill to the `<available_skills>` section in the main system prompt (if applicable) or `TOOLS.md`.

## Example Structure

```markdown
# Skill: Weather Check

## Description
Fetches current weather for a location.

## Usage
- Command: `curl wttr.in/Taipei`
```

## Self-Evolution Note
Always update `MEMORY.md` after successfully creating a new skill to record the capability expansion.
