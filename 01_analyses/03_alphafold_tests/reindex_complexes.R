# Read the PDB file
lines <- readLines("~/c4_test.pdb")

# Identify rows with atom data
atom_idx <- which(grepl("^ATOM|^HETATM", lines))

# Extract the original chains and residue numbers
chains <- substr(lines[atom_idx], 22, 22)
resnos <- substr(lines[atom_idx], 23, 26)

# Create a continuous global index based on unique chain-residue combinations
residue_ids <- paste(chains, resnos, sep = "_")
global_resnos <- match(residue_ids, unique(residue_ids))

# Vectorized replacement: Set all chains to 'A' and insert new sequence numbers
substr(lines[atom_idx], 22, 22) <- rep("A", length(atom_idx))
substr(lines[atom_idx], 23, 26) <- sprintf("%4d", global_resnos)

# Save the unified file
writeLines(lines, "C4_redinexed.pdb")