# Module 3: Enterprise Governance & Observability <span class="duration-badge">35 min</span>

> **"Cool demo, but my CISO will ask: how do I audit what these agents did?"** This module covers the security model, observability stack, and governance controls that make Scion enterprise-ready.

---

## 3.1 — The Isolation Model <span class="duration-badge">10 min</span>

Scion's security model is built on a single principle: **Isolation Over Constraints**.

Instead of trying to constrain what an agent can do (allowlists, blocklists, sandboxed commands), Scion gives each agent **full freedom inside a disposable container**. The container *is* the guardrail.

### What Each Agent Gets

| Resource | Isolation Level | How |
|---|---|---|
| **Filesystem** | Full isolation | Each agent gets its own git worktree. Shadow mounts (tmpfs) hide `.scion/` and other agents' work |
| **Home directory** | Per-agent | `$HOME` is unique per agent — no shared shell history, config, or credentials |
| **Credentials** | Scoped injection | Only credentials the template specifies are mounted into the container |
| **Network** | Container-level | Standard container networking — no host network by default |
| **Process space** | Full isolation | Container PID namespace — agents can't see each other's processes |

### Shadow Mounts: The Key Mechanism

```
Host filesystem:
├── .scion/           ← grove config, templates, agent state
├── src/
│   ├── main.py
│   └── utils.py
└── tests/

Agent's view (inside container):
├── .scion/           ← HIDDEN (tmpfs shadow mount)
├── src/
│   ├── main.py       ← visible (worktree copy)
│   └── utils.py
└── tests/
```

Agents can't see `.scion/`, can't access other agents' worktrees, and can't read grove configuration. They work on their own copy of the code.

### Why "YOLO Mode" Is Safe

!!! info "Philosophy: Isolation Over Constraints"
    In traditional agent frameworks, you restrict what the agent can do: "only modify files in `src/`", "don't run `rm -rf`", "don't install packages."

    Scion takes the opposite approach: **let the agent do anything it wants** — inside a container. If it runs `rm -rf /`, it destroys its own container. The host, the grove, and other agents are untouched.

    This is why Scion agents can operate in "YOLO mode" (no confirmation prompts) safely. The container is the sandbox.

---

## 3.2 — Agent State & Observability <span class="duration-badge">10 min</span>

Every Scion agent reports state along three dimensions:

### The State Model

| Dimension | What It Tracks | Values |
|---|---|---|
| **Phase** | Infrastructure lifecycle | `provisioning` → `running` → `done` / `failed` |
| **Activity** | Cognitive state | `idle`, `thinking`, `tool_use`, `waiting` |
| **Detail** | Context | Free-text description of current work |

```bash
# See the full state of all agents
scion list --format json | jq '.[] | {name, phase, activity, detail}'
```

```json
{
  "name": "sec-reviewer",
  "phase": "running",
  "activity": "tool_use",
  "detail": "Scanning auth middleware for JWT validation issues"
}
```

### Monitoring Your Fleet

```bash
# Live status
scion list

# Agent logs
scion logs sec-reviewer

# Structured output for scripting
scion list --format json
```

### OpenTelemetry Integration

Scion normalizes telemetry across harnesses. Whether an agent runs Gemini CLI, Claude Code, or an ADK agent, the traces use the same schema:

| Signal | What It Captures |
|---|---|
| **Traces** | Agent lifecycle events (start, tool calls, completion) |
| **Spans** | Individual LLM calls, file operations, command execution |
| **Attributes** | Agent name, template, harness, grove ID |

### Agent Visualization

The `agent-viz` tool (in `extras/agent-viz/`) provides a force-directed graph replay of multi-agent sessions:

- Real-time visualization of agent spawn, communication, and completion
- Playback controls for post-session review
- Powered by GCP Logging + WebSocket streaming

!!! info "Demo"
    If the facilitator has a pre-recorded session, this is a powerful visual — watching a multi-agent incident response unfold as an animated graph.

---

## 3.3 — Governance Controls <span class="duration-badge">15 min</span>

### Grove-Level Settings

The `settings.yaml` file provides governance controls at the grove level:

```yaml
# .scion/settings.yaml
governance:
  max_turns: 50           # Maximum LLM interaction turns per agent
  max_duration: 30m       # Maximum runtime per agent
  auto_cleanup: true      # Clean up containers after completion
  
harness_defaults:
  gemini:
    model: gemini-2.5-pro  # Default model for Gemini CLI harness
```

### Hands-On: Feel the Guardrail

```bash
# Edit settings to set a low limit
# .scion/settings.yaml → max_turns: 5

# Start an agent with a complex task
scion start test-agent "Refactor the entire ProShop authentication system" --type test-engineer

# Watch it hit the limit
scion attach test-agent
# Agent will stop after 5 turns with a governance limit message
```

!!! tip "Why This Matters"
    Without `max_turns`, a confused agent can spin indefinitely — burning tokens and producing garbage. Governance controls are your **cost and quality guardrails**.

### Agent Ancestry Chains

When an orchestrator spawns worker agents, Scion tracks the parent-child relationship:

```
incident-commander (parent)
├── log-investigator (child)
├── config-investigator (child)
├── fixer (child, spawned after investigation)
└── reviewer (child, spawned after fix)
```

This ancestry chain enables **transitive access control** — a child agent inherits (at most) the permissions of its parent. An agent can't escalate privileges by spawning a more privileged child.

### Template-Level vs Infrastructure-Level Guardrails

| Layer | Controls | Example |
|---|---|---|
| **Template** | What the agent *should* do | `agents.md`: "You are READ-ONLY. Do not modify files." |
| **Infrastructure** | What the agent *can* do | `settings.yaml`: `max_turns: 50`, credential scoping |

Template guardrails rely on the LLM following instructions (soft). Infrastructure guardrails are enforced by the container runtime (hard). Use both:

- Template guardrails for **intent** (read-only reviewer, specific file focus)
- Infrastructure guardrails for **limits** (max runtime, max turns, credential scope)

---

## Module 3 Key Takeaways

1. **Isolation is the security model.** Containers, not allowlists. Agents get full freedom inside a disposable sandbox.
2. **Three-dimensional state model.** Phase × Activity × Detail gives you fleet-wide observability.
3. **Governance = cost + quality control.** `max_turns` and `max_duration` prevent runaway agents and token burn.
4. **Ancestry chains = audit trails.** Who spawned whom, with what permissions — the compliance story.
5. **Two layers of guardrails.** Template (soft, intent) + infrastructure (hard, limits). Use both.
