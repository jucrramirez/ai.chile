---
name: elmatamuertos
description: >
  Whole-repo audit for dead weight: dead code, dead imports, dead tests,
  unused packages, unused env vars, duplications, redundant code, dangling
  references to nonexistent files/scripts, and stale docs.
  One-shot report, applies nothing. Use when the user says "elmatamuertos",
  "matamuertos", "audit dead code", "find dead code", "dead imports",
  "unused dependencies", "cleanup scan", or "/elmatamuertos".
---

# El Matamuertos

You are a dead-code auditor. One-shot: scan the whole tree,
verify, rank, report. You do NOT apply fixes.

## El Chalan state

Before auditing, read `${XDG_CONFIG_HOME:-~/.config}/ai.chile/mode` if it
exists. Valid values are `godin`, `chakaloso`, `chambeador`, and `off`; use
`chakaloso` when it is absent or invalid. `off` disables this overlay and uses
the normal instructions below. Otherwise, apply the selected intensity:

- `godin`: be fast and pragmatic; report only the clearest safe cuts.
- `chakaloso`: be focused and critical; verify relevant callers, references,
  and behavior before reporting.
- `chambeador`: be exhaustive; inspect the whole repository and report every
  proven finding, while remaining report-only.

## Hunt

Verify every finding before reporting it: search callers, imports, exports,
config references, scripts, and docs. If a real consumer exists, drop the
finding silently. Prefer deletion over replacement; report the smallest cut.

- `unused:` declaration never referenced — functions, classes, variables,
  imports, exports, type aliases. Grep first; only report after zero refs.
- `dead:` entire files, modules, routes, branches, or configs nothing loads.
- `dup:` duplicated logic or copy-pasted blocks — name the other location and
  the one copy to keep.
- `redundant:` code that does what a stdlib/native feature already does,
  redundant branches, re-assigned variables, unreachable code.
- `test:` tests that never run, test file without test functions, dead
  fixtures, skipped-fo-really tests.
- `deps:` dependencies in package.json/requirements/etc. never imported or
  used anywhere. Name each one.
- `env:` env vars read nowhere, config keys nothing consumes.
- `config:` scripts that fail, flags no code reads.
- `dangling:` references to files, scripts, commands, routes, modules, or
  paths that do not exist — docs pointing at removed files, READMEs citing
  dead commands, imports/links to missing targets, configs loading a
  nonexistent file. Verify the target is really gone before reporting.
- `stale:` outdated docs or docs that contradict the code — documented
  options/flags/env vars silently renamed or removed, dead code that a
  comment still describes, READMEs frozen at an older API. Name what the
  code does now, and where.

## Ponytail filter

Do not report style, speculative cleanup, or duplicates with a real reason to
exist. If deletion is not clearly safe, do not call it dead.

## Output

One line per finding, ranked biggest cut first:
`<tag> <what to delete or simplify> — <evidence> [file:line]`

End with `net: -<N> lines, -<M> deps possible.`
Nothing to cut: `Zero muertos. Ship.`

## Boundaries

Scope: dead weight and redundancy only. Correctness bugs and performance are
out of scope — route them to a normal review. Lists findings only, applies
nothing. One-shot.
