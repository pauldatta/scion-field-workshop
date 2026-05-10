# Module 1: Multi-Agent SDLC <span class="duration-badge">100 min</span>

> **From one agent to a fleet.** This module applies multi-agent orchestration to five real SDLC scenarios — parallel development, migration pipelines, code audits, merge workflows, and incident response.

---

## Fundamentals Speed-Run <span class="duration-badge">15 min</span>

!!! info "Bridge from Single-Agent to Multi-Agent"
    You already know how to use Gemini CLI as a single agent ([Gemini CLI Field Workshop](https://github.com/pauldatta/gemini-cli-field-workshop)). Scion turns that single agent into a fleet — each agent running in its own container with its own git worktree.

### Core Concepts in 60 Seconds

| Concept | What It Is | GKE Analogy |
|---|---|---|
| **Grove** | Project workspace (`.scion/` directory) | Cluster |
| **Agent** | Isolated container running an LLM harness | Pod |
| **Template** | Blueprint for creating agents | Deployment |
| **Worktree** | Git worktree — each agent gets its own branch | PersistentVolume |
| **Harness** | Adapter for a specific LLM tool (Gemini CLI, Claude, etc.) | Container runtime |

### Hands-On: Your First Grove

```bash
# Navigate to the demo app
cd demo-app

# Initialize a Scion grove
scion init

# Start your first agent and attach to it
scion start explorer "Analyze this codebase and summarize the architecture" --attach
```

Observe: the container spinning up, worktree creation, the agent running inside isolation.

```bash
# Detach from the agent (keep it running)
# Press: Ctrl+B, then D

# See it running
scion list

# Check available templates
scion templates list
```

!!! tip "Template Anatomy"
    Every template is a directory with three files:

    - `scion-agent.yaml` — configuration (harness, settings, environment)
    - `agents.md` — role description and workflow instructions
    - `system-prompt.md` — the agent's system prompt

    This triad is the building block of everything in Scion.

---

## 1.1 — Parallel Feature Build <span class="duration-badge">20 min</span>

> **Pattern: Parallel Execution** — Multiple agents working simultaneously on different aspects of the same feature.

### The Scenario

Build a product rating feature for ProShop with three agents working in parallel:

```bash
# Start three agents — each gets its own worktree branch
scion start backend-dev "Add a product rating API endpoint with POST /api/products/:id/ratings and GET /api/products/:id/ratings. Use MongoDB for storage." --type test-engineer

scion start frontend-dev "Create a star-rating React component that displays average rating and allows users to submit ratings via the API." --type test-engineer

scion start test-writer "Write integration tests for the product rating feature covering both API endpoints and the React component rendering." --type test-engineer
```

### Observe the Fleet

```bash
# See all three agents running
scion list

# Attach to one to watch it work
scion attach backend-dev

# Detach (Ctrl+B, D) and check another
scion attach frontend-dev
```

!!! tip "The Wow Moment"
    Watch three agents coding simultaneously on the same codebase — each on its own isolated git branch, unable to interfere with each other. This is Scion's core value: **parallel execution with isolation**.

### What Just Happened?

```bash
# Each agent created its own worktree branch
git branch
# * main
#   scion/backend-dev
#   scion/frontend-dev
#   scion/test-writer
```

Three independent branches, three independent working directories, three agents producing code in parallel.

---

## 1.2 — Migration Pipeline <span class="duration-badge">25 min</span>

> **Pattern: Sequential Orchestration** — Agents executing in order, each building on the previous agent's output.

### The Scenario

Migrate ProShop's Express.js error handling to use a centralized error middleware. Three agents execute in sequence:

```bash
# Stage 1: Investigator (read-only analysis)
scion start investigator "Analyze all error handling patterns in the ProShop Express.js backend. Document every try/catch, error response, and inconsistency. Output a structured migration plan to MIGRATION_PLAN.md." --type security-auditor
```

!!! warning "Inter-Stage Validation"
    **Don't rush to the next stage.** After the investigator completes, read its `MIGRATION_PLAN.md` together. Ask: "Did it find all the error handling patterns? Did it miss the middleware chain?" This is the critical skill — **validating agent output before passing it downstream**.

```bash
# Stage 2: Migrator (applies changes based on investigation)
scion start migrator "Read MIGRATION_PLAN.md and implement the centralized error handling middleware. Refactor all routes to use next(error) instead of inline try/catch." --type migration-lead

# Stage 3: Test writer (validates the migration)
scion start test-writer "Write tests that verify the centralized error middleware handles all error types documented in MIGRATION_PLAN.md. Include edge cases for malformed requests and database errors." --type test-engineer
```

### Key Takeaway

Sequential pipelines require **checkpoints between stages**. The investigator's output is the migrator's input — garbage in, garbage out. Validate at every hand-off.

---

## 1.3 — Fan-Out Code Audit <span class="duration-badge">20 min</span>

> **Pattern: Fan-Out Parallel** — Dispatch N specialized agents to cover N concerns simultaneously.

### The Scenario

Run a comprehensive codebase audit with four specialized agents:

```bash
scion start sec-audit "Audit ProShop for security vulnerabilities: XSS, CSRF, SQL injection, insecure dependencies, authentication bypasses. Output findings to SECURITY_AUDIT.md." --type security-auditor

scion start perf-audit "Profile ProShop for performance issues: N+1 queries, unindexed database lookups, memory leaks, inefficient React renders. Output findings to PERF_AUDIT.md." --type test-engineer

scion start docs-audit "Assess ProShop documentation coverage: missing API docs, undocumented components, stale README sections. Output findings to DOCS_AUDIT.md." --type docs-writer

scion start test-audit "Analyze ProShop test coverage gaps: untested API endpoints, missing edge cases, absent integration tests. Output findings to TEST_AUDIT.md." --type test-engineer
```

### Synthesize Findings

After all agents complete, compare their reports:

```bash
# Check completion status
scion list

# Compare findings across agents
cat scion/sec-audit/SECURITY_AUDIT.md
cat scion/perf-audit/PERF_AUDIT.md
cat scion/docs-audit/DOCS_AUDIT.md
cat scion/test-audit/TEST_AUDIT.md
```

!!! tip "Cross-Agent Insights"
    Often one agent's findings inform another's blind spot. The security agent may find an auth bypass that the test agent missed — but the test agent may find edge cases the security agent didn't consider. **Multi-agent audits are more than the sum of their parts.**

---

## 1.4 — Merge, Verify, Ship <span class="duration-badge">15 min</span>

> **Pattern: Branch-per-Agent Merge Workflow**

### Merging Agent Work

Every agent works on an isolated git worktree branch. To integrate their work:

```bash
# List all agent branches
git branch | grep scion/

# Merge the backend agent's work
git merge scion/backend-dev

# Merge the frontend agent's work
git merge scion/frontend-dev

# Merge the test agent's work
git merge scion/test-writer
```

### Handling Conflicts

When agents modify the same files (e.g., both backend and frontend agents touch `package.json`), Git presents standard merge conflicts. Review and resolve them manually — the agent's worktree branches are your audit trail.

### Git History: Clean Branch-per-Agent Model

```bash
git log --oneline --graph --all
# * abc1234 Merge branch 'scion/test-writer'
# |\
# | * def5678 Add integration tests for rating feature
# * | ghi9012 Merge branch 'scion/frontend-dev'
# |\ \
# | * | jkl3456 Create star-rating React component
# * | | Merge branch 'scion/backend-dev'
# |\ \ \
# | * | | mno7890 Add rating API endpoint
```

Every agent's contribution is traceable, reviewable, and revertable.

### CI/CD Integration

In a real pipeline, Scion agents can be triggered by CI events:

```yaml
# .github/workflows/scion-review.yml (conceptual)
on: [pull_request]
jobs:
  agent-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Scion code review
        run: |
          scion init
          scion start reviewer "Review this PR for quality issues" --type security-auditor
          # Poll for completion, collect findings
```

---

## 1.5 — Incident Response Triage <span class="duration-badge">20 min</span>

> **The DevOps Use Case:** Agents solving a production problem, not just writing code.

### The Scenario

🚨 **Alert:** ProShop's checkout endpoint is returning HTTP 500 errors in production. The incident commander dispatches a team to diagnose and remediate.

| Agent | Role | Task |
|---|---|---|
| `incident-commander` | Orchestrator | Coordinate investigation, synthesize diagnosis, approve remediation |
| `log-investigator` | Worker | Analyze error handling, stack traces, logging patterns |
| `config-investigator` | Worker | Check environment configs, Dockerfiles, dependency versions |
| `fixer` | Worker | Propose a targeted fix based on investigation findings |
| `reviewer` | Adversarial | Review the fix — "Is this safe? Will it break anything else?" |

### Dispatch the Team

```bash
# The incident commander coordinates the response
scion start incident-commander "ALERT: ProShop checkout endpoint returning 500 errors. Coordinate a team investigation: dispatch a log investigator and config investigator in parallel, then have a fixer propose remediation, and a reviewer validate the fix before approval." --type incident-commander
```

!!! tip "Orchestrator-Driven Dispatch"
    In a well-configured `incident-commander` template, the orchestrator agent itself spawns the worker agents using `scion start`. The commander's `agents.md` defines the available roles and workflow. You start one agent — it builds the team.

### Watch the Triage Unfold

```bash
# Watch the team spin up
scion list

# Attach to the log investigator
scion attach log-investigator

# Check the config investigator
scion attach config-investigator

# See the fixer's proposed remediation
scion attach fixer

# Watch the reviewer challenge the fix
scion attach reviewer
```

### The Adversarial Review Pattern

The `reviewer` agent's job is to **challenge** the fixer:

- "Does this fix address the root cause or just the symptom?"
- "What's the blast radius if this fix introduces a regression?"
- "Are there any untested edge cases in this remediation?"

This pattern — **fixer + adversarial reviewer** — is critical for any high-stakes DevOps automation.

### From Interactive to Automated

!!! info "DevOps Callout: Headless Automation"
    Everything you just did interactively can be scripted:

    ```bash
    # Trigger from PagerDuty webhook
    scion start incident-commander "$ALERT_PAYLOAD" --type incident-commander

    # Poll for completion
    while scion list --format json | jq '[.[] | select(.phase != "done")] | length > 0' -e &>/dev/null; do
      sleep 10
    done

    # Collect findings
    scion list --format json | jq '.[] | {name, phase, activity}'
    ```

    Wire this to a PagerDuty webhook and you have automated incident triage. The agents investigate while your on-call engineer gets context — not a raw alert.

---

## Module 1 Exercises

<div class="exercise-card" markdown>

#### :material-file-document: Exercise: Parallel Feature Build

**File:** `exercises/prd_parallel_feature.md`
**Duration:** 20 min
**Objective:** Build a new ProShop feature using 3 parallel agents (backend, frontend, test).

</div>

<div class="exercise-card" markdown>

#### :material-file-document: Exercise: Migration Pipeline

**File:** `exercises/prd_migration_pipeline.md`
**Duration:** 25 min
**Objective:** Run a sequential migration pipeline with inter-stage validation.

</div>

<div class="exercise-card" markdown>

#### :material-file-document: Exercise: Fan-Out Code Audit

**File:** `exercises/prd_fanout_audit.md`
**Duration:** 20 min
**Objective:** Dispatch 4 specialized audit agents and synthesize their findings.

</div>

<div class="exercise-card" markdown>

#### :material-file-document: Exercise: Incident Response Triage

**File:** `exercises/prd_incident_response.md`
**Duration:** 20 min
**Objective:** Run a multi-agent incident response with orchestrator, investigators, fixer, and reviewer.

</div>
