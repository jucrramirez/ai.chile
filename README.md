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

One plugin, four focused workflows, utilizing Mexican meme references:

| Tool | Purpose | Command |
|---|---|---|
| **elmatabichos** | Evidence-based debugging: hunt the bicho, find the root cause, and apply the smallest safe fix. | `/elmatabichos` |
| **elbuscabichos** | Report-only bug chaser: audit the whole repo, or use `webon` for uncommitted changes only. | `/elbuscabichos [webon]` |
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

In OpenCode, Codex, and Claude Code, the mode is stored at `~/.config/ai.chile/mode` (or `$XDG_CONFIG_HOME/ai.chile/mode`) and survives sessions. This makes the selected mode shared across those clients on the same machine. Cursor and Copilot prompt files can select the mode only for the current conversation because they do not provide a persistent runtime hook.

---

## 🚀 Installation

### Dependencies

- **Bash** on macOS, Linux, or WSL on Windows.
- **Cursor**, **OpenCode** (V1 or V2), **Codex**, **Claude Code**, or **VS Code with GitHub Copilot**, depending on the target.
- **Node.js** when installing for OpenCode. The installer uses it to update `opencode.json` / `opencode.jsonc`; no npm packages are required.

Cursor installation does not require Node.js.

### Setup

The installer is interactive and copies only the files for the IDE you select.

```bash
chmod +x install.sh && ./install.sh
```

During installation, choose exactly one target: **Cursor**, **OpenCode**, **Codex**, **Claude Code**, or **VS Code / GitHub Copilot**. Cursor, OpenCode, Codex, and Claude Code support global, current-folder, or specific-project installation. Copilot prompt files are installed in the current or a specific project.

> **OpenCode V2:** The installer writes both V1 (`"plugin"`) and V2 (`"plugins"`) keys to your config file for maximum compatibility. If you are on OpenCode V2 you can safely remove the deprecated `"plugin"` key after installation.

### Cursor

The installer copies these slash commands to the selected `.cursor/commands` directory:

- `/elmatamuertos` — report dead or redundant code without changing files.
- `/elmatachingaderas` — report costly unnecessary implementations without changing files.

`elmatabichos` is intentionally not installed for Cursor because Cursor has a native Agent Debug mode.

### OpenCode

The installer copies the plugin, commands, and skills, then adds the plugin to the selected `opencode.json` or `opencode.jsonc`:

- Global: `~/.config/opencode/ai.chile` and `~/.config/opencode/opencode.json(c)`.
- Current project: `.opencode/`, `skills/`, and `opencode.json(c)` in the current directory.
- Specific project: the same files in the path you provide.

The plugin supports both **OpenCode V1** and **V2**. On V1, a deprecation warning is printed to the console recommending migration to V2.

Commands:

- `/elmatabichos`
- `/elbuscabichos [webon]`
- `/elmatamuertos`
- `/elmatachingaderas`
- `/elchalan godin|chakaloso|chambeador|off`

The installer supports both `opencode.json` and `opencode.jsonc` (with `//` and `/* */` comments). It prefers `.jsonc` when both files exist.

### Codex

The installer copies the five skills to one of these native skill directories:

- Global: `~/.codex/skills/`
- Current project: `.codex/skills/`
- Specific project: `<project>/.codex/skills/`

Use `$elmatabichos`, `$elbuscabichos webon`, `$elmatamuertos`,
`$elmatachingaderas`, or `$elchalan` in Codex, or select a skill from its
`/skills` picker. `elchalan` writes the same persistent mode file OpenCode
uses, so the auditor intensity carries over between Codex and OpenCode
sessions.

### Claude Code

The installer copies the five skills to one of these native skill directories:

- Global: `~/.claude/skills/`
- Current project: `.claude/skills/`
- Specific project: `<project>/.claude/skills/`

Invoke a skill from Claude Code's slash-command picker: `/elmatabichos`,
`/elbuscabichos [webon]`, `/elmatamuertos`, `/elmatachingaderas`, or
`/elchalan`. `elchalan` shares its persistent mode file with OpenCode and
Codex on the same machine.

### VS Code / GitHub Copilot

The installer copies prompt files to `.github/prompts`. In VS Code, enable prompt files with `"chat.promptFiles": true` if they are not already enabled, then invoke them from Copilot Chat with `/elmatamuertos`, `/elmatachingaderas`, `/elmatabichos`, `/elbuscabichos [webon]`, or `/elchalan`.

Prompt files are workspace-scoped and do not persist `elchalan` mode between conversations. `elmatabichos` is available here because Copilot has no Cursor equivalent of the native Debug mode exclusion.

### Manual OpenCode setup

To use a checkout without running the installer, add the plugin path to your OpenCode configuration.

**OpenCode V2** (`opencode.jsonc`):

```jsonc
{
  "plugins": ["file:///PATH/TO/ai.chile/.opencode/plugins/ai-chile.mjs"],
  "skills": ["./PATH/TO/ai.chile/skills"]
}
```

**OpenCode V1** (deprecated — `opencode.json`):

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
├── install.sh                        # Interactive installer for all clients
├── .cursor/commands/*.md             # Cursor slash commands
├── .github/prompts/*.prompt.md       # Copilot prompt files
├── .opencode/command/*.md            # OpenCode commands
├── .opencode/plugins/ai-chile.mjs    # Dual V1/V2 plugin entry point
└── skills/                           # portable skills: one dir per mode
    ├── elmatabichos/
    ├── elbuscabichos/
    ├── elchalan/
    ├── elmatachingaderas/
    └── elmatamuertos/
```

---

## ➕ Adding another mode

Add `skills/<name>/SKILL.md`, `.opencode/command/<name>.md`, `.cursor/commands/<name>.md`, and `.github/prompts/<name>.prompt.md`. Codex and Claude Code consume the `skills/` directory directly; the OpenCode plugin discovers skills and command files automatically.

---

## 🙏 Acknowledgements & References

- **[Ponytail](https://github.com/DietrichGebert/ponytail)** by [@DietrichGebert](https://github.com/DietrichGebert): The core architectural concepts and token-minimalist prompt design in `ai.chile` are directly inspired by the Ponytail project.
- **Mexican / Chilango Culture**: For the spirit of going *"al chile"*—delivering straight, no-nonsense code reviews and debugging tools with meme references.
