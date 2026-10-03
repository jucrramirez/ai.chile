---
name: elchalan
description: >
  Set the persistent ai.chile auditor intensity to godin, chakaloso,
  chambeador, or off. Use when the user says "elchalan" or wants to change
  ai.chile audit intensity.
---

# El Chalan

Set the persistent auditor intensity without changing project files. Accept
one argument: `godin`, `chakaloso`, `chambeador`, or `off`. If the user gives
no argument, use `chakaloso`. Reject any other value and show the valid modes.

Write exactly the selected value followed by a newline to
`${XDG_CONFIG_HOME:-~/.config}/ai.chile/mode`, creating the parent directory
if needed. Then confirm the selected mode:

- `godin`: low, fast, and pragmatic.
- `chakaloso`: medium, focused, and critical.
- `chambeador`: high, exhaustive, and maximum effort.
- `off`: disable the auditor overlay.

This state affects only `elmatamuertos` and `elmatachingaderas`. It never
changes `elmatabichos`. It is intentionally shared with OpenCode so the mode
survives sessions and is consistent across installed ai.chile clients.
