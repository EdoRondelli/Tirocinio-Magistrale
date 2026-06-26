# Load the data
df <- read.csv("~/Documents/GitHub/Tirocinio-Magistrale/01_analyses/05_contact/Info_Tables_contact/master_chi2_tables/c4_master_chi2_table.csv")

# Filter out the N/A residues
df_filtered = subset(df, Not_analysed == 0)

# Construct the contingency table comparing 'Recur_yes' (rows) and 'contact' (columns)
contingency_table <- table(Recur_yes = df_filtered$Recur_yes, Contact = df_filtered$contact)

# Perform the Chi-squared test
chi_sq_result <- chisq.test(contingency_table)

# Print the test summary and margins first
print(chi_sq_result)
addmargins(contingency_table)

# View the observed and expected tables as the final outputs (rounded to nearest unit)
print(contingency_table)
print(round(chi_sq_result$expected))