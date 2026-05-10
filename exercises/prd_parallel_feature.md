# Exercise: Parallel Feature Build

## Objective

Build a new ProShop feature using 3 parallel Scion agents — each working in its own isolated worktree branch.

## Duration

20 minutes

## Prerequisites

- Scion installed and verified (`scion --version`)
- ProShop demo app cloned and grove initialized (`scion init`)
- Docker running with Scion harness images available

## The Feature

**Product Ratings** — Allow users to rate products and see average ratings.

## Instructions

### Step 1: Create the Agent Team (5 min)

Start three agents with specific, well-scoped tasks:

```bash
# Backend: API endpoint for ratings
scion start backend-dev "Add a product rating system to the ProShop Express.js backend:
1. Create a Rating model with fields: user, product, rating (1-5), comment, timestamp
2. Add POST /api/products/:id/ratings endpoint (authenticated users only)
3. Add GET /api/products/:id/ratings endpoint (public)
4. Update the Product model to include averageRating and numRatings fields
5. Add middleware to recalculate averages on new rating submission"

# Frontend: React component
scion start frontend-dev "Create a product rating UI for the ProShop React frontend:
1. Build a StarRating component that displays 1-5 stars (filled/empty)
2. Add a RatingForm component for submitting ratings with a comment
3. Display average rating and review count on the ProductScreen
4. Add a RatingList component showing individual reviews
5. Integrate with the /api/products/:id/ratings endpoints"

# Tests: Integration tests
scion start test-writer "Write comprehensive tests for the product rating feature:
1. API tests: POST rating (auth required), GET ratings, average calculation
2. Component tests: StarRating rendering, RatingForm submission
3. Integration test: full flow from rating submission to display
4. Edge cases: duplicate ratings, invalid rating values, empty reviews"
```

### Step 2: Observe the Fleet (5 min)

```bash
# See all three running
scion list

# Attach to each in turn (Ctrl+B, D to detach)
scion attach backend-dev
scion attach frontend-dev
scion attach test-writer

# Check the worktree branches
git branch | grep scion/
```

### Step 3: Review Output (5 min)

After agents complete, inspect each agent's work:

```bash
# See what the backend agent created
git diff main..scion/backend-dev --stat

# See frontend changes
git diff main..scion/frontend-dev --stat

# See test files
git diff main..scion/test-writer --stat
```

### Step 4: Merge (5 min)

```bash
# Merge in order: backend → frontend → tests
git merge scion/backend-dev
git merge scion/frontend-dev
git merge scion/test-writer

# Resolve any conflicts (expected in package.json)
# Review the clean git history
git log --oneline --graph -10
```

## Success Criteria

- [ ] Three agents started and ran in parallel
- [ ] Each agent worked on its own worktree branch
- [ ] Backend created Rating model and API endpoints
- [ ] Frontend created StarRating and RatingForm components
- [ ] Test writer created API and component tests
- [ ] All branches merged to main

## Discussion Questions

1. Did any agents duplicate work? How would you prevent that?
2. Were there merge conflicts? What caused them?
3. How would you improve the task descriptions to get better output?
