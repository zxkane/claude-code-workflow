---
name: warn-skip-verification
enabled: true
event: bash
pattern: git\s+(push|commit).*--no-verify
action: warn
---

## ⚠️ Skipping Verification Detected

You're using `--no-verify` which skips pre-commit/pre-push hooks.

**This project requires (per CLAUDE.md):**
- All commits pass code-simplifier review
- All pushes pass pr-review review
- CI must pass before declaring task complete
- E2E tests must be run on preview environment

**Acceptable use cases:**
- Fixing a CI issue that the hook itself is causing
- Emergency hotfix (must still verify manually afterward)
- Documentation-only changes

**If skipping intentionally:**
1. Document why in the commit message
2. Ensure manual verification is done
3. Consider re-running the skipped checks after
