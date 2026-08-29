# ai.chile 🌶️

> An AI assistant toolkit inspired by Chilango culture to identify bad practices in code and provide straight-to-the-point suggestions.

![Status: WIP](https://img.shields.io/badge/Status-Work%20in%20Progress%20%F0%9F%9A%A7-yellow)

---

## 📖 Overview

The content and approach of this repository is based on the [Ponytail](https://github.com/DietrichGebert/ponytail) project. Rather than being a direct copy, **ai.chile** adapts Ponytail's core philosophy—identifying bad practices in code and offering straightforward, concise suggestions to improve them—while infusing it with Mexican culture.

The name comes from the famous Mexican phrase *"Al chile"* (meaning to be direct, honest, or straight to the point).

- **AI** = Artificial Intelligence
- **Chile** = Just because I'm Mexican 🇲🇽

---

## 🎯 Current Tools

One plugin, three auditor modes, utilizing Mexican meme references:

| Tool | Purpose | Command |
|---|---|---|
| **elmatabichos** | Evidence-based debugging: hunt the bicho, find the root cause, and apply the smallest safe fix. | `/elmatabichos` |
| **elmatamuertos** | Dead-code auditor: unused code, imports, tests, packages, environment variables, duplications, redundancies, and dangling documentation. One-shot report, no fixes. | `/elmatamuertos` |
| **elmatachingaderas** | Bad-implementation auditor: tech debt, thin wrappers, huge modules, bad logic, test-only code, poorly designed tests, magic constants, generic names, embedded prompts, duplication, redundancy, and missing validation. One-shot report, no fixes. | `/elmatachingaderas` |
| **elchalan** | Persistent auditor intensity controller. | `/elchalan godin\|chakaloso\|chambeador\|off` |

> **Cursor:** `elmatabichos` is excluded from Cursor installations because Cursor natively provides Agent Debug Mode. It remains available for other IDEs.

---

## 🎭 El Chalan

`elchalan` persists the selected intensity and changes only the two auditors. It never changes `elmatabichos`.

| Mode | Behavior |
|---|---|
| **godin** | Low: fast, lightweight, and pragmatic. |
| **chakaloso** | Medium: focused, critical, and appropriately thorough. |
| **chambeador** | High: exhaustive and maximum effort. |
| **off** | Disable the auditor overlay. |

Use `/elchalan` without an argument to select `chakaloso`.

In OpenCode, the mode is stored at `~/.config/ai.chile/mode` and survives sessions. Cursor commands can select the mode for the current conversation; Cursor does not provide a plugin hook for cross-session persistence.

---

## 🚀 Installation

### Dependencies

- **Bash** on macOS, Linux, or WSL on Windows.
- **Cursor**, **OpenCode**, or **VS Code with GitHub Copilot**, depending on the target.
- **Node.js** when installing for OpenCode. The installer uses it to update `opencode.json`; no npm packages are required.

Cursor installation does not require Node.js.

### Setup

The installer is interactive and copies only the files for the IDE you select.

```bash
chmod +x install.sh && ./install.sh
```

During installation, choose exactly one target: **Cursor**, **OpenCode**, or **VS Code / GitHub Copilot**. Cursor and OpenCode support global, current-folder, or specific-project installation. Copilot prompt files are installed in the current or a specific project.

### Cursor

The installer copies these slash commands to the selected `.cursor/commands` directory:

- `/elmatamuertos` — report dead or redundant code without changing files.
- `/elmatachingaderas` — report costly unnecessary implementations without changing files.

`elmatabichos` is intentionally not installed for Cursor because Cursor has a native Agent Debug mode.

### OpenCode

The installer copies the plugin, commands, and skills, then adds the plugin to the selected `opencode.json`:

- Global: `~/.config/opencode/ai.chile` and `~/.config/opencode/opencode.json`.
- Current project: `.opencode/`, `skills/`, and `opencode.json` in the current directory.
- Specific project: the same files in the path you provide.

Commands:

- `/elmatabichos`
- `/elmatamuertos`
- `/elmatachingaderas`
- `/elchalan godin|chakaloso|chambeador|off`

The installer expects `opencode.json` to contain valid JSON. Back up or manually update a JSONC configuration before installing if it contains comments.

### VS Code / GitHub Copilot

The installer copies prompt files to `.github/prompts`. In VS Code, enable prompt files with `"chat.promptFiles": true` if they are not already enabled, then invoke them from Copilot Chat with `/elmatamuertos`, `/elmatachingaderas`, `/elmatabichos`, or `/elchalan`.

Prompt files are workspace-scoped and do not persist `elchalan` mode between conversations. `elmatabichos` is available here because Copilot has no Cursor equivalent of the native Debug mode exclusion.

### Manual OpenCode setup

To use a checkout without running the installer, add the plugin path to your OpenCode configuration:

```json
{
  "plugin": ["file:///PATH/TO/ai.chile/.opencode/plugins/ai-chile.mjs"]
}
```

No `npm install` step is needed.

---

## 🧰 Project Structure

```text
ai.chile/
├── install.sh                        # Interactive installer
├── .cursor/commands/*.md             # Cursor slash commands
├── .github/prompts/*.prompt.md       # Copilot prompt files
├── .opencode/command/*.md            # OpenCode commands
├── .opencode/plugins/ai-chile.mjs    # registers commands + skills
└── skills/                           # skills: one dir per mode (auto-registered)
    ├── elmatabichos/
    ├── elmatachingaderas/
    └── elmatamuertos/
```

---

## ➕ Adding another mode

Add `skills/<name>/SKILL.md`, `.opencode/command/<name>.md`, `.cursor/commands/<name>.md`, and `.github/prompts/<name>.prompt.md`. The OpenCode plugin discovers the skill and command files automatically.

---

## 🙏 Acknowledgements & References

- **[Ponytail](https://github.com/DietrichGebert/ponytail)** by [@DietrichGebert](https://github.com/DietrichGebert): The core architectural concepts and token-minimalist prompt design in `ai.chile` are directly inspired by the Ponytail project.
- **Mexican / Chilango Culture**: For the spirit of going *"al chile"*—delivering straight, no-nonsense code reviews and debugging tools with meme references.
