#!/bin/bash
#
# extract_beb_neb.sh
#
# For every CODEML results file in the current directory, extract the
# Bayes Empirical Bayes (BEB) section if present, otherwise the
# Naive Empirical Bayes (NEB) section, and write it to a companion file.
#
# Usage:
#   ./extract_beb_neb.sh            # processes *.rst in the current dir
#   ./extract_beb_neb.sh "*.txt"    # or point it at a different pattern
#
# Output:
#   For cox1.rst it writes either cox1_BEB.txt or cox1_NEB.txt
#   next to the original file.

set -euo pipefail

pattern="${1:-*.rst}"

shopt -s nullglob
files=( $pattern )
shopt -u nullglob

if [ ${#files[@]} -eq 0 ]; then
    echo "No files matching pattern '$pattern' found in $(pwd)."
    exit 1
fi

neb_header="Naive Empirical Bayes (NEB)"
beb_header="Bayes Empirical Bayes (BEB)"

processed=0
skipped=0

for f in "${files[@]}"; do
    # skip files this script already generated, in case it's re-run
    if [[ "$f" == *_NEB.txt || "$f" == *_BEB.txt ]]; then
        continue
    fi

    base="${f%.*}"

    if grep -qF "$beb_header" "$f"; then
        header="$beb_header"
        tag="BEB"
    elif grep -qF "$neb_header" "$f"; then
        header="$neb_header"
        tag="NEB"
    else
        echo "  [skip] $f: no NEB or BEB section found"
        skipped=$((skipped + 1))
        continue
    fi

    outfile="${base}_${tag}.txt"

    {
        echo "# Extracted from ${f}: ${tag} section"
        echo
        awk -v hdr="$header" '
            {
                if (!capturing) {
                    if (index($0, hdr) > 0) { capturing = 1 } else { next }
                }
                # Explicit end-of-section markers used by CODEML .rst files:
                # - a line reporting lnL (appears right after the NEB block)
                # - the start of ancestral reconstruction (appears right after BEB)
                if (index($0, "lnL") > 0) exit
                if (index($0, "Ancestral reconstruction by CODONML.") > 0) exit
                # Fallback safety net: two consecutive blank lines also ends a block,
                # in case a file uses different wording for the markers above.
                if ($0 == "") {
                    blank++
                    if (blank >= 2) exit
                } else {
                    blank = 0
                }
                print
            }
        ' "$f"
    } | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' > "$outfile"

    # quick sanity-check preview: first and last non-comment/non-blank line
    first_line=$(grep -m1 -v '^#\|^$' "$outfile")
    last_line=$(grep -v '^#\|^$' "$outfile" | tail -n1)

    echo "  [ok]   $f -> $outfile  (${tag} section)"
    echo "           first: $first_line"
    echo "           last:  $last_line"
    processed=$((processed + 1))
done

echo
echo "Done. Extracted: $processed  Skipped (no NEB/BEB found): $skipped"
