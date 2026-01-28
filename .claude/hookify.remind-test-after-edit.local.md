---
name: remind-test-after-edit
enabled: true
event: file
conditions:
  - field: file_path
    operator: regex_match
    pattern: \.(ts|tsx|js|jsx|py|go|java|rb|rs)$
  - field: file_path
    operator: not_contains
    pattern: test
  - field: file_path
    operator: not_contains
    pattern: spec
---

## 📝 Code Change Reminder

You've modified a source file. Remember the project's verification workflow:

1. **Run unit tests** after making changes:
   ```bash
   npm test
   ```

2. **Run type check** to catch type errors:
   ```bash
   npm run typecheck
   ```

3. **Before committing**, ensure:
   - code-simplifier agent has reviewed the changes
   - All tests pass
   - No linting errors

4. **Before pushing**, ensure:
   - pr-review agent has reviewed the code
   - CI will verify automatically after push

This is a reminder only - continue with your work.
