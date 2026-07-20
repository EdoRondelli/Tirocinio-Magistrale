#import the table containing all residues as rows and reucr yes/no/NA
all_residues_recur <- read.csv("Complex4_Dimer_matched_recur/C4_dimer_dataframe_posizioni_recur_si_no_NA.csv")

#import the table containing all information about the residues in contact
contact_residue_info <- read.csv("MATRIX_COMPLEX4_DIMER_WORK/unique_ordered_nucnuc_4_dimer.csv")

# Add the contact column
# Convert both to numeric before comparing
all_residues_recur$contact <- as.integer(as.numeric(rownames(all_residues_recur)) %in% as.numeric(contact_residue_info$GloPos1))

# Save the updated table back to CSV
write.csv(all_residues_recur, "master_chi2_tables/c4_dimer_master_chi2_table_nucnuc.csv", row.names = FALSE)

