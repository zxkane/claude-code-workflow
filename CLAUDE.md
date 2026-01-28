# Project Name - Claude Code Development Workflow

## Project Overview

[Describe your project's core functionality and goals here]

---

## Tech Stack

[Fill in based on your actual project]

| Component | Choice | Rationale |
|-----------|--------|-----------|
| Frontend | - | - |
| Backend | - | - |
| Database | - | - |
| Testing | - | - |

---

## Development Workflow (TDD + Agent-Assisted)

This project enforces a strict end-to-end development workflow through Claude Code hooks:

```
┌─────────────────────────────────────────────────────────────────────┐
│                    Feature/Bug Fix Development Flow                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Step 1          Step 2          Step 3          Step 4            │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐      │
│  │ Design   │───▶│ Test     │───▶│ Implement│───▶│ Unit     │      │
│  │ Canvas   │    │ Cases    │    │ Code     │    │ Tests    │      │
│  │ (Pencil) │    │ (TDD)    │    │          │    │ Pass     │      │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘      │
│       │                                               │             │
│       │                                               ▼             │
│       │         ┌──────────────────────────────────────────────┐   │
│       │         │              Pre-Commit Checks                │   │
│       │         │  1. code-simplifier agent reviews code        │   │
│       │         │  2. Local lint/type check passes              │   │
│       │         └──────────────────────────────────────────────┘   │
│       │                                               │             │
│       │         Step 5          Step 6               │             │
│       │         ┌──────────┐    ┌──────────┐         │             │
│       │    ┌───▶│ PR Review│───▶│ Git Push │◀────────┘             │
│       │    │    │ Agent    │    │          │                       │
│       │    │    └──────────┘    └──────────┘                       │
│       │    │                          │                            │
│       │    │    Step 7               ▼                             │
│       │    │    ┌──────────────────────────────┐                   │
│       │    │    │ Wait for GitHub CI Checks    │                   │
│       │    │    │ - Lint & Type Check          │                   │
│       │    │    │ - Unit Tests                 │                   │
│       │    │    │ - Build                      │                   │
│       │    │    └──────────────────────────────┘                   │
│       │    │                          │                            │
│       │    │                          ▼                            │
│       │    │    Step 8                                             │
│       │    │    ┌──────────────────────────────┐                   │
│       │    │    │ E2E Tests (Chrome DevTools)  │                   │
│       │    │    │ Verify on Preview Environment│                   │
│       │    │    └──────────────────────────────┘                   │
│       │    │                          │                            │
│       │    │    ❌ Failed             ▼ ✅ Passed                  │
│       │    └───────────────────  ┌──────────────┐                  │
│       │                          │ Notify User  │                  │
│       │                          │ Peer Review  │                  │
│       │                          └──────────────┘                  │
│       └────────────────────────────────────────────────────────▶   │
│                         Return to Step 1 (if changes needed)        │
└─────────────────────────────────────────────────────────────────────┘
```

### Step 1: Design Canvas

**Tool**: Pencil (or other design tools)

- Input: User requirements / PRD / Bug description
- Output: Design canvas document (`docs/designs/<feature>.md`)
- Tasks:
  1. Understand requirements, define scope and boundaries
  2. Create or update design canvas including:
     - Feature architecture diagram
     - Data flow diagram
     - UI mockups (if applicable)
     - API design (if applicable)
  3. Mark design status as `Complete`

### Step 2: Test Case Design (Test First - Mandatory)

**⚠️ This is a mandatory step that must be completed before writing any implementation code**

- Input: Design canvas + PRD requirements
- Output: Test case document + test skeleton code
- Tasks:
  1. Deeply understand design and requirements, identify all user scenarios and edge cases
  2. Write test case document: `docs/test-cases/<feature>.md`
     - List all test scenarios (happy path, edge cases, error handling)
     - Assign test IDs (e.g., `TC-AUTH-001`)
     - Define expected results and acceptance criteria
  3. Create E2E test skeleton (if applicable)
  4. Create unit test skeleton

**Test Case Document Template**: See `docs/templates/test-case-template.md`

### Step 3: Implementation

- Input: Design canvas + Test cases
- Output: Implementation code
- Tasks:
  1. Implement features following test cases
  2. Ensure implementation covers all test scenarios
  3. Manually verify basic functionality locally

### Step 4: Unit Test Implementation & Verification

- Input: Implementation code + Test skeleton
- Output: Complete unit tests, all passing
- Tasks:
  1. Implement all unit tests
     - Coverage requirement: >80%
  2. Run unit tests
  3. Fix failing tests
  4. Ensure all tests pass

### Step 5: Code Review (Pre-Commit)

**⚠️ Hook enforced - must complete before commit**

- Input: Feature code + Test code
- Output: code-simplifier review passed
- Tasks:
  1. Run code-simplifier agent:
     ```
     Use Task tool with subagent_type: code-simplifier:code-simplifier
     ```
  2. Address simplification suggestions
  3. Mark as complete:
     ```bash
     .claude/hooks/state-manager.sh mark code-simplifier
     ```

### Step 6: PR Review (Pre-Push)

**⚠️ Hook enforced - must complete before push**

- Input: Committed code
- Output: PR review passed
- Tasks:
  1. Run PR review agent:
     ```
     /pr-review-toolkit:review-pr
     ```
  2. Address findings:
     - 🔴 Critical/Severe: Must fix
     - 🟠 High: Must fix
     - 🟡 Medium: Should fix
     - 🟢 Low: Optional
  3. Mark as complete after resolving issues:
     ```bash
     .claude/hooks/state-manager.sh mark pr-review
     ```

### Step 7: Wait for CI Checks

**⚠️ Hook enforced - must verify before task completion**

- Input: GitHub PR
- Output: All CI/CD checks pass
- Required Checks:
  - ✅ Lint & Type Check
  - ✅ Unit Tests
  - ✅ Build
- If any check fails → Return to Step 3 to fix

### Step 8: E2E Test Verification

**⚠️ Hook enforced - must execute before task completion**

- Input: CI Checks all passed
- Output: E2E tests passed
- Tasks:
  1. Use Chrome DevTools MCP to test Preview environment
  2. Verify all functionality works correctly
  3. Check for console errors
  4. Mark as complete:
     ```bash
     .claude/hooks/state-manager.sh mark e2e-tests
     ```

---

## Acceptance Checklist

Before merging any PR, confirm:

- [ ] Design canvas created/updated (`docs/designs/<feature>.md`)
- [ ] Test case document created (`docs/test-cases/<feature>.md`)
- [ ] Feature code complete and locally verified
- [ ] Unit test coverage >80%
- [ ] All unit tests pass
- [ ] code-simplifier agent review passed
- [ ] pr-review agent review passed
- [ ] **All GitHub PR Checks pass**
- [ ] E2E tests pass (Chrome DevTools)
- [ ] User Peer Review complete

---

## Common Commands

```bash
# Development
npm run dev                    # Start local development server
npm run build                  # Build project

# Testing
npm test                       # Run all tests
npm run test:coverage          # Run tests with coverage report
npm run test:e2e               # Run E2E tests

# Code Quality
npm run lint                   # Run linter
npm run lint:fix               # Run linter with auto-fix
npm run typecheck              # TypeScript type check

# Hook State Management
.claude/hooks/state-manager.sh list        # View current states
.claude/hooks/state-manager.sh mark <action>   # Mark action as complete
.claude/hooks/state-manager.sh clear <action>  # Clear state
```

---

## Project Structure

```
project-root/
├── CLAUDE.md                     # Project config and workflow (this file)
├── .claude/
│   ├── settings.json            # Claude Code hooks configuration
│   └── hooks/                   # Hook scripts
│       ├── lib.sh               # Shared utility functions
│       ├── state-manager.sh     # State manager
│       ├── check-design-canvas.sh
│       ├── check-test-plan.sh
│       ├── check-code-simplifier.sh
│       ├── check-pr-review.sh
│       ├── check-unit-tests.sh
│       ├── post-git-action-clear.sh
│       ├── post-git-push.sh
│       └── verify-completion.sh
├── docs/
│   ├── designs/                 # Design canvas documents
│   ├── test-cases/              # Test case documents
│   └── templates/               # Document templates
├── src/                         # Source code
├── tests/                       # Test code
│   ├── unit/
│   └── e2e/
└── .github/
    └── workflows/               # GitHub Actions CI config
```

---

## Implementation Log

### YYYY-MM-DD: Project Initialization
- Create project structure
- Configure Claude Code hooks
- Configure CI/CD pipeline

---

## Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| - | - | - |

---

## Security Best Practices

[Fill in security considerations based on your project]
