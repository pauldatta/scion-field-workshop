# Facilitator Guide

This guide provides delivery instructions for the Scion Multi-Agent Orchestration Workshop.

---

## Pre-Workshop (1 Week Before)

### Send to Attendees

- [ ] **Setup instructions** — link to [Environment Setup](setup.md)
- [ ] **Pre-work verification checklist** — `scion --version`, `docker ps`, `scion list`
- [ ] **Prerequisite reminder** — attendees should have completed at least Module 1 of the [Gemini CLI Field Workshop](https://github.com/pauldatta/gemini-cli-field-workshop)
- [ ] **Slack/Chat channel** — for pre-workshop troubleshooting

### Facilitator Preparation

- [ ] Run `make check-env` on your delivery machine
- [ ] Pre-pull all container images
- [ ] Test all exercises end-to-end
- [ ] Pre-create a grove with the demo app for live demos
- [ ] Prepare a pre-recorded `agent-viz` session for Module 3.2

---

## Delivery Options

| Format | Modules | Duration | Best For |
|---|---|---|---|
| ⚡ **Lightning** | Fundamentals + Module 1 (selected) | 1.5 hrs | Conference talk, lunch-and-learn |
| 📋 **Standard** | Fundamentals + Modules 1 + 2 | 2.5 hrs | Customer engagement, team training |
| 📦 **Full** | All three core modules | 3.5 hrs | Half-day workshop, deep dive |
| 🏗️ **Extended** | All modules + Advanced hands-on | 5–6 hrs | Full-day workshop |

---

## Detailed Timing (Full Format)

| Time | Section | Duration | Facilitator Notes |
|---|---|---|---|
| `0:00` | **Fundamentals Speed-Run** | 15 min | Use GKE/K8s analogies. Don't over-explain — the audience gets fleet management. Live demo: `scion init`, `scion start`, `scion list` |
| `0:15` | **1.1 Parallel Feature Build** | 20 min | **This is the wow moment.** Start 3 agents, attach to each in turn. Let the audience see agents coding simultaneously |
| `0:35` | **1.2 Migration Pipeline** | 25 min | Pause between stages. Read the investigator's output together before starting the migrator. Teach inter-stage validation |
| `1:00` | **1.3 Fan-Out Code Audit** | 20 min | Most visual section. 4 agents running in parallel, compare findings afterward |
| `1:20` | **1.4 Merge, Verify, Ship** | 15 min | Lighter section — mostly conceptual with a live merge demo. Good pace break |
| `1:35` | **1.5 Incident Response** | 20 min | **DevOps hook.** The incident scenario resonates with ops engineers. End with the headless automation callout |
| `1:55` | **☕ Break** | 10 min | |
| `2:05` | **2.1 Orchestrator Pattern** | 10 min | Conceptual — use the mermaid diagrams. Anti-pattern vs pattern comparison |
| `2:15` | **2.2 Communication Topology** | 10 min | Live demo of `scion message` and `scion message --broadcast` |
| `2:25` | **2.3 Adversarial Review** | 10 min | Connect back to 1.5 reviewer agent. "Remember the reviewer that challenged the fixer?" |
| `2:35` | **2.4 PR Review Board** | 30 min | **Deepest hands-on.** Attendees write templates. Allow time for iteration. This is the skill they take home |
| `3:05` | **3.1 Isolation Model** | 10 min | The "YOLO mode is safe because containers" message is counterintuitive — lean into it |
| `3:15` | **3.2 Observability** | 10 min | Show `scion list --format json` piped through jq. If you have agent-viz pre-recorded, show it here |
| `3:25` | **3.3 Governance Controls** | 15 min | **Hands-on:** attendees edit `settings.yaml`, set `max_turns: 5`, watch an agent hit the limit |
| `3:40` | **Wrap-up** | 10 min | Recap key patterns, point to Advanced section, collect feedback |

---

## Demo Tips

### High-Impact Moments

1. **Module 1.1 — Three agents coding simultaneously** is the "wow moment." Let the audience absorb it. Attach to each agent briefly — don't rush.

2. **Module 1.5 — Incident response** resonates with DevOps engineers. The PagerDuty webhook callout at the end always generates discussion.

3. **Module 2.4 — PR Review Board** is the deepest hands-on. If you're running a Lightning format, skip to this as the capstone.

4. **Module 3.3 — `max_turns: 5`** gets a laugh when the agent stops mid-sentence. Then the audience realizes it's the cost control mechanism.

### Agent Startup Latency

Scion agents take 30-60 seconds to start (container provisioning, worktree creation). During this time:

- Explain what's happening (container build, volume mounts, git worktree checkout)
- Use `scion list` to show the agent transitioning through phases
- This latency is a teaching moment: "This is the cost of isolation"

### Handling Failures

| Failure | Recovery |
|---|---|
| Agent doesn't start | Check `docker ps`, verify images are built. `scion logs <name>` for details |
| Agent produces poor output | This is a teaching moment — "How do we improve the system prompt?" |
| Merge conflicts | Expected! Walk through resolution as a team |
| Docker OOM | Reduce parallel agents. 2 agents is usually fine on 16GB machines |
| Auth token expires | `scion stop <name>`, re-auth, `scion start` again |

---

## Lightning Format (1.5 hrs)

For conference slots, focus on impact:

| Time | Content | Duration |
|---|---|---|
| `0:00` | Fundamentals + live demo | 15 min |
| `0:15` | 1.1 Parallel Feature Build (live) | 20 min |
| `0:35` | 1.3 Fan-Out Audit (live) | 20 min |
| `0:55` | 2.4 PR Review Board (guided walkthrough) | 25 min |
| `1:20` | Wrap-up + Advanced preview | 10 min |

Skip 1.2 (sequential pipeline) and 1.4 (merge) — they're important but not as visually impactful.

---

## Relationship to Gemini CLI Field Workshop

This workshop is designed as a **direct extension** of the [Gemini CLI Field Workshop](https://github.com/pauldatta/gemini-cli-field-workshop):

| Gemini CLI Workshop | Scion Workshop |
|---|---|
| Single-agent workflows | Multi-agent orchestration |
| GEMINI.md context engineering | Template triad (`scion-agent.yaml` + `agents.md` + `system-prompt.md`) |
| Interactive mode | Interactive + orchestrator-driven |
| One branch, one agent | Branch-per-agent worktree model |
| Manual code review | Multi-agent adversarial review |

**Positioning:** "You learned to drive one car. Now you're learning to manage a fleet."
