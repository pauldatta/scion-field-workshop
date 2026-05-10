# Exercise: Build an ADK Scion Agent

## Objective

Create a Python ADK agent that integrates with Scion's lifecycle management, package it as a template, and deploy it alongside Gemini CLI agents in the same grove.

## Duration

30 minutes

## Prerequisites

- Python 3.11+
- `google-adk` package installed
- Scion grove initialized

## Overview

This exercise bridges two ecosystems:

- **ADK (Agent Development Kit)** provides the agent framework (tools, LLM routing, callbacks)
- **Scion** provides the infrastructure (containers, isolation, orchestration)

You'll build an agent that reports its lifecycle state to Scion via `sciontool`.

## Instructions

### Step 1: Create the Agent (10 min)

Create `adk_agent/agent.py`:

```python
import subprocess
import json
from google.adk import Agent, Tool

def report_status(phase: str = None, activity: str = None, detail: str = None):
    """Report agent status to Scion lifecycle manager."""
    cmd = ["sciontool", "status"]
    if phase:
        cmd.extend(["--phase", phase])
    if activity:
        cmd.extend(["--activity", activity])
    if detail:
        cmd.extend(["--detail", detail])
    subprocess.run(cmd, capture_output=True)

@Tool
def analyze_file(file_path: str) -> str:
    """Analyze a source file and return a summary."""
    report_status(activity="tool_use", detail=f"Analyzing {file_path}")
    with open(file_path, 'r') as f:
        content = f.read()
    return f"File: {file_path}\nLines: {len(content.splitlines())}\nSize: {len(content)} bytes"

# Create the agent
agent = Agent(
    name="code-analyzer",
    description="Analyzes source code files and reports findings",
    tools=[analyze_file],
)

# Report ready state
report_status(phase="running", activity="idle", detail="Ready for tasks")
```

### Step 2: Create the Scion Template (10 min)

Create `adk-analyzer/scion-agent.yaml`:

```yaml
name: adk-analyzer
description: "Python ADK agent for code analysis"
harness: adk
runtime:
  image: python:3.11-slim
  setup: |
    pip install google-adk
    cp -r /agent/* /workspace/
```

Create `adk-analyzer/agents.md` and `adk-analyzer/system-prompt.md` following the template triad pattern.

### Step 3: Deploy and Test (10 min)

```bash
# Install the template
cp -r adk-analyzer .scion/templates/

# Start the ADK agent alongside a Gemini CLI agent
scion start analyzer "Analyze all Python files in this project" --type adk-analyzer
scion start reviewer "Review the analysis findings" --type security-auditor

# Both agents run in the same grove, managed by the same Scion instance
scion list
```

## Success Criteria

- [ ] ADK agent created with `sciontool` status reporting
- [ ] Template packaged with scion-agent.yaml + agents.md + system-prompt.md
- [ ] Agent deployed into a Scion grove
- [ ] Running alongside a Gemini CLI agent in the same grove

## Key Takeaway

Scion doesn't care what runs inside the container — Gemini CLI, Claude Code, or a custom Python agent. The orchestration layer is harness-agnostic. This means you can mix-and-match agent technologies within the same team.
