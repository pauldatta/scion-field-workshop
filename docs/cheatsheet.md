# Scion CLI Cheatsheet

Quick reference for the most common Scion commands, organized by workflow.

---

## Grove Management

```bash
# Initialize a new grove in the current directory
scion init

# Show grove status
scion status
```

## Agent Lifecycle

```bash
# Start an agent with a task
scion start <name> "<task description>"

# Start with a specific template
scion start <name> "<task>" --type <template-name>

# Start and immediately attach
scion start <name> "<task>" --attach

# List all agents
scion list

# List with JSON output (for scripting)
scion list --format json

# Attach to a running agent
scion attach <name>

# Detach from agent: Ctrl+B, D

# Stop an agent
scion stop <name>

# Stop all agents
scion stop --all

# Remove a completed agent
scion remove <name>
```

## Messaging

```bash
# Send a message to a specific agent
scion message <name> "<message>"

# Broadcast to all agents
scion message --broadcast "<message>"
```

## Templates

```bash
# List available templates
scion templates list

# Show template details
scion templates show <template-name>

# Template directory structure
# .scion/templates/<template-name>/
#   ├── scion-agent.yaml      # Configuration
#   ├── agents.md              # Role description & workflow
#   └── system-prompt.md       # System prompt
```

## Monitoring

```bash
# View agent logs
scion logs <name>

# Follow logs in real-time
scion logs <name> --follow

# Agent state (JSON)
scion list --format json | jq '.[] | {name, phase, activity, detail}'

# Check which agents are still running
scion list --format json | jq '[.[] | select(.phase != "done")]'
```

## Scripted Automation

```bash
# Start agents headlessly (no --attach)
scion start reviewer "<task>" --type security-auditor

# Poll for completion
while scion list --format json | jq '[.[] | select(.phase != "done")] | length > 0' -e &>/dev/null; do
  sleep 10
done

# Collect all agent names
scion list --format json | jq -r '.[].name'
```

## Git Worktree Management

```bash
# List agent worktree branches
git branch | grep scion/

# Merge an agent's work
git merge scion/<agent-name>

# View agent's changes
git diff main..scion/<agent-name>

# Clean up after merging
git branch -d scion/<agent-name>
```

## Cleanup

```bash
# Stop all agents
scion stop --all

# Remove all completed agents
scion remove --all

# Full cleanup (grove reset)
rm -rf .scion/
```

---

## Template Triad Quick Reference

Every template directory contains three files:

| File | Purpose | Example Content |
|---|---|---|
| `scion-agent.yaml` | Agent configuration | Harness type, environment variables, settings |
| `agents.md` | Role description | Available roles, workflow, completion criteria |
| `system-prompt.md` | LLM system prompt | Personality, constraints, output format |
