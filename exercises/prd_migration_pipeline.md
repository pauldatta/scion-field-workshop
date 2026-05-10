# Exercise: Migration Pipeline

## Objective

Run a sequential 3-stage migration pipeline with inter-stage validation — investigator → migrator → test writer.

## Duration

25 minutes

## The Migration

**Centralize ProShop's error handling** — replace scattered try/catch blocks with a unified Express.js error middleware.

## Instructions

### Stage 1: Investigation (8 min)

```bash
scion start investigator "Analyze ALL error handling in the ProShop Express.js backend. For every file:
1. List every try/catch block with file path and line numbers
2. Document every res.status().json() error response pattern
3. Identify inconsistencies (different error formats, missing status codes)
4. Output a structured migration plan to MIGRATION_PLAN.md with:
   - Current state summary
   - Proposed centralized error middleware design
   - File-by-file migration steps
   - Risk assessment for each change" --type security-auditor
```

**Wait for completion**, then read `MIGRATION_PLAN.md` together:

- Did the investigator find all error patterns?
- Is the proposed middleware design reasonable?
- Are there risks it didn't identify?

### Stage 2: Migration (10 min)

```bash
scion start migrator "Read MIGRATION_PLAN.md and implement the centralized error handling:
1. Create errorMiddleware.js with a unified error handler
2. Create AppError class with status code and operational flag
3. Refactor ALL routes to use next(new AppError(...)) instead of inline try/catch
4. Ensure consistent error response format: {success: false, message, stack}
5. Add async handler wrapper to eliminate try/catch in route handlers" --type migration-lead
```

### Stage 3: Validation (7 min)

```bash
scion start test-writer "Write tests that verify the centralized error middleware:
1. Unit tests for AppError class
2. Unit tests for errorMiddleware (different error types)
3. Integration tests for each refactored route
4. Edge cases: malformed requests, database errors, auth failures
5. Verify consistent error response format across all endpoints" --type test-engineer
```

## Success Criteria

- [ ] Investigator produced a structured MIGRATION_PLAN.md
- [ ] Inter-stage validation performed (manual review of plan)
- [ ] Migrator implemented centralized error middleware
- [ ] Test writer validated the migration with comprehensive tests
- [ ] Pipeline executed in correct order (no parallel stages)

## Key Takeaway

Sequential pipelines require **checkpoints between stages**. The investigator's output is the migrator's input — garbage in, garbage out.
