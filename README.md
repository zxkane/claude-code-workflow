# Claude Code Development Workflow Template

A development workflow template for Claude Code that enforces end-to-end development processes through a hook system, ensuring AI agents follow TDD (Test-Driven Development) and code review best practices for feature development and bug fixes.

## 🎯 Features

- **Design First**: Enforces design canvas creation before implementation
- **Test-Driven Development (TDD)**: Enforces test case creation before writing code
- **Code Simplification**: Blocks commits until code-simplifier agent review is complete
- **Code Review**: Blocks pushes until pr-review agent review is complete
- **CI Verification**: Blocks task completion until CI passes
- **E2E Testing**: Enforces E2E test execution on Preview environment

## 📁 Project Structure

```
.
├── CLAUDE.md                     # Project config and workflow documentation
├── .claude/
│   ├── settings.json            # Claude Code hooks configuration
│   └── hooks/                   # Hook scripts
│       ├── lib.sh               # Shared utility functions
│       ├── state-manager.sh     # Workflow state management
│       ├── check-design-canvas.sh   # Design canvas check
│       ├── check-test-plan.sh       # Test plan check
│       ├── check-code-simplifier.sh # Code simplification check
│       ├── check-pr-review.sh       # PR review check
│       ├── check-unit-tests.sh      # Unit tests check
│       ├── warn-skip-verification.sh # --no-verify warning
│       ├── post-file-edit-reminder.sh # Post-edit reminder
│       ├── post-git-action-clear.sh # Git action state cleanup
│       ├── post-git-push.sh         # Post-push verification reminder
│       └── verify-completion.sh     # Task completion verification
├── docs/
│   ├── designs/                 # Design canvas documents
│   ├── test-cases/              # Test case documents
│   └── templates/               # Document templates
│       ├── design-canvas-template.md
│       └── test-case-template.md
└── .github/                     # (CI workflow needs manual setup)
```

## 🚀 Usage

### 1. Create a New Project from Template

```bash
# Using GitHub CLI
gh repo create my-project --template your-username/claude-code-workflow

# Or manually clone
git clone https://github.com/your-username/claude-code-workflow.git my-project
cd my-project
rm -rf .git
git init
```

### 2. Customize Configuration

1. **Update CLAUDE.md**: Modify project overview, tech stack, etc.
2. **Adjust hook scripts**: Modify file matching patterns based on project needs
3. **Configure CI**: Adjust GitHub Actions workflow based on project requirements

### 3. Start Development

When using Claude Code for development, hooks will automatically enforce the workflow.

## 🔧 Development Workflow

```
Step 1: Design Canvas (Pencil)
    ↓
Step 2: Test Cases (TDD)
    ↓
Step 3: Implementation
    ↓
Step 4: Unit Tests Pass
    ↓
Step 5: code-simplifier review → commit
    ↓
Step 6: pr-review review → push
    ↓
Step 7: Wait for CI to pass
    ↓
Step 8: E2E Tests (Chrome DevTools)
    ↓
✅ Task Complete → Peer Review
```

## 📋 Hook Reference

### PreToolUse Hooks

| Hook | Trigger | Behavior |
|------|---------|----------|
| check-design-canvas | git commit | Reminds to create design docs |
| check-test-plan | Write/Edit new file | Reminds to create test plan |
| check-code-simplifier | git commit | **Blocks** unreviewed commits |
| check-pr-review | git push | **Blocks** unreviewed pushes |
| check-unit-tests | git commit | Reminds to run unit tests |
| warn-skip-verification | git --no-verify | Warns about skipping verification |

### PostToolUse Hooks

| Hook | Trigger | Behavior |
|------|---------|----------|
| post-git-action-clear | git commit/push success | Clears completed states |
| post-git-push | git push success | Reminds CI and E2E verification |
| post-file-edit-reminder | Write/Edit source code | Reminds to run tests |

### Stop Hook

| Hook | Trigger | Behavior |
|------|---------|----------|
| verify-completion | Task end | **Blocks** tasks without verification |

## 🛠 State Management

Use `state-manager.sh` to manage workflow states:

```bash
# View current states
.claude/hooks/state-manager.sh list

# Mark action as complete
.claude/hooks/state-manager.sh mark design-canvas
.claude/hooks/state-manager.sh mark test-plan
.claude/hooks/state-manager.sh mark code-simplifier
.claude/hooks/state-manager.sh mark pr-review
.claude/hooks/state-manager.sh mark unit-tests
.claude/hooks/state-manager.sh mark e2e-tests

# Clear state
.claude/hooks/state-manager.sh clear <action>
.claude/hooks/state-manager.sh clear-all
```

## 📝 Document Templates

### Design Canvas Template

Location: `docs/templates/design-canvas-template.md`

Includes:
- Problem statement
- Architecture design
- API design
- Data model
- UI design
- Security considerations

### Test Case Template

Location: `docs/templates/test-case-template.md`

Includes:
- Test scenario definitions
- Test steps
- Expected results
- Priority markers
- Acceptance criteria

## 🔐 Required Claude Code Plugins

Ensure these official Claude Code plugins are enabled:

- `code-simplifier@claude-plugins-official` - Code simplification
- `pr-review-toolkit@claude-plugins-official` - PR review

## 📊 GitHub Actions

CI workflow needs to be added manually (see `docs/github-actions-setup.md`).

Default CI includes:
- Lint & Type Check
- Unit Tests (with coverage)
- Build

Optional:
- E2E Tests (Playwright)
- Deploy Preview

> **Note**: Due to GitHub token permission restrictions, CI workflow files need to be added manually.
> See `docs/github-actions-setup.md` for complete configuration instructions.

## 🤝 Reference Project

This template is based on the Claude Code memory and hook system implementation from [VidSyllabus](https://github.com/zxkane/VidSyllabus).

## 📄 License

MIT License
