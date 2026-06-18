
csv_data <- read.csv("COMPLEX4_ALL_RECURS.csv", header = FALSE)
unique_values <- csv_data[[1]]

df <- data.frame(
  Recur_yes    = integer(1860),
  Recur_no     = integer(1860),
  Not_analysed = integer(1860)
)

# Set Recur_yes to 1 for rows corresponding to unique values
df$Recur_yes[unique_values] <- 1

# Manual fill of N/A residues, those with X in
# ~/tirocinio_magistrale/01_analyses/05_contact/Recur_correspondents
df$Not_analysed[1005:1010] <- 1
df$Not_analysed[1154:1360] <- 1
df$Not_analysed[1446:1558] <- 1
df$Not_analysed[1764:1808] <- 1


# Fill Recur_no with 1 where both Recur_yes and Not_analysed are 0
df$Recur_no[df$Recur_yes == 0 & df$Not_analysed == 0] <- 1

# Check that each row has exactly one 1
all(rowSums(df) == 1)

write.csv(df, "C4_dataframe_posizioni_recur_si_no_NA.csv", row.names = FALSE)
