# Scion Multi-Agent Orchestration Workshop

> **Operationalize multi-agent orchestration across your SDLC with [Scion](https://github.com/GoogleCloudPlatform/scion) — the hypervisor for AI coding agents.**

📖 **Workshop Site:** [pauldatta.github.io/scion-field-workshop](https://pauldatta.github.io/scion-field-workshop/)

⚠️ **Alpha Software:** Scion is pre-release. This workshop focuses on stable local-mode features. Hub and Kubernetes runtime are covered as experimental/advanced topics.

## Workshop Overview

This hands-on workshop teaches enterprise developers how to design, run, and govern fleets of AI coding agents using Scion's container-based orchestration. It extends the foundations covered in the [Gemini CLI Field Workshop](https://github.com/pauldatta/gemini-cli-field-workshop) from single-agent to multi-agent patterns.

### What You'll Learn

| Module | Duration | Core Skill |
|---|---|---|
| **1. Multi-Agent SDLC** | 100 min | Parallel dev, migration pipelines, fan-out audits, incident response |
| **2. Agent Team Architecture** | 60 min | Orchestrator pattern, communication topology, adversarial review |
| **3. Enterprise Governance** | 35 min | Container isolation, observability, governance controls |
| **4. Advanced** *(extended)* | Variable | Hub architecture, ADK agents, A2A protocol, Google Chat |

**Total workshop: ~3.5 hours (half-day)**

### Target Audience

- Platform engineers evaluating multi-agent orchestration
- Solution architects designing agent-powered SDLC pipelines
- Technical leads operationalizing AI coding agents at scale
- DevOps engineers integrating agents into CI/CD workflows

### Prerequisites

- Completed at least Module 1 (SDLC) of the [Gemini CLI Field Workshop](https://github.com/pauldatta/gemini-cli-field-workshop)
- Familiarity with Git, Docker, and terminal workflows
- Pre-work completed: [Environment Setup](docs/setup.md)

## Quick Start

```bash
# Clone the workshop
git clone <workshop-repo-url>
cd scion-public-workshop

# Check prerequisites and build Scion
make check-env

# Install MkDocs and serve docs
make install-deps
make serve
```

## Repository Structure

```
├── docs/                    # Workshop documentation (MkDocs Material)
├── exercises/               # Hands-on PRDs (6 exercises)
├── samples/                 # Ready-to-use agent templates and configs
│   ├── templates/           # 6 agent template directories
│   ├── config/              # Sample grove settings
│   └── orchestration/       # Workflow definitions
├── scripts/                 # Validation and setup scripts
├── Makefile                 # Build, test, and serve targets
└── mkdocs.yml               # MkDocs Material configuration
```

## Delivery Options

| Format | Content | Duration |
|---|---|---|
| ⚡ Lightning | Module 1 (selected scenarios) | 1.5 hrs |
| 📋 Standard | Modules 1 + 2 | 2.5 hrs |
| 📦 Full | All three core modules | 3.5 hrs |
| 🏗️ Extended | All modules + Advanced hands-on | 5–6 hrs |

See the [Facilitator Guide](docs/facilitator-guide.md) for detailed delivery instructions.

## Maintenance

- [CHANGELOG](CHANGELOG.md) — Version history and breaking changes
- [CONTRIBUTING](CONTRIBUTING.md) — Development setup and content guidelines

---

*Built with [MkDocs Material](https://squidfundamentals.github.io/mkdocs-material/). Workshop content based on [Scion](https://github.com/GoogleCloudPlatform/scion) by Google Cloud Platform.*
