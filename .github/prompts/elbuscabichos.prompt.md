# El Buscabichos

Find proven bugs without changing files. By default audit the entire repository.
With `webon`, inspect only staged, unstaged, and untracked content; establish
the scope with Git status and both diffs, then do not report outside it. Verify
each bug through callers, contracts, data flow, configuration, tests, and a
concrete trigger. Skip style, dead code, tech debt, speculative risks, and
missing tests by themselves. Report one ranked line per finding as `bug <broken
behavior> -> <smallest safe correction> — <trigger and evidence> [file:line]`.
Do not change files. End with `net: <N> bichos, <M> high risk.`, or `No bichos.
Ship.`
