#!/bin/bash
set -e

echo "🚀 Initializing AIandI Operations Center (Automated Setup)..."

# 1. Install Doppler CLI
echo "📦 Installing Doppler CLI..."
sudo apt-get update || true
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -sLf --retry 3 --tlsv1.2 --proto "=https" 'https://packages.doppler.com/public/cli/gpg.DE2A7741A397C129.key' | sudo gpg --yes --dearmor -o /usr/share/keyrings/doppler-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/doppler-archive-keyring.gpg] https://packages.doppler.com/public/cli/deb/debian any-version main" | sudo tee /etc/apt/sources.list.d/doppler-cli.list
sudo apt-get update || true
sudo apt-get install -y doppler

# 2. Install AI Copilot Tools
echo "🧠 Installing AI Copilot Tools..."

# 2.1 Install Gemini CLI (Official npm method)
echo "   - Installing @google/gemini-cli..."
sudo env PATH=$PATH npm install -g @google/gemini-cli

# 2.2 Install Claude Code (Official curl method recommended by Anthropic)
echo "   - Installing claude-code..."
curl -fsSL https://claude.ai/install.sh | bash

# 2.3 Install OpenCode (Official curl method)
echo "   - Installing opencode..."
curl -fsSL https://opencode.ai/install | bash

# 2.4 Install Oh My OpenAgent (The rebranded oh-my-opencode harness via npm)
echo "   - Installing oh-my-opencode (oh-my-openagent)..."
sudo env PATH=$PATH npm install -g oh-my-opencode

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