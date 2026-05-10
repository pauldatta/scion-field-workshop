# Exercise: Multi-Agent PR Review Board

## Objective

Design and run a complete multi-agent PR review team. Build 4 templates from scratch, execute a parallel review against ProShop, and iterate on system prompts based on results.

## Duration

30 minutes

## Instructions

### Step 1: Create the Templates (10 min)

Create four template directories in `.scion/templates/`:

#### review-lead/ (Orchestrator)

**scion-agent.yaml:**
```yaml
name: review-lead
description: "PR review orchestrator — coordinates specialist reviewers"
harness: gemini
```

**agents.md:**
```markdown
# PR Review Lead

## Available Roles
- security-reviewer: Scans for security vulnerabilities
- performance-reviewer: Identifies performance issues  
- architecture-reviewer: Evaluates design and architecture

## Workflow
1. Identify all recently modified files
2. Start all three reviewer agents in parallel
3. Wait for all reviewers to complete their findings
4. Read each reviewer's output file
5. Synthesize a unified verdict: APPROVE, REQUEST_CHANGES, or BLOCK
6. Write verdict to PR_VERDICT.md

## Verdict Rules
- Any CRITICAL finding → BLOCK
- Any HIGH finding → REQUEST_CHANGES
- Only LOW/MEDIUM findings → APPROVE
```

**system-prompt.md:**
```markdown
You are a senior engineering lead conducting a code review. Coordinate your team of specialist reviewers and synthesize their findings into a clear, actionable verdict. Be thorough but fair — not every finding warrants blocking.
```

#### security-reviewer/ (Adversarial Worker)

Create with READ-ONLY constraint. Focus on: XSS, injection, auth bypasses, insecure dependencies.

#### performance-reviewer/ (Adversarial Worker)

Create with READ-ONLY constraint. Focus on: N+1 queries, memory leaks, unnecessary re-renders, bundle size.

#### architecture-reviewer/ (Adversarial Worker)

Create with READ-ONLY constraint. Focus on: coupling, naming, separation of concerns, design patterns.

### Step 2: Install Templates (2 min)

```bash
# Copy to grove templates
cp -r samples/templates/review-lead .scion/templates/
# (Repeat for each reviewer template you created)

# Verify
scion templates list
```

### Step 3: Run the Review (10 min)

```bash
scion start review-lead "Review all code in this repository for quality, security, and architecture. Focus on the product-related features." --type review-lead

# Watch the team assemble
scion list

# Observe individual reviewers
scion attach security-reviewer
scion attach performance-reviewer
```

### Step 4: Iterate (8 min)

Read `PR_VERDICT.md`:

- Was the verdict reasonable?
- Did any reviewer miss obvious issues?
- Did any reviewer produce false positives?

**Improve the system prompt:** If the security reviewer missed a class of vulnerability, update `security-reviewer/system-prompt.md` and re-run. This iterative refinement is the core skill.

## Success Criteria

- [ ] 4 templates created with the scion-agent.yaml + agents.md + system-prompt.md triad
- [ ] Review board ran with orchestrator + 3 parallel reviewers
- [ ] Unified PR_VERDICT.md produced with severity-based verdict
- [ ] At least one template refined based on initial results

## Extension

Adapt the review board for your own domain:

- **Incident response triage panel** — security + infra + comms reviewers
- **Release readiness check** — changelog + migration + test reviewers
- **Architecture decision review** — proposer + devil's advocate + estimator
