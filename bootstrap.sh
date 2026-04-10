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

# Detect if we are using the restricted GITHUB_TOKEN common in Codespaces
if gh auth status 2>&1 | grep -q "GITHUB_TOKEN"; then
    echo "⚠️  Detected restricted Codespace token. You might not see your private repositories."
    read -p "Do you want to re-authenticate to access ALL your private repos? (y/N): " REAUTH
    if [[ "$REAUTH" =~ ^[Yy]$ ]]; then
        gh auth login --scopes "repo,workflow"
    fi
fi

# Fetch the current authenticated GitHub username
GH_USER=$(gh api user -q .login)
echo "✅ Authenticated as GitHub user: @$GH_USER"

USERDATA_DIR="./AIandI-userdata"
export USERDATA_REPO="$USERDATA_DIR"

while [ ! -d "$USERDATA_DIR" ]; do
    echo "📥 Fetching your repositories to find your Second Brain data..."
    
    # Fetch repositories
    mapfile -t REPO_LIST < <(gh repo list --limit 100 --json name -q '.[].name')
    
    if [ ${#REPO_LIST[@]} -eq 0 ]; then
        echo "❌ No repositories found or access denied."
        read -p "Press Enter to try 'gh auth login' or Ctrl+C to abort."
        gh auth login --scopes "repo,workflow"
        continue
    fi

    echo "Please select the repository that contains your private P.A.R.A data:"
    PS3="Enter the number (or press Ctrl+C to abort): "
    select REPO_NAME in "${REPO_LIST[@]}"; do
        if [ -n "$REPO_NAME" ]; then
            SELECTED_REPO="$GH_USER/$REPO_NAME"
            
            # Prevent users from selecting the engine repo itself
            if [ "$REPO_NAME" == "AIandI" ]; then
                echo "❌ Error: You selected the public 'AIandI' engine repo, which contains no data."
                echo "Please select your PRIVATE userdata repository."
                break
            fi

            echo "📥 Cloning selected repository: $SELECTED_REPO..."
            if gh repo clone "$SELECTED_REPO" "$USERDATA_DIR"; then
                # Validation: Check if it actually has P.A.R.A folders
                if [ ! -d "$USERDATA_DIR/01-raw" ] && [ ! -d "$USERDATA_DIR/20-areas" ]; then
                    echo "⚠️  Warning: The selected repo does not seem to contain P.A.R.A folders (01-raw, etc.)."
                    read -p "Are you sure this is the right repo? (y/N): " CONFIRM_EMPTY
                    if [[ ! "$CONFIRM_EMPTY" =~ ^[Yy]$ ]]; then
                        rm -rf "$USERDATA_DIR"
                        break
                    fi
                fi
                echo "✅ Successfully cloned $SELECTED_REPO"
            else
                echo "❌ Failed to clone $SELECTED_REPO."
            fi
            break
        else
            echo "Invalid selection."
        fi
    done
done

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
