#!/usr/bin/env bash
set -e

# Get latest tag
latest=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
echo "Latest tag: $latest"

# Calculate next version
base=${latest#v}
IFS='.' read -r major minor patch <<< "$base"
patch=$((patch + 1))
next="v$major.$minor.$patch"
echo "Next tag: $next"

# Save tag for later
export USING_TAG=$latest
export NEW_TAG=$next

# Generate changelog
changelog="What's Changed\n\n"
pr_numbers=$(git log "$USING_TAG"..HEAD --merges --pretty=format:'%s' | grep -oE '#[0-9]+' | tr -d '#' | sort -u)

if [ -z "$pr_numbers" ]; then
  changelog+="No pull requests merged."
else
  for pr in $pr_numbers; do
    info=$(gh pr view "$pr" --json title,author,number --jq '"- \(.title) by @\(.author.login) in #\(.number)"')
    changelog+="$info\n"
  done
fi

# Create and push tag
git config user.name "github-actions"
git config user.email "github-actions@users.noreply.github.com"
git tag "$NEW_TAG"
git push origin "$NEW_TAG"

# Create GitHub release
gh release create "$NEW_TAG" --title "Release $NEW_TAG" --notes "$changelog"
