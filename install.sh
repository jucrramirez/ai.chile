#!/usr/bin/env bash

# Secure interactive install script for ai.chile
# Supported IDEs: Cursor, OpenCode, VS Code / GitHub Copilot

set -euo pipefail

echo "🌶️  Welcome to the ai.chile installer! 🌶️"
echo "We will set up the ai.chile commands and prompts for your environment."
echo ""

# 1. Select IDE
IDE_SELECTION=""
while true; do
  echo "Select your IDE (Please enter 1, 2, or 3):"
  echo "  1) Cursor"
  echo "  2) OpenCode"
  echo "  3) VS Code / GitHub Copilot"
  read -r -p "> " choice
  case "$choice" in
    1) IDE_SELECTION="Cursor"; break ;;
    2) IDE_SELECTION="OpenCode"; break ;;
    3) IDE_SELECTION="Copilot"; break ;;
    *) echo "Invalid selection. Please enter 1, 2, or 3."; echo "" ;;
  esac
done

echo ""
echo "You selected: $IDE_SELECTION"
echo ""

# 2. Get the current directory of the repo (where skills exist)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"

if [[ ! -d "$SKILLS_DIR" ]]; then
  echo "Error: skills directory not found at $SKILLS_DIR"
  exit 1
fi

install_cursor() {
  echo "Where would you like to install the ai.chile commands for Cursor?"
  echo "  1) Globally (~/.cursor/commands)"
  echo "  2) In the current working folder (./.cursor/commands)"
  echo "  3) Specific project path"
  
  local TARGET_DIR=""
  while true; do
    read -r -p "> " c_choice
    case "$c_choice" in
       1) TARGET_DIR="$HOME/.cursor/commands"; break ;;
       2) TARGET_DIR="$(pwd)/.cursor/commands"; break ;;
      3)
        read -r -p "Enter absolute path to the project root: " custom_path
         TARGET_DIR="${custom_path}/.cursor/commands"
        break
        ;;
      *) echo "Invalid selection. Please enter 1, 2, or 3." ;;
    esac
  done
  
  echo "Installing to $TARGET_DIR..."
  mkdir -p "$TARGET_DIR"
  
  for command in "$REPO_DIR/.cursor/commands"/*.md; do
    local command_name
    command_name=$(basename "$command")
    if [[ "$command_name" == "elmatabichos.md" ]]; then
      echo "⏭️  Skipping elmatabichos (Cursor has native debug mode)"
      continue
    fi
    cp "$command" "$TARGET_DIR/"
    echo "✅ Installed ${command_name%.md}"
  done
  echo "Cursor commands installed."
}

install_opencode() {
  echo "Where would you like to install ai.chile for OpenCode?"
  echo "  1) Globally (~/.config/opencode/ai.chile)"
  echo "  2) In the current working folder (./.opencode)"
  echo "  3) Specific project path"
  local target_root=""
  while true; do
    read -r -p "> " o_choice
    case "$o_choice" in
      1) target_root="$HOME/.config/opencode/ai.chile"; break ;;
      2) target_root="$(pwd)"; break ;;
      3)
        read -r -p "Enter absolute path to the project root: " custom_path
        target_root="$custom_path"
        break
        ;;
      *) echo "Invalid selection. Please enter 1, 2, or 3." ;;
    esac
  done

  mkdir -p "$target_root/.opencode/plugins" "$target_root/.opencode/command" "$target_root/skills"
  cp "$REPO_DIR/.opencode/plugins/ai-chile.mjs" "$target_root/.opencode/plugins/"
  cp "$REPO_DIR/.opencode/command/"*.md "$target_root/.opencode/command/"
  cp -R "$SKILLS_DIR/". "$target_root/skills/"

  # Resolve config file — prefer .jsonc when it exists, fall back to .json
  local config_dir="$HOME/.config/opencode"
  if [[ "$target_root" != "$HOME/.config/opencode/ai.chile" ]]; then
    config_dir="$target_root"
  fi
  local config_file=""
  if [[ -f "$config_dir/opencode.jsonc" ]]; then
    config_file="$config_dir/opencode.jsonc"
  else
    config_file="$config_dir/opencode.json"
  fi

  node - "$config_file" "$target_root/.opencode/plugins/ai-chile.mjs" "$target_root/skills" <<'NODE'
const fs = require("node:fs");
const nodePath = require("node:path");
const [configFile, pluginPath, skillsPath] = process.argv.slice(2);

// Strip JSON comments (// and /* */) so we can parse .jsonc files
function stripJsonComments(text) {
  return text.replace(/\/\/.*$/gm, "").replace(/\/\*[\s\S]*?\*\//g, "");
}

let config = {};
if (fs.existsSync(configFile)) {
  const raw = fs.readFileSync(configFile, "utf8");
  try { config = JSON.parse(stripJsonComments(raw)); }
  catch { console.error(`Cannot parse config: ${configFile}`); process.exit(1); }
}

const pluginEntry = `file://${pluginPath}`;

// ── V2 format: "plugins" array (preferred) ──
config.plugins = Array.isArray(config.plugins) ? config.plugins : [];
if (!config.plugins.includes(pluginEntry)) config.plugins.push(pluginEntry);

// Add skills path for V2 auto-discovery
config.skills = Array.isArray(config.skills) ? config.skills : [];
if (!config.skills.includes(skillsPath)) config.skills.push(skillsPath);

// ── V1 format: keep "plugin" array for backward compatibility ──
config.plugin = Array.isArray(config.plugin) ? config.plugin : [];
if (!config.plugin.includes(pluginEntry)) config.plugin.push(pluginEntry);

fs.mkdirSync(nodePath.dirname(configFile), { recursive: true });
fs.writeFileSync(configFile, `${JSON.stringify(config, null, 2)}\n`);

console.log("  📦 Config updated: " + configFile);
if (config.plugin.length > 0) {
  console.log('  ⚠️  The V1 "plugin" key is deprecated. Rename it to "plugins" when you upgrade to OpenCode V2.');
}
NODE
  echo "✅ Installed OpenCode plugin, commands, and skills to $target_root"
}

install_copilot() {
  echo "Where would you like to install the Copilot prompt files?"
  echo "  1) In the current working folder (./.github/prompts)"
  echo "  2) Specific project path"
  local target_root=""
  while true; do
    read -r -p "> " c_choice
    case "$c_choice" in
      1) target_root="$(pwd)"; break ;;
      2)
        read -r -p "Enter absolute path to the project root: " custom_path
        target_root="$custom_path"
        break
        ;;
      *) echo "Invalid selection. Please enter 1 or 2." ;;
    esac
  done

  mkdir -p "$target_root/.github/prompts"
  cp "$REPO_DIR/.github/prompts/"*.prompt.md "$target_root/.github/prompts/"
  echo "✅ Installed Copilot prompt files to $target_root/.github/prompts"
}

# 3. Execute installation
case "$IDE_SELECTION" in
  "Cursor") install_cursor ;;
  "OpenCode") install_opencode ;;
  "Copilot") install_copilot ;;
esac

echo ""
echo "🎉 Installation finished! Disfrútalo, al chile."
