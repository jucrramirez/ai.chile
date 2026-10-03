# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- Add Codex and Claude Code installation targets using their native skill
  directories.
- Add the portable `elchalan` skill and share its persisted intensity state
  with OpenCode.
- Add `elbuscabichos`, a report-only bug auditor with whole-repository and
  `webon` (uncommitted changes only) modes.
- Install Copilot workflows as portable Agent Skills, including global
  `~/.copilot/skills` support.

## [1.1.0] - 2026-10-03

### Added
- **OpenCode V2 plugin support**: the plugin now uses `Plugin.define()` from `@opencode/plugin` when running on OpenCode V2, while keeping full V1 backward compatibility.
- Installer writes both `"plugins"` (V2) and `"plugin"` (V1) keys to the config file so the plugin works on either version.
- Installer now supports `opencode.jsonc` files with `//` and `/* */` comments; prefers `.jsonc` when both files exist.
- Skills path is added to the `"skills"` config array for V2 auto-discovery.
- `@opencode/plugin` declared as an optional `peerDependency`.
- Interactive `install.sh` script to streamline the setup process for Cursor and OpenCode.
- Added the persistent **elchalan** orchestrator with `godin`, `chakaloso`, and `chambeador` auditor modes.
- `.gitignore` configured to ignore local context, OS files, dependencies, and temporary artifacts.
- Explicit **Acknowledgements & References** section in `README.md` referencing the Ponytail project and Dietrich Gebert.

### Changed
- V1 plugin path now prints a deprecation warning at load time recommending migration to V2.
- Shared helper functions extracted in the plugin to avoid duplication between V1 and V2 code paths.
- `README.md` updated with V2 manual setup instructions and migration notes.
- **install.sh**: Excluded `elmatabichos` from Cursor installations, as Cursor already has a native Agent Debug mode.
- Renamed project from `elmatabichos` to `ai.chile` to better reflect the new Mexican-inspired scope and philosophy.
- Re-structured documentation to match the new vision and layout (inspired by NLPie).

## [1.0.0] - Initial Fork

### Added
- Core plugins based on the Ponytail project.
- `elmatabichos`, `elmatachingaderas`, and `elmatamuertos` skills.
