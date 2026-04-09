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

### 1. Authentication & Configuration

Before managing secrets, the CLI must be authenticated.

- **Service Token (Headless/CI/CD)**:
  - If the environment is a server or container, use a Service Token.
  - Command: `doppler configure set token <YOUR_SERVICE_TOKEN>`
  - If the token is missing, ask the user: "Could you please provide a Doppler Service Token for the [environment] environment?"
- **Personal Login (Local Dev)**:
  - For local development with a browser: `doppler login`.
  - Then run `doppler setup` to bind the directory to a specific project/config.

### 2. Secret Management

Manage secrets within a specific project and config.

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

For detailed architecture, security best practices, and SOPs, see [references/SOP.md](references/SOP.md).

## Troubleshooting

- **Auth Error**: Ensure the token is correctly set with `doppler configure set token`.
- **Project/Config Error**: Use `doppler setup` or pass `--project` and `--config` flags to commands.
- **Network Issues**: Doppler CLI supports offline fallback if a local cache exists. Check `doppler secrets --offline` if connectivity is poor.
