#!/usr/bin/env bash
#
# Associate a sequence of amino-acid letters with a column of values,
# skipping 'X' (missing-region) positions.
#
# Sequence file: raw sequence, possibly split across multiple lines.
# Values file:   a single unbroken string of characters (e.g. "121112..."),
#                each character is treated as one value.
#
# Usage:
#   ./assign_values.sh -s sequence.txt -v values.txt -o result.tsv [-m NA]

set -euo pipefail

missing_placeholder="NA"

usage() {
    echo "Usage: $0 -s sequence.txt -v values.txt -o result.tsv [-m missing_placeholder]" >&2
    exit 1
}

while getopts ":s:v:o:m:" opt; do
    case "$opt" in
        s) seq_file="$OPTARG" ;;
        v) values_file="$OPTARG" ;;
        o) out_file="$OPTARG" ;;
        m) missing_placeholder="$OPTARG" ;;
        *) usage ;;
    esac
done

if [[ -z "${seq_file:-}" || -z "${values_file:-}" || -z "${out_file:-}" ]]; then
    usage
fi

# Read sequence: strip everything except letters (A-Z, a-z)
sequence=$(tr -cd 'A-Za-z' < "$seq_file")

# Read values: strip all whitespace, keep every remaining character
values=$(tr -d '[:space:]' < "$values_file")

seq_len=${#sequence}
val_len=${#values}

# Count non-X letters in the sequence
non_x_count=$(tr -d 'X' <<< "$sequence" | tr -d '\n' | wc -c)

if [[ "$non_x_count" -ne "$val_len" ]]; then
    echo "WARNING: number of non-X letters ($non_x_count) does not match number of values ($val_len)." >&2
fi

val_idx=0
{
    for (( i=0; i<seq_len; i++ )); do
        c="${sequence:$i:1}"
        if [[ "$c" == "X" ]]; then
            printf "%s\t%s\n" "$c" "$missing_placeholder"
        else
            if (( val_idx < val_len )); then
                v="${values:$val_idx:1}"
                val_idx=$((val_idx+1))
            else
                v="$missing_placeholder"
                echo "WARNING: ran out of values before sequence ended." >&2
            fi
            printf "%s\t%s\n" "$c" "$v"
        fi
    done
} > "$out_file"

echo "Wrote $seq_len rows to $out_file"
