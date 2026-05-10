---
hide:
  - navigation
  - toc
---

# Scion Multi-Agent Orchestration Workshop

<div style="text-align: center; margin: 2rem 0;">
  <p style="font-size: 1.3rem; color: var(--md-default-fg-color--light);">
    Go from running <strong>one agent</strong> to orchestrating <strong>a fleet</strong> — in 3.5 hours.
  </p>
</div>

---

## Workshop Modules

<div class="grid cards" markdown>

-   :material-rocket-launch:{ .lg .middle } **Module 1 — Multi-Agent SDLC**

    ---

    Parallel feature builds, migration pipelines, fan-out code audits, and incident response triage. Five SDLC scenarios powered by agent fleets.

    [:octicons-arrow-right-24: Start Module 1](multi-agent-sdlc.md)

-   :material-sitemap:{ .lg .middle } **Module 2 — Agent Team Architecture**

    ---

    Design multi-agent systems: orchestrator patterns, communication topology, adversarial review. Capstone: build a multi-agent PR Review Board.

    [:octicons-arrow-right-24: Start Module 2](team-architecture.md)

-   :material-shield-check:{ .lg .middle } **Module 3 — Enterprise Governance**

    ---

    Container isolation, agent state observability, OpenTelemetry, and governance controls. How to trust agents in production.

    [:octicons-arrow-right-24: Start Module 3](governance.md)

-   :material-telescope:{ .lg .middle } **Advanced — Hub & Ecosystem**

    ---

    Hub architecture, ADK agent integration, A2A protocol bridge, Google Chat integration, and custom harness development.

    [:octicons-arrow-right-24: Explore Advanced](advanced-patterns.md)

</div>

---

## Workshop Timeline

| Time | Content | Duration |
|---|---|---|
| `0:00` | Fundamentals speed-run | 15 min |
| `0:15` | **Module 1:** Multi-Agent SDLC | 100 min |
| `1:55` | :coffee: Break | 10 min |
| `2:05` | **Module 2:** Team Architecture | 60 min |
| `3:05` | **Module 3:** Enterprise Governance | 35 min |
| `3:40` | Wrap-up & Q&A | 10 min |

---

## Before You Start

!!! warning "Pre-Work Required"
    Complete the [Environment Setup](setup.md) before the workshop. You'll need Go, Docker, and a working Scion installation.

!!! info "Prerequisite Workshop"
    This workshop extends the [Gemini CLI Field Workshop](https://github.com/pauldatta/gemini-cli-field-workshop). Attendees should have completed at least Module 1 (SDLC Productivity) for single-agent foundations.

!!! danger "Alpha Software"
    Scion is pre-release software. APIs and features may change between versions. This workshop focuses on stable local-mode features. Hub and Kubernetes runtime are covered as experimental topics.
