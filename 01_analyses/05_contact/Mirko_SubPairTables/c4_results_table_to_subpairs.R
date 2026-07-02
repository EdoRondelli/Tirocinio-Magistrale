
# INPUT: your existing dataframe, e.g. df <- read.csv("contacts.csv")
# Expected columns: AA1, SubPos1, GloPos1, AA2, SubPos2, GloPos2, AA1Type, AA2Type, Prob
# SubPos1 / SubPos2 look like "9, 52"  ->  subunit 9, residue 52
# ---------------------------------------------------------------------------
df <- read.delim("/home/STUDENTI/edoardo.rondelli/Documents/GitHub/Tirocinio-Magistrale/01_analyses/05_contact/Info_Tables_contact/MATRIX_COMPLEX4_WORK/results.tsv", header = TRUE, sep = "\t", quote = "", stringsAsFactors = FALSE)

# 1. Parse subunit number out of "SubPosN" columns (residue position is
#    parsed too but not used further here, so feel free to drop it) --------
df$Sub1_raw <- as.integer(sub(",.*", "", df$SubPos1))
df$Sub2_raw <- as.integer(sub(",.*", "", df$SubPos2))

# 2. Unordered subunit pair per contact row ---------------------------------
df$Sub1 <- pmin(df$Sub1_raw, df$Sub2_raw)
df$Sub2 <- pmax(df$Sub1_raw, df$Sub2_raw)

# 3. Count contact rows per subunit pair ------------------------------------
counts <- aggregate(
  x = list(n_contacting_aa_pairs = df$Sub1),
  by = list(Sub1 = df$Sub1, Sub2 = df$Sub2),
  FUN = length
)

# 4. Blank length columns - fill in yourself afterwards if needed ----------
counts$sub1_length <- NA
# INPUT: your existing dataframe, e.g. df <- read.csv("contacts.csv")
counts$sub2_length <- NA

contact_table <- counts[, c("Sub1", "Sub2", "sub1_length", "sub2_length", "n_contacting_aa_pairs")]
contact_table <- contact_table[order(contact_table$Sub1, contact_table$Sub2), ]
rownames(contact_table) <- NULL

contact_table <- contact_table[contact_table$Sub1 %in% 1:3 | contact_table$Sub2 %in% 1:3, ]
rownames(contact_table) <- NULL
contact_table <- contact_table[contact_table$Sub1 != contact_table$Sub2, ]
rownames(contact_table) <- NULL

contact_table$sub1_length[1:12] <-516
contact_table$sub1_length[13:19] <-227
contact_table$sub1_length[20:24] <-261
contact_table$sub2_length[1] <-227
contact_table$sub2_length[2] <-227
contact_table$sub2_length[3] <-149
contact_table$sub2_length[4] <-98
contact_table$sub2_length[5] <-85
contact_table$sub2_length[6] <-79
contact_table$sub2_length[7] <-76
contact_table$sub2_length[8] <-60
contact_table$sub2_length[9] <-56
contact_table$sub2_length[10] <-47
contact_table$sub2_length[11] <-44
contact_table$sub2_length[12] <-53
contact_table$sub2_length[13] <-227
contact_table$sub2_length[14] <-149
contact_table$sub2_length[15] <-109
contact_table$sub2_length[16] <-79
contact_table$sub2_length[17] <-76
contact_table$sub2_length[18] <-56
contact_table$sub2_length[19] <-53
contact_table$sub2_length[20] <-98
contact_table$sub2_length[21] <-85
contact_table$sub2_length[22] <-79
contact_table$sub2_length[23] <-60
contact_table$sub2_length[24] <-53

write.table(contact_table, "mirko_subcontacts_C4.tsv", sep = "\t", row.names = FALSE, quote = FALSE)
