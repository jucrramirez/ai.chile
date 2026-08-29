# ai.chile 🌶️

> An AI assistant toolkit inspired by Chilango culture to identify bad practices in code and provide straight-to-the-point suggestions.

![Status: WIP](https://img.shields.io/badge/Status-WIP%20👷🏽♂️-yellow)

## 📖 Overview

The content and approach of this repository is based on the [Ponytail](https://github.com/DietrichGebert/ponytail) project. Rather than being a direct copy, **ai.chile** adapts Ponytail's core philosophy—identifying bad practices in code and offering straightforward, concise suggestions to improve them—while infusing it with Mexican culture.

The name comes from the famous Mexican phrase *"Al chile"* (meaning to be direct, honest, or straight to the point). 
- **AI** = Artificial Intelligence
- **Chile** = Just because I'm Mexican 🇲🇽

## 🎯 Current Tools

One plugin, many modes, utilizing Mexican meme references:

- **elmatabichos** — Evidence-based debugging: hunt the bicho (bug), find the root cause, apply the smallest safe fix. Persists for the session. Off: "stop matabichos". `/elmatabichos` *(Note: This skill is excluded from Cursor installations, as Cursor natively provides a powerful Agent Debug Mode. This is intended to bring similar functionality to other IDEs).*
- **elmatamuertos** — Dead-code auditor: dead code/imports/tests, unused packages and env vars, duplications, redundancy, dangling docs pointing at nonexistent files. One-shot report, no fixes. `/elmatamuertos`
- **elmatachingaderas** — Bad-implementation auditor: tech debt, thin wrappers, huge modules, bad logic, test-only code, badly designed tests, magic constants, generic names, embedded prompts, duplications, redundancies, or missing validation. One-shot report, no fixes. `/elmatachingaderas`

## 🎭 The Orchestrator (Upcoming)

Ideally, `elmatamuertos` and `elmatachingaderas` will act depending on a persistent orchestrator command (currently in development). This orchestrator will modify the behavior of the auditors (but not the debugger) and will feature three distinct modes:

- **El ñero** — The lazy, default mood (standard Ponytail approach).
- **[No name yet]** — The full, thorough equivalent.
- **El chambeador** — The ultra-productive, hardcore equivalent.

## 🚀 Installation

### Dependencies

Before running the installation script, ensure you have the following:
- A **Bash** environment (Linux, macOS, or WSL on Windows).
- At least one of the supported environments installed (**Cursor**, **OpenCode**, or **Antigravity**).

### Setup

We provide an interactive CLI installation script to securely and easily add the toolkit to your preferred IDE.

```bash
chmod +x install.sh
./install.sh
```

During installation, you will be asked to choose exactly one IDE: **Cursor**, **OpenCode**, or **Antigravity**. You can choose to install globally, in the current folder, or in a specific project.

### Manual Local Dev (OpenCode)

Point straight at the plugin file (command + skill paths auto-register):

```json
{
  "plugin": ["file:///PATH/TO/ai.chile/.opencode/plugin/elmatabichos.mjs"]
}
```

## 🧰 Project Structure

```text
ai.chile/
├── install.sh                        # Interactive installer
├── .opencode/command/*.md            # /commands: one .md per mode (auto-registered)
├── .opencode/plugin/elmatabichos.mjs # plugin: registers all commands + skills dir
└── skills/                           # skills: one dir per mode (auto-registered)
    ├── elmatabichos/
    ├── elmatachingaderas/
    └── elmatamuertos/
```

## ➕ Adding another mode

Add `skills/<name>/SKILL.md` (frontmatter: `name`, `description`, with trigger words + off/reverts text) and `.opencode/command/<name>.md` (frontmatter: `description`, one line that loads the skill). The plugin picks both up automatically — no other change needed.

## 🙏 Acknowledgements & References

- **[Ponytail](https://github.com/DietrichGebert/ponytail)** by [@DietrichGebert](https://github.com/DietrichGebert): The core architectural concepts, token-minimalist prompt design, and skill/command persistence patterns in `ai.chile` are directly inspired by the Ponytail project.
- **Mexican / Chilango Culture**: For the spirit of going *"al chile"*—delivering straight, no-nonsense code reviews and debugging tools with meme references.


