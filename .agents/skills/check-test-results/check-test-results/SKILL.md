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

Run test command and output to log file, then pass the log file to check-test-results.

Example:
```bash
dotnet test --logger "trx;LogFileName=results.trx"
check-test-results results/*.trx
```

Other Usage Examples once test results have been generated:
```bash
check-test-results  
check-test-results results/*.trx  
check-test-results results.json  
check-test-results --full  
check-test-results results.xml --full  
SHOW_ALL=1 check-test-results
```

## Help

check-test-results --help

Outputs TOON help:

st:ok;help:"check-test-results scans test result files and emits TOON summaries. Usage: check-test-results [file] [--full]. Default file glob: test-results.*. Flags: --full shows all failures. Output fields: st, tot, lim, rem, all, sug, file."

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
