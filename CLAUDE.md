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

### Step 1: Design Canvas (Pencil Tool)

**Tool**: Pencil MCP (`.pen` files)

**⚠️ CRITICAL: Always start feature development with a design canvas using Pencil**

- Input: User requirements / PRD / Bug description
- Output: Design canvas document (`docs/designs/<feature>.pen`)

#### Pencil Tool Workflow

1. **Check editor state**:
   ```
   Use get_editor_state() to see current .pen file status
   ```

2. **Open or create design file**:
   ```
   Use open_document("docs/designs/<feature>.pen") or open_document("new")
   ```

3. **Get design guidelines** (optional):
   ```
   Use get_guidelines(topic="landing-page|table|tailwind|code")
   ```

4. **Get style guide** for consistent design:
   ```
   Use get_style_guide_tags() to discover available tags
   Use get_style_guide(tags=["modern", "dashboard"]) for inspiration
   ```

5. **Create design elements**:
   ```
   Use batch_design(operations) to create:
   - UI mockups and wireframes
   - Component hierarchy diagrams
   - Data flow visualizations
   - Architecture diagrams
   ```

6. **Validate design visually**:
   ```
   Use get_screenshot() to verify the design looks correct
   ```

#### Design Canvas Content

- Feature architecture diagram
- Data flow diagram
- UI mockups (if applicable)
- API design (if applicable)
- Component specifications
- Design decisions and rationale

#### Design Approval

Before proceeding to implementation:
1. Present the design canvas to the user
2. Get explicit approval
3. Document any feedback or changes
4. Mark design status as `Approved`

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

- [ ] Design canvas created/updated (`docs/designs/<feature>.pen`)
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
│   ├── hooks/                   # Hook scripts
│   │   ├── lib.sh               # Shared utility functions
│   │   ├── state-manager.sh     # State manager
│   │   ├── check-design-canvas.sh
│   │   ├── check-test-plan.sh
│   │   ├── check-code-simplifier.sh
│   │   ├── check-pr-review.sh
│   │   ├── check-unit-tests.sh
│   │   ├── post-git-action-clear.sh
│   │   ├── post-git-push.sh
│   │   └── verify-completion.sh
│   └── skills/                  # Claude Code skills
│       └── github-workflow/     # GitHub development workflow skill
│           ├── SKILL.md         # Main skill definition
│           ├── references/      # Reference documentation
│           │   ├── commit-conventions.md
│           │   └── review-commands.md
│           └── scripts/         # Utility scripts
│               ├── reply-to-comments.sh
│               └── resolve-threads.sh
├── docs/
│   ├── designs/                 # Design canvas documents (.pen files)
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

---

## Skills Reference

### GitHub Workflow Skill

The `github-workflow` skill provides standardized guidance for the complete development workflow.

**Trigger phrases**: "design a feature", "create UI mockup", "create a PR", "address review comments", "resolve review threads", "/q review", "/codex review", "merge PR", "push changes", "check CI status"

**Location**: `.claude/skills/github-workflow/SKILL.md`

**Key features**:
- Design Canvas workflow using Pencil tool
- Branch naming and commit conventions
- PR creation and review process
- Reviewer bot interaction (Amazon Q, Codex)
- CI/CD check monitoring
- Review thread management

**Utility scripts**:
```bash
# Reply to a specific review comment
.claude/skills/github-workflow/scripts/reply-to-comments.sh <owner> <repo> <pr> <comment_id> "<message>"

# Resolve all unresolved review threads
.claude/skills/github-workflow/scripts/resolve-threads.sh <owner> <repo> <pr>
```

**Reference documentation**:
- `references/commit-conventions.md` - Branch naming and commit message standards
- `references/review-commands.md` - GitHub CLI and GraphQL commands
