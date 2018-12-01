read_tun_data <- function(filepath) {
  # Function to convert the Tunisia administrative data (by governorate into a TBL format)
  require(tidyverse)
  require(zoo)
  
  df <- read_xlsx(filepath) %>% 
    select(-X__1)
  
  # combine first and second rows 
  row1 <- as.character(df[1,])
  row2 <- paste0("_", as.character(df[2,]))
  df[1,] <- paste0(na.locf(row1, na.rm=FALSE), row2)
  df[1, 1] <- "Region" 
  
  #bind these values to the new column values 
  newcols <- as.character(df[1, ])
  df <- df[3:nrow(df),]
  names(df) <- newcols
  
  return(df)
}