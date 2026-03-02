#!/usr/bin/env bash
set -euo pipefail

SVN_URL="https://svn.code.sf.net/p/chibios/code/trunk"

# Check prerequisites
if ! command -v git &>/dev/null; then
    echo "Error: git is not installed."
    echo "Install with: sudo apt install git"
    exit 1
fi

if ! git svn --version &>/dev/null; then
    echo "Error: git-svn is not installed."
    echo "Install with: sudo apt install git-svn"
    exit 1
fi

# Ensure we're in the repository root
cd "$(git rev-parse --show-toplevel)"

# Detect first run vs incremental
if git config --get svn-remote.svn.url &>/dev/null; then
    echo "SVN remote already configured. Running incremental fetch..."
else
    echo "First run: initializing git-svn with $SVN_URL"
    git svn init "$SVN_URL"
fi

echo "Fetching from SVN (this may take a while on first run)..."
git svn fetch

# Update main to match the git-svn tracking branch
git reset --hard remotes/git-svn
echo "main branch updated to $(git rev-parse --short HEAD)"

# Push to origin
echo "Pushing to origin..."
git push origin main
echo "Sync complete."
