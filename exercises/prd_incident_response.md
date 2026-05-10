# Exercise: Incident Response Triage

## Objective

Use a multi-agent team to diagnose and remediate a simulated production incident on ProShop.

## Duration

20 minutes

## The Scenario

🚨 **ALERT:** ProShop's checkout endpoint (`POST /api/orders`) is returning HTTP 500 errors. Customer reports indicate orders are failing intermittently.

## Instructions

### Step 1: Deploy the Incident Commander (5 min)

```bash
scion start incident-commander "INCIDENT ALERT: ProShop checkout endpoint POST /api/orders is returning 500 errors intermittently. Customer reports indicate order creation fails.

Your job as incident commander:
1. Start a log-investigator agent to analyze error handling and logging in the order creation flow
2. Start a config-investigator agent to check environment configs, database connection settings, and dependency versions
3. After investigation, start a fixer agent to propose a remediation
4. After the fix is proposed, start a reviewer agent to validate the fix is safe
5. Compile a final INCIDENT_REPORT.md with: root cause, timeline, remediation, and preventive measures" --type incident-commander
```

### Step 2: Watch the Team Assemble (5 min)

```bash
# Watch agents spawn
scion list

# Follow the log investigator
scion attach log-investigator

# Check the config investigator
scion attach config-investigator
```

### Step 3: Review the Fix (5 min)

```bash
# See what the fixer proposed
scion attach fixer

# Watch the reviewer challenge it
scion attach reviewer
```

### Step 4: Read the Incident Report (5 min)

```bash
cat INCIDENT_REPORT.md
```

Evaluate:

- Did the team identify a plausible root cause?
- Is the proposed fix targeted (not a shotgun approach)?
- Did the reviewer raise valid concerns?
- Is the incident report complete (root cause, timeline, remediation, prevention)?

## Success Criteria

- [ ] Incident commander spawned worker agents
- [ ] Parallel investigation (log + config) completed
- [ ] Fixer proposed a specific remediation
- [ ] Reviewer challenged the fix with safety concerns
- [ ] Incident report generated

## Extension: Automate It

```bash
# Wire to a webhook:
# PagerDuty → scion start incident-commander "$ALERT_PAYLOAD" --type incident-commander
# Poll → collect findings → post to Slack
```

## Discussion

1. Would you trust this automated triage to run without human supervision? Why or why not?
2. What guardrails would you add before deploying this to production?
3. How does the adversarial reviewer pattern change your confidence in the fix?
