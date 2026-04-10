#!/bin/bash
set -e

# ==============================================================================
# AIandI Operations Center: Ignition Sequence
# This script is the single entry point for a new Codespace environment.
# It provisions the user data, authenticates secrets, and links the workspace.
# ==============================================================================

echo "========================================================"
echo "🚀 Welcome to the AIandI Operations Center Bootstrap"
echo "========================================================"
echo "This script will connect your Private Data and Secrets."
echo ""

# 1. GitHub Authentication Check & User Data Sync
echo "🔍 Checking GitHub Authentication..."
if ! gh auth status &>/dev/null; then
    echo "⚠️  GitHub CLI is not fully authenticated."
    echo "Please authenticate now to allow cloning of your private userdata repository."
    gh auth login --scopes "repo,workflow"
fi

# Fetch the current authenticated GitHub username
GH_USER=$(gh api user -q .login)
echo "✅ Authenticated as GitHub user: @$GH_USER"

USERDATA_DIR="./AIandI-userdata"
export USERDATA_REPO="$USERDATA_DIR"

if [ ! -d "$USERDATA_DIR" ]; then
    echo "📥 Fetching your repositories to find your Second Brain data..."
    
    # Fetch up to 100 repositories (name only) for the authenticated user
    mapfile -t REPO_LIST < <(gh repo list --limit 100 --json name -q '.[].name')
    
    if [ ${#REPO_LIST[@]} -eq 0 ]; then
        echo "❌ No repositories found for user @$GH_USER."
        echo "Please create a private repository on GitHub to store your data."
        read -p "Press enter to continue without user data, or Ctrl+C to abort."
    else
        echo "Please select the repository that contains your private P.A.R.A data:"
        
        # Use select to create an interactive menu
        PS3="Enter the number of your userdata repository (or press Ctrl+C to abort): "
        select REPO_NAME in "${REPO_LIST[@]}"; do
            if [ -n "$REPO_NAME" ]; then
                SELECTED_REPO="$GH_USER/$REPO_NAME"
                echo "📥 Cloning selected repository: $SELECTED_REPO..."
                if gh repo clone "$SELECTED_REPO" "$USERDATA_DIR"; then
                    echo "✅ Successfully cloned $SELECTED_REPO"
                else
                    echo "❌ Failed to clone $SELECTED_REPO."
                    read -p "Press enter to continue without user data."
                fi
                break
            else
                echo "Invalid selection. Please try again."
            fi
        done
    fi
else
    echo "✅ Private data directory already exists."
    # Optionally pull latest
    (cd "$USERDATA_DIR" && git pull --quiet origin main 2>/dev/null || true)
fi

# Link the folders
echo "🔗 Linking P.A.R.A folders..."
bash ./infrastructure/scripts/link_userdata.sh

echo ""
echo "--------------------------------------------------------"

# 2. Doppler Secrets Injection
echo "🔐 Doppler Secret Management Initialization"
if doppler secrets verify &>/dev/null; then
    echo "✅ Doppler is already authenticated."
else
    echo "Doppler is not authenticated in this environment."
    echo "We will authenticate the Doppler CLI using your personal account."
    echo "This grants the Codespace access to your Doppler projects so AI agents can manage secrets."
    echo ""
    # Use doppler login for interactive browser authentication
    if doppler login; then
        echo "✅ Doppler authentication successful!"
        # We can set a default scope to the token-providers for safety, but the agent can override it
        doppler setup --project keys4_token-providers --config stg --no-interactive || true
    else
        echo "⚠️  Doppler authentication skipped or failed. AI Agents may not have access to secrets."
    fi
fi

echo "========================================================"
echo "🎉 Ignition Complete!"
echo "Your AIandI Operations Center is fully armed and operational."
echo "You can now use AI agents like 'gemini-cli' with injected secrets:"
echo "    doppler run -- gemini-cli"
echo "========================================================"
