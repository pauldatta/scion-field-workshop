# Sequential Pipeline Pattern

Adapted from `examples/orchestration-basics/sequence/` in the Scion source.

## Pattern

Execute agents in strict order, each building on the previous agent's output:

```bash
# Stage 1: Analysis
scion start analyst "Analyze the codebase and output findings to ANALYSIS.md"
# Wait for completion...

# Stage 2: Implementation (reads ANALYSIS.md)
scion start implementer "Read ANALYSIS.md and implement the recommended changes"
# Wait for completion...

# Stage 3: Validation
scion start validator "Validate the changes made by the implementer"
```

## When to Use

- Migration pipelines (investigate → migrate → test)
- Phased refactoring (analyze → plan → implement → verify)
- Document generation (research → draft → review → publish)

## Key Considerations

- **Validate between stages** — read the output before starting the next agent
- The output file (e.g., `ANALYSIS.md`) is the contract between stages
- If Stage N produces bad output, Stage N+1 will amplify the error
