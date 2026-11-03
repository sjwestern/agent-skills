---
name: check-test-results
description: Scans test result files for failures across xUnit, VSTest, Playwright, and dotnet test. Emits AXI-compliant TOON output with aggregated counts, truncated failure lists, and a full-output escape hatch. Accepts a file or glob as a parameter, defaulting to test-results.*.
---

# check-test-results

The check-test-results skill scans test result files produced by common .NET and JavaScript test runners, including:

- xUnit (XML)
- VSTest (TRX)
- dotnet test (JSON or TRX)
- Playwright (JSON)

It performs a single-pass ripgrep scan using JSON streaming, ensuring:

- concurrency safety
- no repeated file scanning
- no shared state
- deterministic output
- minimal overhead even on large logs

This skill follows AXI’s 10 Principles by using TOON output, truncating large content, providing aggregated counts, offering a --full escape hatch, and giving contextual next-step suggestions.

## Usage

There is no `check-test-results` command on PATH. Run the `run.sh` script that sits next to this SKILL.md. Resolve it from the skill directory (the directory containing this file, wherever the skill is installed: `~/.agents/skills/`, `<repo>/.agents/skills/`, etc.). Do not guess a path or call it by name.

In the examples below, `$SKILL_DIR` is that directory, so `$SKILL_DIR/run.sh` is the script:

```bash
SKILL_DIR=<directory containing this SKILL.md>
dotnet test --logger "trx;LogFileName=results.trx"
"$SKILL_DIR/run.sh" results/*.trx
```

Other examples once test results exist:
```bash
"$SKILL_DIR/run.sh"
"$SKILL_DIR/run.sh" results/*.trx
"$SKILL_DIR/run.sh" results.json
"$SKILL_DIR/run.sh" --full
"$SKILL_DIR/run.sh" results.xml --full
SHOW_ALL=1 "$SKILL_DIR/run.sh"
```

## Help

"$SKILL_DIR/run.sh" --help

Outputs TOON help:

st:ok;help:"check-test-results scans test result files and emits TOON summaries. Usage: run.sh [file] [--full]. Default file glob: test-results.*. Flags: --full shows all failures. Output fields: st, tot, lim, rem, all, sug, file."

## Output Format (TOON)

Success:
st:ok;tot:0;sug:"No failures detected";file:"/path/to/file/test-results-XXX.xml"

Error:
st:err;msg:"File not found";sug:"Pass a valid file or glob";file:"/path/to/file/test-results-XXX.xml"

Failure (truncated):
st:fail;tot:14;lim:["TestA","TestB"];rem:12;sug:"Run with --full for all failures";file:"/path/to/file/test-results-XXX.xml"

Full output:
st:fail;tot:14;all:["TestA","TestB",...];sug:"Review failing tests";file:"/path/to/file/test-results-XXX.xml"

## Entrypoint

The skill runs run.sh in the same directory. Ensure it is executable using chmod +x run.sh.

## Notes

- Stateless
- Concurrency-safe
- Single-pass scanning
- No dependencies beyond rg and jq
- AXI TOON compliant
