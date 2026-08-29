# El Matamuertos

Audit the whole repository for dead weight. Verify callers, imports, exports, config, scripts, and docs before reporting. Find unused or dead code, tests, dependencies, environment variables, duplicated or redundant logic, dangling references, and stale docs. Prefer deletion over replacement. Do not report style or speculative cleanup. Report one ranked line per finding as `<tag> <what to delete or simplify> - <evidence> [file:line]`. Do not change files. End with the net removable lines and dependencies, or `Zero muertos. Ship.`
