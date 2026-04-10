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
    echo "📥 Cloning your private Second Brain data ($GH_USER/AIandI-userdata)..."
    if gh repo clone "$GH_USER/AIandI-userdata" "$USERDATA_DIR" 2>/dev/null; then
        echo "✅ Successfully cloned $USERDATA_DIR"
    else
        echo "❌ Failed to clone $GH_USER/AIandI-userdata."
        echo "Please ensure the repository exists and you have access."
        read -p "Press enter to continue without user data, or Ctrl+C to abort."
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
    echo "You need a Doppler Service Token (starts with 'dp.st.') to inject secrets."
    read -s -p "🔑 Enter your Doppler Service Token (or press Enter to skip): " USER_DOPPLER_TOKEN
    echo ""
    
    if [ -n "$USER_DOPPLER_TOKEN" ]; then
        export DOPPLER_TOKEN=$USER_DOPPLER_TOKEN
        # Configure doppler to use this token for all future commands in this workspace
        doppler configure set token "$USER_DOPPLER_TOKEN" --scope /
        if doppler secrets verify &>/dev/null; then
            echo "✅ Doppler authentication successful!"
        else
            echo "❌ Doppler authentication failed. Check your token."
        fi
    else
        echo "⏭️  Skipping Doppler authentication. AI Agents will not have access to secrets."
    fi
fi

echo "========================================================"
echo "🎉 Ignition Complete!"
echo "Your AIandI Operations Center is fully armed and operational."
echo "You can now use AI agents like 'gemini-cli' with injected secrets:"
echo "    doppler run -- gemini-cli"
echo "========================================================"
