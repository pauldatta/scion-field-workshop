# Fan-Out Research Pattern

Adapted from `examples/orchestration-basics/fan-out-parallel/` in the Scion source.

## Pattern

Dispatch N identical agents, each with a unique topic or target:

```bash
# Start N research agents in parallel
for topic in "security" "performance" "documentation" "testing"; do
  scion start "${topic}-researcher" "Research ${topic} best practices for this codebase" --type docs-writer
done
```

## When to Use

- Code audits across multiple concern areas
- Research across multiple topics
- Parallel testing across multiple environments
- Compliance scanning across multiple policy domains

## Key Considerations

- All agents run in parallel — resource consumption scales linearly
- Use `scion list --format json` to poll for completion
- Synthesize findings after all agents complete — cross-agent insights are the value
