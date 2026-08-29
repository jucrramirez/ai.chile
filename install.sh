#!/usr/bin/env bash

# Secure interactive install script for ai.chile
# Supported IDEs: Cursor, OpenCode, Antigravity

set -euo pipefail

echo "🌶️  Welcome to the ai.chile installer! 🌶️"
echo "We will set up the AI plugins and skills for your environment."
echo ""

# 1. Select IDE
IDE_SELECTION=""
while true; do
  echo "Select your IDE (Please enter 1, 2, or 3):"
  echo "  1) Cursor"
  echo "  2) OpenCode"
  echo "  3) Antigravity"
  read -r -p "> " choice
  case "$choice" in
    1) IDE_SELECTION="Cursor"; break ;;
    2) IDE_SELECTION="OpenCode"; break ;;
    3) IDE_SELECTION="Antigravity"; break ;;
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
  echo "Where would you like to install the ai.chile skills for Cursor?"
  echo "  1) Globally (~/.cursor/rules or similar)"
  echo "  2) In the current working folder (./.cursor/rules)"
  echo "  3) Specific project path"
  
  local TARGET_DIR=""
  while true; do
    read -r -p "> " c_choice
    case "$c_choice" in
      1) TARGET_DIR="$HOME/.cursor/rules"; break ;;
      2) TARGET_DIR="$(pwd)/.cursor/rules"; break ;;
      3)
        read -r -p "Enter absolute path to the project root: " custom_path
        TARGET_DIR="${custom_path}/.cursor/rules"
        break
        ;;
      *) echo "Invalid selection. Please enter 1, 2, or 3." ;;
    esac
  done
  
  echo "Installing to $TARGET_DIR..."
  mkdir -p "$TARGET_DIR"
  
  # For each skill, we can link or copy
  for skill in "$SKILLS_DIR"/*; do
    if [[ -d "$skill" ]]; then
      local skill_name
      skill_name=$(basename "$skill")
      
      if [[ "$skill_name" == "elmatabichos" ]]; then
        echo "⏭️  Skipping $skill_name (Cursor natively supports debug mode)"
        continue
      fi
      
      if [[ -f "$skill/SKILL.md" ]]; then
        # Copying as a rule file
        cp "$skill/SKILL.md" "$TARGET_DIR/${skill_name}.mdc" 2>/dev/null || cp "$skill/SKILL.md" "$TARGET_DIR/${skill_name}.md"
        echo "✅ Installed $skill_name"
      fi
    fi
  done
  echo "Cursor setup complete!"
}

install_opencode() {
  local config_file="$HOME/.config/opencode/opencode.json"
  echo "Installing for OpenCode globally..."
  
  if [[ ! -f "$config_file" ]]; then
    echo "Creating new opencode config at $config_file"
    mkdir -p "$(dirname "$config_file")"
    echo '{"plugin":[]}' > "$config_file"
  fi
  
  echo "Please manually add this to your $config_file plugin array:"
  echo "  \"file://$REPO_DIR/.opencode/plugin/elmatabichos.mjs\""
  echo "✅ OpenCode instructions provided."
}

install_antigravity() {
  echo "Where would you like to install the ai.chile skills for Antigravity?"
  echo "  1) Globally (~/.gemini/config/skills)"
  echo "  2) Specific project path (.agents/skills)"
  
  local TARGET_DIR=""
  while true; do
    read -r -p "> " a_choice
    case "$a_choice" in
      1) TARGET_DIR="$HOME/.gemini/config/skills"; break ;;
      2)
        read -r -p "Enter absolute path to the project root: " custom_path
        TARGET_DIR="${custom_path}/.agents/skills"
        break
        ;;
      *) echo "Invalid selection. Please enter 1 or 2." ;;
    esac
  done
  
  echo "Installing to $TARGET_DIR..."
  mkdir -p "$TARGET_DIR"
  
  # Link or copy skills
  for skill in "$SKILLS_DIR"/*; do
    if [[ -d "$skill" ]]; then
      local skill_name
      skill_name=$(basename "$skill")
      mkdir -p "$TARGET_DIR/$skill_name"
      cp "$skill/SKILL.md" "$TARGET_DIR/$skill_name/"
      echo "✅ Installed $skill_name"
    fi
  done
  echo "Antigravity setup complete!"
}

# 3. Execute installation
case "$IDE_SELECTION" in
  "Cursor") install_cursor ;;
  "OpenCode") install_opencode ;;
  "Antigravity") install_antigravity ;;
esac

echo ""
echo "🎉 Installation finished! Disfrútalo, al chile."
