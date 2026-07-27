#!/usr/bin/env bash
set -euo pipefail

# combine_tsvs.sh — combine multiple TSV files vertically (stacking rows),
# renumbering the "site" column to run sequentially across every file, in
# whatever order you list them.
#
# Usage:
#   ./combine_tsvs.sh -o combined.tsv file1.tsv file2.tsv file3.tsv
#
# Options:
#   -o FILE   Output file (default: combined.tsv)
#   -c COL    Name of the column to renumber (default: site)
#
# Files are combined in the EXACT order you list them on the command line.
# The header is taken from the first file and written once. All other
# columns (e.g. "class") are left untouched.

output="combined.tsv"
id_col="site"

while getopts ":o:c:" opt; do
  case "$opt" in
    o) output="$OPTARG" ;;
    c) id_col="$OPTARG" ;;
    \?) echo "Usage: $0 [-o output.tsv] [-c id_column] file1.tsv file2.tsv ..." >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

if [ "$#" -eq 0 ]; then
  echo "Error: no input files given." >&2
  echo "Usage: $0 [-o output.tsv] [-c id_column] file1.tsv file2.tsv ..." >&2
  exit 1
fi

first_file="$1"
header=$(head -n 1 "$first_file")

id_index=$(awk -F'\t' -v col="$id_col" 'NR==1 { for (i=1; i<=NF; i++) if ($i==col) print i; exit }' "$first_file")

if [ -z "${id_index:-}" ]; then
  echo "Error: column '$id_col' not found in $first_file" >&2
  exit 1
fi

echo "$header" > "$output"

next_id=1
for f in "$@"; do
  this_header=$(head -n 1 "$f")
  if [ "$this_header" != "$header" ]; then
    echo "Warning: header in $f differs from the first file's header." >&2
  fi

  awk -F'\t' -v OFS='\t' -v idx="$id_index" -v start="$next_id" '
    FNR==1 { next }        # skip each file'\''s header
    NF==0  { next }        # skip blank lines
    { $idx = start + n; n++; print }
  ' "$f" >> "$output"

  count=$(awk -F'\t' 'FNR>1 && NF>0 { c++ } END { print c+0 }' "$f")
  next_id=$((next_id + count))
done

total=$(( $(wc -l < "$output") - 1 ))
echo "Wrote $total rows to $output"
