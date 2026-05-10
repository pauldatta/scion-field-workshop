# Exercise: Fan-Out Code Audit

## Objective

Dispatch 4 specialized audit agents against ProShop in parallel, then synthesize their findings.

## Duration

20 minutes

## Instructions

### Step 1: Launch the Audit Team (5 min)

```bash
scion start sec-audit "Audit ProShop for security vulnerabilities. Check for:
- XSS (unescaped user input in React renders)
- CSRF (missing token validation)
- Injection (NoSQL injection in MongoDB queries)
- Auth bypasses (missing auth middleware on protected routes)
- Insecure dependencies (known CVEs in package.json)
Output all findings to SECURITY_AUDIT.md with severity ratings." --type security-auditor

scion start perf-audit "Profile ProShop for performance issues. Check for:
- N+1 queries (multiple DB calls in loops)
- Missing database indexes
- Memory leaks (event listener cleanup, unclosed connections)
- Inefficient React renders (unnecessary re-renders, missing memo)
- Large bundle size contributors
Output findings to PERF_AUDIT.md with impact ratings." --type test-engineer

scion start docs-audit "Assess ProShop documentation. Check for:
- Missing API endpoint documentation
- Undocumented React components (no PropTypes/JSDoc)
- Stale README sections
- Missing setup/deployment instructions
- Absent CONTRIBUTING guidelines
Output findings to DOCS_AUDIT.md." --type docs-writer

scion start test-audit "Analyze ProShop test coverage. Check for:
- Untested API endpoints
- Missing edge case tests
- Absent integration tests
- No error path testing
- Missing component render tests
Output findings to TEST_AUDIT.md with priority ratings." --type test-engineer
```

### Step 2: Monitor Progress (5 min)

```bash
scion list
# Attach to any agent to observe
scion attach sec-audit
```

### Step 3: Synthesize Findings (10 min)

After all agents complete:

```bash
# Read each report
cat scion/sec-audit/SECURITY_AUDIT.md
cat scion/perf-audit/PERF_AUDIT.md
cat scion/docs-audit/DOCS_AUDIT.md
cat scion/test-audit/TEST_AUDIT.md
```

**Cross-agent analysis:**

- Did the security agent find issues the test agent should have caught?
- Did the perf agent identify bottlenecks the security agent flagged as vulnerabilities?
- Are there patterns that multiple agents independently identified?

## Success Criteria

- [ ] 4 agents ran in parallel
- [ ] Each produced a structured findings report
- [ ] Cross-agent insights identified
- [ ] At least 3 actionable findings discovered

## Discussion

Multi-agent audits surface more issues than any single agent because each specialist brings a different lens. The **synthesis step** is where the real value emerges.
