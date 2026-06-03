library(jsonlite)

# Load the JSON file
data <- fromJSON("fold_complex_2_peptides_fixed_full_data_0.json")

# Extract contact_probs (it's a matrix/list of lists)
contact_probs <- data$contact_probs

# Convert to dataframe
df <- as.data.frame(contact_probs)

#creates additional df from contact matrix to use later
df_matrix <- as.data.frame(data$contact_probs)

#loading the data csv from .cif file, adding aa names + recur coordinates as a column
csv_data <- read.csv('complex2_indexing.csv', header=FALSE, sep=" ") 
df <- cbind(csv_data[, 1:2], df)

#adding aa names as a row 
new_row <- as.data.frame(matrix(NA, nrow=1, ncol=ncol(df)))
colnames(new_row) <- colnames(df)
new_row[1, 3:ncol(df)] <- df$V2
df <- rbind(new_row, df)

#adding universal coordinates as column
new_col <- c(NA, 1:1167)
df <- cbind(index = new_col, df)

#adding nuc/mit characterization as column
nuc_or_mit_col <- c(NA, ifelse(as.numeric(trimws(sub(",.*", "", df$V1[-1]))) < 1, "mit", "nuc"))
df <- cbind(nuc_or_mit_col = nuc_or_mit_col, df)

#adding recur coordinates as row
new_row2 <- as.data.frame(matrix(NA, nrow=1, ncol=ncol(df)))
colnames(new_row2) <- colnames(df)
new_row2[1, 5:ncol(df)] <- csv_data[, 1]
df <- rbind(new_row2, df)

#adding universal coordinates as row
new_row5 <- as.data.frame(matrix(c(NA, NA, NA, NA, 1:1167), nrow=1))
colnames(new_row5) <- colnames(df)
df <- rbind(new_row5, df)

#adding nuc/mit characterization as column
nucmitrow <- c(NA, NA, NA, NA, ifelse(as.numeric(trimws(sub(",.*", "", as.character(df[2, 5:ncol(df)])))) < 1, "mit", "nuc"))
new_row_df <- as.data.frame(matrix(nucmitrow, nrow=1))
colnames(new_row_df) <- colnames(df)
df <- rbind(new_row_df, df)

#creates dataframe of coordinates of values over 0.5, then removes all reciprocals and squares, adds 4 to match
#df row and column names, reorders columns
all_true = which((df_matrix > 0.5) == TRUE, arr.ind=TRUE)
all_true <- all_true[all_true[,1] < all_true[,2], ]
all_true <- all_true + 4

results_df <- do.call(rbind, lapply(1:nrow(all_true), function(i) {
  r <- all_true[i, "row"]
  c <- all_true[i, "col"]
  
  c(as.character(df[r, 1:4]), as.character(df[1:4, c]), as.character(df[r, c]))
}))

results_df <- as.data.frame(results_df)
colnames(results_df) <- c("row1", "row2", "row3", "row4", "col1", "col2", "col3", "col4", "value")
results_df <- results_df[, c("row4", "row3", "row2", "col4", "col3", "col2", "row1", "col1", "value")]
names(results_df) <- c("AA1", "SubPos1", "GloPos1", "AA2", "SubPos2", "GloPos2", "AA1Type", "AA2Type", "Prob")

#exports as tsv
write.table(results_df, "results.tsv", sep = "\t", row.names = FALSE, quote = FALSE)