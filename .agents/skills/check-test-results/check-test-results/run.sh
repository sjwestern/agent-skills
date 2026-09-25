#!/usr/bin/env bash
set -e

# Help mode
if [ "$1" = "--help" ]; then
    echo "st:ok;help:\"check-test-results scans test result files and emits TOON summaries. Usage: check-test-results [file] [--full]. Default file glob: test-results.*. Flags: --full shows all failures. Output fields: st, tot, lim, rem, all, sug.\""
    exit 0
fi

FILE="$1"
FULL=0

# Flag handling
if [ "$SHOW_ALL" = "1" ] || [ "$2" = "--full" ] || [ "$1" = "--full" ]; then
    FULL=1
fi

# If first arg is --full, shift file arg
if [ "$1" = "--full" ]; then
    FILE="$2"
fi

# Default file glob
if [ -z "$FILE" ]; then
    FILE="test-results.*"
fi

# Validate file existence (AXI Principle 5 + 6)
if ! ls $FILE >/dev/null 2>&1; then
    echo "st:err;msg:\"File not found\";sug:\"Pass a valid file or glob\";file:\"$FILE\";"
    exit 1
fi

TMPFILE=$(mktemp)
LIMITED=$(mktemp)

# Single-pass scan including dotnet summary + xUnit console detection
rg --json \
    -e '"status":\s*"failed"' \
    -e '"outcome":\s*"Failed"' \
    -e '<Outcome>Failed' \
    -e 'outcome="Failed"' \
    -e '<failure' \
    -e '^Failed!\s+-\s+Failed:\s*[1-9]' \
    -e '\[xUnit\.net.*' \
    -e '\[FAIL\]' \
    -e '^Failed\s+.*\s' \
    -e '\[[0-9]+ ms\]' \
    $FILE \
| jq -r '
    select(.type=="match")
    | .data.submatches[].match.text
' \
| tee "$TMPFILE" \
| head -n 10 > "$LIMITED"

TOT=$(wc -l < "$TMPFILE")
LIM=$(wc -l < "$LIMITED")
REM=$((TOT - LIM))

# Empty state
if [ "$TOT" -eq 0 ]; then
    echo "st:ok;tot:0;sug:\"No failures detected\";file:\"$FILE\""
    rm "$TMPFILE" "$LIMITED"
    exit 0
fi

# Full output mode
if [ "$FULL" -eq 1 ]; then
    ALL=$(sed 's/"/\\"/g' "$TMPFILE" | awk '{printf "\"%s\",", $0}' | sed 's/,$//')
    echo "st:fail;tot:$TOT;all:[$ALL];sug:\"Review failing tests\";file:\"$FILE\""
else
    LIMJSON=$(sed 's/"/\\"/g' "$LIMITED" | awk '{printf "\"%s\",", $0}' | sed 's/,$//')
    echo "st:fail;tot:$TOT;lim:[$LIMJSON];rem:$REM;sug:\"Run with --full for all failures\";file:\"$FILE\""
fi

rm "$TMPFILE" "$LIMITED"
