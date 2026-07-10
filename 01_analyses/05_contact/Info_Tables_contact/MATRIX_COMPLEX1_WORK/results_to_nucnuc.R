# remove same-subunit pairs first
subunit1 <- as.numeric(sub(",.*", "", results_df$SubPos1))
subunit2 <- as.numeric(sub(",.*", "", results_df$SubPos2))
results_df <- results_df[subunit1 != subunit2, ]

# keeping only nuc-nuc pairs
results_filtered <- results_df[(results_df$AA1Type == "nuc" & results_df$AA2Type == "nuc"), ]

# stacking the pairs on top of each other
filtered1 <- results_filtered[, c(1, 2, 3, 7)]
filtered2 <- results_filtered[, c(4, 5, 6, 8)]
combined_filtered <- rbind(filtered1, setNames(filtered2, names(filtered1)))

# ordering, treating as number, making unique
ordered <- combined_filtered[order(as.numeric(combined_filtered$GloPos1)), ]
unique_ordered <- ordered[!duplicated(ordered$GloPos1), ]
write.csv(unique_ordered, "unique_ordered_nucnuc_1.csv", row.names = FALSE)
