# Contributing to the Scion Workshop

Thank you for your interest in improving this workshop!

## Development Setup

```bash
# Install dependencies
make install-deps

# Serve locally with hot-reload
make serve

# Run all tests
make test
```

## Content Guidelines

- All documentation lives in `docs/`
- Exercises are PRD files in `exercises/`
- Sample templates follow the `scion-agent.yaml` + `agents.md` + `system-prompt.md` triad
- Use MkDocs Material admonitions for callouts (`!!! tip`, `!!! warning`, etc.)
- Use tabs for multi-harness examples (`=== "Gemini CLI"`)
- Code blocks must specify a language for syntax highlighting
- Duration badges use `<span class="duration-badge">X min</span>`

## Testing

Before submitting changes:

```bash
make test           # Structure + code blocks + lint
make test-links     # Internal link validation
make serve          # Visual inspection
```

## Commit Convention

Use conventional commits: `feat:`, `fix:`, `docs:`, `chore:`
