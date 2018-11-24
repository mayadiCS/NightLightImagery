
library(tidyverse)
library(here)

# Script to tidy originally wide formatted longitudinal nightlight data

del_untidy <- read_csv(here("data/intermediate", "tun_lum_governorate_93_13.csv"))

del_untidy %>% 
  gather(matches("[0-9]{4}_.*"), key = "year_var", value = "value") %>% 
  separate(year_var, c("year", "measure"), sep="_") %>% 
  spread(key = measure, value = value) %>% 
  write_csv(here("data/final", "tun_lum_governorate_93_13_tidy.csv"))

