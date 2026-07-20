#!/bin/bash
#
# check_tsv_extraction.sh
#
# Verifies that every *_NEB.txt / *_BEB.txt file in the current directory has
# a matching, complete .tsv produced by extract_tsv.sh. For each pair it checks:
#   1. The .tsv file exists
#   2. The number of site rows in the .tsv matches the number of site rows
#      found in the source .txt (nothing dropped or duplicated)
#   3. The site numbers in the .tsv form a clean, gapless 1..N sequence
#      (codeml always numbers sites this way, so any gap/duplicate/reorder
#      is a red flag)
#   4. Every row is a clean "site<TAB>class" numeric pair
#
# Usage:
#   ./check_tsv_extraction.sh

set -uo pipefail

shopt -s nullglob
files=( *_NEB.txt *_BEB.txt )
shopt -u nullglob

if [ ${#files[@]} -eq 0 ]; then
    echo "No *_NEB.txt or *_BEB.txt files found in $(pwd)."
    exit 1
fi

problems=0
checked=0

for f in "${files[@]}"; do
    base="${f%.txt}"
    tsv="${base}.tsv"
    checked=$((checked + 1))

    if [ ! -f "$tsv" ]; then
        echo "MISSING:   $tsv  (no TSV found for $f)"
        problems=$((problems + 1))
        continue
    fi

    # Count real per-site data rows in the source .txt: a site number
    # followed eventually by a "( N )" class marker (same rule the
    # extractor uses).
    src_count=$(grep -cE '^[[:space:]]*[0-9]+[[:space:]].*\([[:space:]]*[0-9]+[[:space:]]*\)' "$f")

    # Count data rows in the tsv (total lines minus the header)
    tsv_count=$(( $(wc -l < "$tsv") - 1 ))

    if [ "$src_count" -ne "$tsv_count" ]; then
        echo "MISMATCH:  $f has $src_count site row(s) but $tsv has $tsv_count"
        problems=$((problems + 1))
        continue
    fi

    # Site numbers should be a clean 1..N sequence, in order, no gaps/dupes
    expected=$(seq 1 "$tsv_count")
    actual=$(tail -n +2 "$tsv" | cut -f1)
    if [ "$expected" != "$actual" ]; then
        echo "GAP/ORDER: $tsv site numbers are not a clean 1..$tsv_count sequence"
        problems=$((problems + 1))
        continue
    fi

    # Every data row should be exactly "digits<TAB>digits"
    bad=$(tail -n +2 "$tsv" | grep -vcE $'^[0-9]+\t[0-9]+$')
    if [ "$bad" -ne 0 ]; then
        echo "MALFORMED: $tsv has $bad row(s) that aren't clean 'site<TAB>class' pairs"
        problems=$((problems + 1))
        continue
    fi
done

echo
echo "Checked $checked file(s). Problems found: $problems"
if [ "$problems" -eq 0 ]; then
    echo "All good — every NEB/BEB file has a complete, correctly formatted TSV."
fi
