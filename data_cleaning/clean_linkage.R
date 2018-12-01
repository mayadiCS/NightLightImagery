read_tun_data <- function(filepath) {
  # Function to convert the Tunisia administrative data (by governorate into a TBL format)
  require(tidyverse)
  require(zoo)
  
  df <- read_xlsx(filepath)  
  
  if (as.character(df[3,2]) == "2014") {
    df <- select(df, -X__1)
  }
  
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

test1 <- read_tun_data("/home/jeb/Documents/columbia_data_science/edav/NightLightImagery/data/raw/Households by possession of ICTs 11_18_2018 02_51_58.xlsx")
test2 <- read_tun_data("/home/jeb/Documents/columbia_data_science/edav/NightLightImagery/data/raw/Households by possession of leisure resources 11_18_2018 02_51_43.xlsx")
