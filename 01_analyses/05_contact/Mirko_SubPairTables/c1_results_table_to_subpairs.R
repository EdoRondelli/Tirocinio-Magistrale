
# INPUT: your existing dataframe, e.g. df <- read.csv("contacts.csv")
# Expected columns: AA1, SubPos1, GloPos1, AA2, SubPos2, GloPos2, AA1Type, AA2Type, Prob
# SubPos1 / SubPos2 look like "9, 52"  ->  subunit 9, residue 52
# ---------------------------------------------------------------------------
df <- read.delim("/home/STUDENTI/edoardo.rondelli/Documents/GitHub/Tirocinio-Magistrale/01_analyses/05_contact/Info_Tables_contact/MATRIX_COMPLEX1_WORK/results.tsv", header = TRUE, sep = "\t", quote = "", stringsAsFactors = FALSE)

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

contact_table <- contact_table[contact_table$Sub1 %in% 1:7 | contact_table$Sub2 %in% 1:7, ]
rownames(contact_table) <- NULL
contact_table <- contact_table[contact_table$Sub1 != contact_table$Sub2, ]
rownames(contact_table) <- NULL
contact_table$sub1_length[1:5] <-324
contact_table$sub1_length[6:11] <-346
contact_table$sub1_length[12:16] <-116
contact_table$sub1_length[17:18] <-459
contact_table$sub1_length[19:21] <-98
contact_table$sub1_length[22:23] <-605
contact_table$sub2_length[1] <-116
contact_table$sub2_length[2] <-173
contact_table$sub2_length[3] <-179
contact_table$sub2_length[4] <-183
contact_table$sub2_length[5] <-430
contact_table$sub2_length[6] <-116
contact_table$sub2_length[7] <-459
contact_table$sub2_length[8] <-98
contact_table$sub2_length[9] <-605
contact_table$sub2_length[10] <-173
contact_table$sub2_length[11] <-430
contact_table$sub2_length[12] <-98
contact_table$sub2_length[13] <-173
contact_table$sub2_length[14] <-179
contact_table$sub2_length[15] <-211
contact_table$sub2_length[16] <-430
contact_table$sub2_length[17] <-605
contact_table$sub2_length[18] <-430
contact_table$sub2_length[19] <-605
contact_table$sub2_length[20] <-173
contact_table$sub2_length[21] <-430
contact_table$sub2_length[22] <-173
contact_table$sub2_length[23] <-430

write.table(contact_table, "mirko_subcontacts_C1.tsv", sep = "\t", row.names = FALSE, quote = FALSE)
