# Environment Setup

!!! info "Pre-Work — Complete Before the Workshop (~20 min)"
    This page guides you through installing all prerequisites. Arrive at the workshop with everything verified.

## System Requirements

| Dependency | Minimum Version | Purpose |
|---|---|---|
| **Go** | 1.22+ | Building Scion from source |
| **Docker Desktop** | Latest | Container runtime for agents |
| **Git** | 2.40+ | Worktree management |
| **Node.js** | 18+ | Gemini CLI harness |
| **jq** | Latest | JSON processing for scripted automation |

## Step 1: Clone the Workshop

```bash
git clone <workshop-repo-url>
cd scion-public-workshop
```

## Step 2: Run the Environment Check

The automated checker validates all prerequisites and offers to install missing items:

```bash
make check-env
```

This script will:

1. ✅ Verify Go 1.22+, Docker, Git, Node.js, and jq are installed
2. ✅ Check that Docker Desktop is running
3. ✅ Offer to build Scion from source if not found
4. ✅ Report final readiness status

!!! tip "macOS Users"
    The script installs missing dependencies via Homebrew. If you don't have Homebrew, install it first: [brew.sh](https://brew.sh/)

## Step 3: Build Scion

If `make check-env` didn't build Scion automatically:

```bash
# Clone Scion source
git clone --depth=1 https://github.com/GoogleCloudPlatform/scion.git ../../research/scion-source

# Build and install
cd ../../research/scion-source
go install ./cmd/scion/...

# Verify
scion --version
```

## Step 4: Build Container Images

Scion agents run in containers. Build the images for the Gemini CLI harness:

```bash
# From the Scion source directory
cd ../../research/scion-source

# Build the harness container images
# (Refer to Scion documentation for current build instructions)
```

## Step 5: Verify Everything

Run through this checklist before the workshop:

- [ ] `scion --version` returns a version string
- [ ] `docker ps` runs without errors (Docker daemon is active)
- [ ] `go version` shows 1.22 or higher
- [ ] `node --version` shows v18 or higher
- [ ] `jq --version` returns a version

## Troubleshooting

| Issue | Solution |
|---|---|
| `docker: command not found` | Install [Docker Desktop](https://docs.docker.com/get-docker/) |
| `go: command not found` | Install Go: `brew install go` or [go.dev/dl](https://go.dev/dl/) |
| Docker daemon not running | Start Docker Desktop from Applications |
| Scion build fails | Ensure Go 1.22+. Try: `go clean -cache && go install ./cmd/scion/...` |
| Image build OOM | Increase Docker Desktop memory allocation (Settings → Resources → 8GB+) |
| `npm` / `node` not found | Install Node.js: `brew install node` or [nodejs.org](https://nodejs.org/) |

!!! success "Ready!"
    If all checks pass, you're ready for the workshop. See you there! :rocket:
