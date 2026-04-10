#!/bin/bash
set -e

echo "🚀 Initializing AIandI Operations Center (Automated Setup)..."

# 1. Install Doppler CLI
echo "📦 Installing Doppler CLI..."
(curl -Ls --tlsv1.2 --proto "=https" --retry 3 https://packages.doppler.com/public/cli/gpg.DE2A7741A397C129.key | sudo apt-key add -)
echo "deb https://packages.doppler.com/public/cli/deb/debian any-version main" | sudo tee /etc/apt/sources.list.d/doppler-cli.list
sudo apt-get update && sudo apt-get install -y doppler

# 2. Install AI Copilot Tools
echo "🧠 Installing AI Copilot Tools (@google/gemini-cli, claude-code)..."
# Using npm from the devcontainer features (Node.js)
npm install -g @google/gemini-cli @anthropic-ai/claude-code

echo "-----------------------------------------------------------------"
echo "✅ Environment Base Layer Installed."
echo "-----------------------------------------------------------------"
echo "⚠️  ACTION REQUIRED: Run the Ignition Sequence"
echo "-----------------------------------------------------------------"
echo "To complete your setup, pull down your private data, and configure secrets,"
echo "run the following command in your terminal right now:"
echo ""
echo "    bash ./bootstrap.sh"
echo ""
echo "-----------------------------------------------------------------"