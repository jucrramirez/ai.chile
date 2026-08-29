#!/usr/bin/env bash

# Secure interactive install script for ai.chile
# Supported IDEs: Cursor, OpenCode

set -euo pipefail

echo "🌶️  Welcome to the ai.chile installer! 🌶️"
echo "We will set up the ai.chile commands for your environment."
echo ""

# 1. Select IDE
IDE_SELECTION=""
while true; do
  echo "Select your IDE (Please enter 1 or 2):"
  echo "  1) Cursor"
  echo "  2) OpenCode"
  read -r -p "> " choice
  case "$choice" in
    1) IDE_SELECTION="Cursor"; break ;;
    2) IDE_SELECTION="OpenCode"; break ;;
    *) echo "Invalid selection. Please enter 1 or 2."; echo "" ;;
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
  local config_file="$HOME/.config/opencode/opencode.json"
  if [[ "$target_root" != "$HOME/.config/opencode/ai.chile" ]]; then
    config_file="$target_root/opencode.json"
  fi
  node - "$config_file" "$target_root/.opencode/plugins/ai-chile.mjs" <<'NODE'
const fs = require("node:fs");
const [configFile, pluginPath] = process.argv.slice(2);
let config = {};
if (fs.existsSync(configFile)) {
  try { config = JSON.parse(fs.readFileSync(configFile, "utf8")); }
  catch { console.error(`Cannot update non-JSON config: ${configFile}`); process.exit(1); }
}
config.plugin = Array.isArray(config.plugin) ? config.plugin : [];
const entry = `file://${pluginPath}`;
if (!config.plugin.includes(entry)) config.plugin.push(entry);
fs.mkdirSync(require("node:path").dirname(configFile), { recursive: true });
fs.writeFileSync(configFile, `${JSON.stringify(config, null, 2)}\n`);
NODE
  echo "✅ Installed OpenCode plugin, commands, and skills to $target_root"
}

# 3. Execute installation
case "$IDE_SELECTION" in
  "Cursor") install_cursor ;;
  "OpenCode") install_opencode ;;
esac

echo ""
echo "🎉 Installation finished! Disfrútalo, al chile."
