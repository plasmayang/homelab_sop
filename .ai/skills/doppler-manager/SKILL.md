---
name: doppler-manager
description: Configure and manage Doppler CLI, including secret management, authentication via Service Tokens, and running commands with secret injection. Use when the user needs to set up Doppler, manage project secrets, or execute applications that depend on Doppler-managed environment variables.
---

# Doppler Manager

## Overview

This skill provides a comprehensive workflow for managing Doppler CLI operations on the local machine. It focuses on authentication, secret lifecycle management, and secure command execution using Doppler's "zero-leak" secret injection.

## Quick Start

1. **Check Environment**: Run `scripts/check_status.sh`. If missing, follow **Task 0: Environment Provisioning**.
2. **Setup Auth**: If not authenticated, use `ask_user` to obtain a Service Token (starts with `dp.st.`) and configure it.
3. **Run App**: Use `doppler run -- <command>` to inject secrets into your process.

## Core Tasks

### 0. Environment Provisioning

If `doppler` CLI is not found:
- **Research**: Check the OS (e.g., Debian, Ubuntu, macOS).
- **Execute**: Refer to [references/SOP.md](references/SOP.md) for the specific installation commands.
- **Dependencies**: Ensure `curl`, `gnupg`, and `apt-transport-https` are installed if on Linux.
- **Verification**: Run `doppler --version` after installation.

### 1. The 9-Grid Architecture & Just-in-Time Access (JITA)

The `AIandI` workspace strictly isolates secrets across 9 domains (blast radii). AI Agents DO NOT have global access. You must use the `ask_user` tool to request temporary elevation for specific projects.

**The 9 Projects:**
1. `keys4_network-core` (Tailscale, Cloudflare)
2. `keys4_network-nodes` (SSH keys for VMs)
3. `keys4_backup-core` (S3/B2 keys, NAS encryption)
4. `keys4_private-services` (DB passwords)
5. `keys4_identity-providers` (OAuth clients, Social/Google/GitHub logins)
6. `keys4_token-providers` (AI API Keys: OpenAI, Anthropic, Gemini)
7. `keys4_observability-telemetry` (Grafana, Datadog)
8. `keys4_notification-channels` (Telegram bots, Webhooks)
9. `keys4_delivery-pipelines` (Docker Hub, NPM)

**The JITA Workflow:**
If you need to read or modify a secret in a project you don't currently have a token for:
1. Identify the target project from the 9-grid list above.
2. Use the `ask_user` tool (type: `text`) to prompt the user: "I need to access secrets in the `[project_name]` project. Please provide a Doppler Service Token (`dp.st.xxx`) scoped to this project's `stg` or `dev` config."
3. Once provided, temporarily configure the CLI: `doppler configure set token <NEW_TOKEN> --scope <temp_dir_or_current_dir>`
4. Execute the required action.

### 2. Secret Management

Manage secrets within a specific project and config using the provided Service Token.

- **List Secrets**: `doppler secrets`
- **Add/Update Secret**: `doppler secrets set KEY=VALUE`
- **Delete Secret**: `doppler secrets delete KEY`
- **Download Secrets (as .env)**: `doppler secrets download --format env --no-file > .env` (Avoid saving to disk if possible; prefer `doppler run`).

### 3. Secure Execution

Inject secrets directly into the application's memory without using `.env` files.

- **Run Command**: `doppler run -- <command>`
- **Example**: `doppler run -- python3 main.py`
- **Docker Compose**: `doppler run -- docker compose up -d`

## Reference Documentation

For detailed architecture, security best practices, and SOPs, see [references/SOP.md](references/SOP.md) and `$USERDATA_REPO/30-resources/sops/doppler-architecture-guide.md`.

## Troubleshooting

- **Auth Error**: Ensure the token is correctly set with `doppler configure set token`.
- **Project/Config Error**: The Service Token is strictly bound to one project/config. If you get a 403, you are trying to access the wrong grid in the 9-grid architecture. Use `ask_user` to request the correct token.
- **Network Issues**: Doppler CLI supports offline fallback if a local cache exists. Check `doppler secrets --offline` if connectivity is poor.
