# 🧠 AIandI: Your Second Brain & Operations Center

> **The central nervous system for your ideas, knowledge, projects, and infrastructure.**

Welcome to `AIandI` (AI and I). This repository is a unified workspace designed to be a true "Second Brain" augmented by Artificial Intelligence. It is built on a hybrid architecture combining the **P.A.R.A. Method** (Projects, Areas, Resources, Archives) with **Modern Monorepo** engineering principles.

Here, ideas are captured, knowledge is distilled, code is written, and servers are provisioned—all facilitated by AI Copilots like opencode, claude code, or gemini-cli.

## 🚀 Quickstart: The "Ignition" Sequence

This repository is optimized for **GitHub Codespaces**. To get started instantly:
1. Click **Code** -> **Codespaces** -> **New codespace**.
2. The environment will automatically install all necessary tools (GitHub CLI, Doppler, AI Copilots).
3. Once the terminal opens, run the single ignition script to authenticate your private data and secrets:
   ```bash
   ./bootstrap.sh
   ```

## 🧑‍💻 The Core Philosophy: AI and I

No matter how advanced AI becomes, as humans, we will always have work to do. At specific levels of information granularity and dimensions of personal interest, we will always need to engage and collaborate deeply with AI, rather than blindly handing everything over for it to manage. **This project is designed to be the custom-tailored workspace for that exact need**—a place where human intent and AI execution meet seamlessly.

---

## 🗂️ Repository Taxonomy: The Symbiosis of "Blueprint" and "Workshop"

To accommodate our philosophy of deep human-AI collaboration, the repository organizes information across two highly intertwined dimensions. They are not isolated silos, but rather a dynamic ecosystem where human cognition (The Blueprint) continuously flows into and is shaped by machine execution (The Workshop).

### 1. The Human Dimension (Numbered P.A.R.A. Folders)

This is the high-level cognitive layer. It tracks the lifecycle of your thoughts, knowledge, and active goals—from chaos to clarity.

> **🔒 The Dual-Repo Architecture:** To protect your privacy and ensure that this public "Engine" repository can be shared or open-sourced, all numbered folders (`00` to `40`) are ignored via `.gitignore`. You are expected to initialize a **second, private Git repository** to securely sync your personal knowledge base.
> 
> **How to link them:** Set the `USERDATA_REPO` environment variable to point to your private repository's path (e.g., `export USERDATA_REPO=/path/to/your/private/repo`). You can then create symlinks in this root directory pointing to the folders inside `$USERDATA_REPO` so your workspace remains unified.

- **`00-inbox/` 📥**: The raw intake. Transient landing zone for quick captures and unstructured thoughts.
- **`01-raw/` 🥩**: The immutable source of truth (Karpathy's LLM Wiki concept). A permanent, read-only data lake for original articles, research papers, logs, and unedited notes. The AI compiles structured knowledge from here but NEVER modifies these files.
- **`02-ideas/` 💡**: The incubator. Brainstorming, project proposals, and concepts being explored with AI.
- **`03-research/` 🔬**: Deep dives. Technical research, evaluations of new tools, and reading notes.
- **`10-projects/` 🚀**: Active execution. Source code for active applications, scripts, or focused engineering tasks with a defined end goal. *(This is the ultimate intersection point where human intent meets machine code).*
- **`20-areas/` 🌐**: Ongoing responsibilities. Long-term maintenance domains (e.g., HomeLab architecture, finance, health).
- **`30-resources/` 📚**: The library. Reusable assets, templates, standard operating procedures (SOPs), and shared scripts.
- **`40-archives/` 🗄️**: Cold storage. Completed projects, abandoned ideas, and outdated documents.

### 2. The Machine Dimension (Unnumbered Folders)

This is the granular execution and context layer. Think of these as "permanent super-projects" that enforce system conventions and provide the "hands" for AI and DevOps operations. 

- **`.ai/` 🧠**: The AI's context engine. Contains custom system instructions, prompt templates, and specialized agent **skills** (e.g., `.ai/skills/doppler-manager`). *Insights gained from debugging skills here are often distilled into SOPs and moved up to `30-resources/`.*
- **`infrastructure/` ⚙️**: The GitOps engine. Declarative Infrastructure as Code (IaC) and the original Agentic Operations Center (see `infrastructure/README.md`). *The physical manifestation of the strategic decisions made in `03-research/`.*
- **`.github/` 🐙**: Automation pipelines and CI/CD workflows.

---

## 🆚 Architecture Philosophy: AIandI vs. Karpathy's LLM Wiki

While building this Second Brain, a critical design choice was made: **Why not strictly follow Andrej Karpathy's pure 3-folder "LLM Wiki" architecture (`raw/`, `wiki/`, `outputs/`)?**

The answer is that `AIandI` is a **superset** of the LLM Wiki concept, designed not just for knowledge, but for **engineering and automation**.

| Feature | Karpathy's LLM Wiki | AIandI (P.A.R.A + GitOps) |
| :--- | :--- | :--- |
| **Primary Goal** | Knowledge synthesis & Q&A. | Knowledge synthesis **+ Engineering + Infrastructure Automation**. |
| **The "Source of Truth"** | `raw/` | **`01-raw/`** (We strictly adopt this immutable data lake concept). |
| **The "Compiled" Knowledge** | `wiki/` | **`20-areas/`** (domain knowledge) & **`30-resources/`** (reusable SOPs and scripts). |
| **Execution & Action** | ❌ Minimal (static markdown). | ✅ **`10-projects/`** (active code) & **`infrastructure/`** (GitOps IaC). |
| **AI Instructions** | `CLAUDE.md` | **`.ai/context.md`** & **`.ai/skills/`** (giving AI the "hands" to execute tasks like secret management). |

If `AIandI` were only a Wiki, it would be a passive library. By combining the immutable `01-raw` knowledge ingestion with the actionable P.A.R.A. framework and AI Skills, this repository becomes a full-stack **Operations Center**. The AI reads the raw data, compiles the wiki, *and* helps write the code to deploy the infrastructure.

---

## 🤝 AI Collaboration Rules

If you are an AI agent assisting in this repository:

1. **Context is King**: Always check `.ai/context.md` (if it exists) to understand the current preferences and state of the workspace.
2. **Respect the Flow**: Ensure new content is routed to the correct P.A.R.A. directory. Don't pollute `10-projects` with raw ideas; put them in `02-ideas` first.
3. **Keep it Clean**: Suggest moving stagnant items to `40-archives` and processing the `00-inbox` regularly.
4. **GitOps Supremacy**: When modifying infrastructure, rely on the SOPs in `30-resources/sops/` and the IaC in `infrastructure/`. Never leak secrets.

---

*This is a living system. It evolves as I do.*
