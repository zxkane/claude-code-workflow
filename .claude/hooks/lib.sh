#!/bin/bash
# Shared utility functions for hook scripts
# Note: Does not use 'set -e' as this is a library meant to be sourced

# Parse JSON input and extract a field
# Usage: parse_json_field "field.path" "$json_input"
# Returns: field value or empty string
# Requires: jq (mandatory - no fallback to avoid security issues)
parse_json_field() {
  local field_path="$1"
  local json_input="$2"

  if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed" >&2
    echo ""
    return 1
  fi

  # Validate field path to prevent injection - only allow alphanumeric, dots, underscores, and brackets
  if [[ ! "$field_path" =~ ^[a-zA-Z0-9._\[\]\"]+$ ]]; then
    echo "Error: Invalid field path" >&2
    echo ""
    return 1
  fi

  # Use jq's getpath with proper variable binding to prevent injection
  echo "$json_input" | jq -r --arg path "$field_path" 'getpath($path | split(".")) // ""'
}

# Parse tool input command from hook JSON
# Usage: parse_command "$json_input"
parse_command() {
  parse_json_field "tool_input.command" "$1"
}

# Parse exit code from tool response
# Usage: parse_exit_code "$json_input"
# Requires: jq
parse_exit_code() {
  local json_input="$1"

  if ! command -v jq &> /dev/null; then
    echo "1"
    return 1
  fi

  echo "$json_input" | jq -r '.tool_response.exitCode // .tool_response.exit_code // "1"'
}

# Parse file path from tool input
# Usage: parse_file_path "$json_input"
parse_file_path() {
  parse_json_field "tool_input.file_path" "$1"
}

# Check if command matches a git operation
# Usage: is_git_command "commit" "$command"
is_git_command() {
  local operation="$1"
  local command="$2"
  [[ "$command" =~ git[[:space:]]+${operation} ]]
}

# Get the project root directory
# Usage: get_project_root
get_project_root() {
  local dir="${CLAUDE_PROJECT_DIR:-.}"
  if [[ -d "$dir" ]]; then
    echo "$dir"
  else
    echo "."
  fi
}
