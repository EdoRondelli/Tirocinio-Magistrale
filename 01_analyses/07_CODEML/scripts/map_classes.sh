#!/usr/bin/env bash
#
# map_classes.sh
#
# Merge a FASTA (.faa) sequence with a TSV of (position, class) annotations,
# producing a 2-column TSV: residue, class (or "NA" if that position has no
# class listed in the annotation file).
#
# USAGE:
#   ./map_classes.sh sequence.faa positions.tsv output.tsv
#
# ASSUMPTIONS (adjust the script if any of these don't match your data):
#   1. The .faa file contains a SINGLE sequence (one or more lines after the
#      ">" header). All non-header lines are concatenated in order to form
#      the full sequence.
#   2. Positions are 1-indexed, matching the residue's order in that
#      concatenated sequence (position 1 = first residue, etc).
#   3. The TSV is tab-delimited with position in column 1 and class in
#      column 2. A header row (non-numeric first column) is auto-detected
#      and skipped.
#   4. Not every position needs to appear in the TSV — missing ones get "NA".
#
set -euo pipefail

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input.faa> <input.tsv> <output.tsv>" >&2
    exit 1
fi

faa="$1"
tsv="$2"
out="$3"

awk -v tsv="$tsv" '
BEGIN {
    # Build position -> class lookup table from the TSV
    while ((getline line < tsv) > 0) {
        n = split(line, f, "\t")
        pos = f[1]
        cls = f[2]
        # Skip header / malformed rows where position is not a plain integer
        if (pos !~ /^[0-9]+$/) continue
        classmap[pos] = cls
    }
    close(tsv)
}
# Skip FASTA header line(s)
/^>/ { next }
# Concatenate all sequence lines into one string
{ seq = seq $0 }
END {
    n = length(seq)
    for (i = 1; i <= n; i++) {
        residue = substr(seq, i, 1)
        cls = (i in classmap) ? classmap[i] : "NA"
        print residue "\t" cls
    }
}
' "$faa" > "$out"

echo "Done. Wrote $(wc -l < "$out") residues to $out"
