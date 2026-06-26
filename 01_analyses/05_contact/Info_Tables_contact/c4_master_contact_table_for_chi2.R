#import the table containing all residues as rows and reucr yes/no/NA
all_residues_recur <- read.csv("Complex4_matched_recur/C4_dataframe_posizioni_recur_si_no_NA.csv")

#import the table containing all information about the residues in contact
contact_residue_info <- read.csv("MATRIX_COMPLEX4_WORK/unique_ordered_4.csv")

# Add the contact column
# Convert both to numeric before comparing
all_residues_recur$contact <- as.integer(as.numeric(rownames(all_residues_recur)) %in% as.numeric(contact_residue_info$GloPos1))

# Save the updated table back to CSV
write.csv(all_residues_recur, "master_chi2_tables/c4_master_chi2_table.csv", row.names = FALSE)

