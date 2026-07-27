#!/bin/bash
#
# extract_tsv.sh
#
# For every *_NEB.txt / *_BEB.txt file (produced by extract_beb_neb.sh) in
# the current directory, pull out a 2-column TSV of:
#   site   class
# where "class" is the number in parentheses on each site's row, e.g.
#   1 M   1.00000 0.00000 ( 1)  0.124        -> 1<TAB>1
#  49 Y   0.00000 0.15265 0.84735 ( 3)  1.504 -> 49<TAB>3
#
# Only real per-site data rows are matched (site number ... ( class ) ...).
# Header lines, blank lines, and "Positively selected sites" summary rows
# (which have no parentheses) are automatically skipped.
#
# Usage:
#   ./extract_tsv.sh
#
# Output:
#   OG0011172_00_NEB.txt -> OG0011172_00_NEB.tsv
#   OG0012118_00_BEB.txt -> OG0012118_00_BEB.tsv

set -euo pipefail

shopt -s nullglob
files=( *_NEB.txt *_BEB.txt )
shopt -u nullglob

if [ ${#files[@]} -eq 0 ]; then
    echo "No *_NEB.txt or *_BEB.txt files found in $(pwd)."
    exit 1
fi

processed=0

for f in "${files[@]}"; do
    base="${f%.txt}"
    outfile="${base}.tsv"

    {
        printf "site\tclass\n"
        sed -nE 's/^[[:space:]]*([0-9]+)[[:space:]].*\([[:space:]]*([0-9]+)[[:space:]]*\).*/\1\t\2/p' "$f"
    } > "$outfile"

    n=$(( $(wc -l < "$outfile") - 1 ))
    echo "  [ok] $f -> $outfile  ($n sites)"
    processed=$((processed + 1))
done

echo
echo "Done. Converted: $processed"
