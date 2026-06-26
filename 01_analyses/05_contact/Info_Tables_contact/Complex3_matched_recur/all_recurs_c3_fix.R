# Your delimiting points
delimiters <- c(380, 621, 1067, 1508, 1584, 1780, 1856, 1967, 2049, 2086, 2132) # fill in your full list

csv_data <- read.csv("COMPLEX3_ALL_RECURS.csv", header = FALSE)
# Your values from the CSV column
values <- csv_data$V1

# Function to compute the two returned values for a single value
get_pair <- function(x, delimiters) {
  
  if (x >= 1 & x <= 380) {
    return(c(x, x + 380))
    
  } else {
    lower <- max(delimiters[delimiters < x])
    upper <- min(delimiters[delimiters >= x])
    
    first  <- x + lower
    second <- x + upper
    
    return(c(first, second))
  }
}

results <- t(sapply(values, get_pair, delimiters = delimiters))

results_df <- data.frame(results = sort(as.vector(t(results))))
write.table(results_df, "COMPLEX3_ALL_RECURS_FIXED.csv", row.names = FALSE, col.names = FALSE, sep = ",")
