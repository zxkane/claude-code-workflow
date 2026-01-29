#!/bin/bash
# Reply to a specific review comment on a GitHub PR
#
# Usage: ./reply-to-comments.sh <owner> <repo> <pr_number> <comment_id> "<message>"
#
# Example:
#   ./reply-to-comments.sh zxkane openhands-infra 5 2734892022 "Addressed in commit abc123 - Fixed the security issue"

set -e

if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <owner> <repo> <pr_number> <comment_id> <message>"
    echo ""
    echo "Arguments:"
    echo "  owner       - Repository owner (e.g., zxkane)"
    echo "  repo        - Repository name (e.g., openhands-infra)"
    echo "  pr_number   - Pull request number (e.g., 5)"
    echo "  comment_id  - Comment ID to reply to (e.g., 2734892022)"
    echo "  message     - Reply message (quote if contains spaces)"
    echo ""
    echo "Example:"
    echo "  $0 zxkane openhands-infra 5 2734892022 \"Addressed in commit abc123\""
    exit 1
fi

OWNER="$1"
REPO="$2"
PR_NUMBER="$3"
COMMENT_ID="$4"
MESSAGE="$5"

echo "Replying to comment $COMMENT_ID on PR #$PR_NUMBER..."

gh api "repos/$OWNER/$REPO/pulls/$PR_NUMBER/comments" \
  -X POST \
  -f body="$MESSAGE" \
  -F in_reply_to="$COMMENT_ID" \
  --jq '{id: .id, url: .html_url}'

echo "Reply posted successfully!"
