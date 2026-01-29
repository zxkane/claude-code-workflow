#!/bin/bash
# Resolve all unresolved review threads on a GitHub PR
#
# Usage: ./resolve-threads.sh <owner> <repo> <pr_number>
#
# Example:
#   ./resolve-threads.sh zxkane openhands-infra 5

set -e

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <owner> <repo> <pr_number>"
    echo ""
    echo "Arguments:"
    echo "  owner       - Repository owner (e.g., zxkane)"
    echo "  repo        - Repository name (e.g., openhands-infra)"
    echo "  pr_number   - Pull request number (e.g., 5)"
    echo ""
    echo "Example:"
    echo "  $0 zxkane openhands-infra 5"
    exit 1
fi

OWNER="$1"
REPO="$2"
PR_NUMBER="$3"

echo "Fetching unresolved review threads for PR #$PR_NUMBER..."

# Get unresolved thread IDs
THREAD_IDS=$(gh api graphql -f query="
query {
  repository(owner: \"$OWNER\", name: \"$REPO\") {
    pullRequest(number: $PR_NUMBER) {
      reviewThreads(first: 50) {
        nodes {
          id
          isResolved
        }
      }
    }
  }
}" --jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false) | .id')

if [ -z "$THREAD_IDS" ]; then
    echo "No unresolved threads found!"
    exit 0
fi

# Count threads
THREAD_COUNT=$(echo "$THREAD_IDS" | wc -l | tr -d ' ')
echo "Found $THREAD_COUNT unresolved thread(s)"

# Resolve each thread and track results
RESOLVED=0
FAILED=0

# Use here-string to avoid subshell (pipe creates subshell where variable updates are lost)
while read thread_id; do
    if [ -n "$thread_id" ]; then
        echo -n "Resolving thread $thread_id... "
        result=$(gh api graphql -f query="
mutation {
  resolveReviewThread(input: {threadId: \"$thread_id\"}) {
    thread { isResolved }
  }
}" --jq '.data.resolveReviewThread.thread.isResolved' 2>/dev/null)

        if [ "$result" = "true" ]; then
            echo "OK"
            RESOLVED=$((RESOLVED + 1))
        else
            echo "FAILED"
            FAILED=$((FAILED + 1))
        fi
    fi
done <<< "$THREAD_IDS"

echo ""
echo "Summary: $RESOLVED resolved, $FAILED failed"
echo ""
echo "To verify, run:"
echo "  gh api graphql -f query='query { repository(owner: \"$OWNER\", name: \"$REPO\") { pullRequest(number: $PR_NUMBER) { reviewThreads(first: 50) { nodes { isResolved } } } } }' --jq '[.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)] | length'"
