#library(readr)
#library(dplyr)

GBIF <- read_csv("C:/Users/Samsung/Desktop/CampoGIS/GBIFbackbone_subsetAcc.csv")
#head(GBIFtaxo)
traits <- read_csv("C:/Users/Samsung/Desktop/CampoGIS/traits.csv")

result <- traits %>%
  left_join(GBIF, by = c("taxo" = "scientificName")) %>%
  select(taxo, taxonID)  # Select only the columns of interest

result1 <- traits %>%
  left_join(GBIF, by = c("taxo" = "canonicalName")) %>%
  select(taxo, taxonID)  # Select only the columns of interest

head(result1)
write_csv(result1, "C:/Users/Samsung/Desktop/CampoGIS/result_table1.csv")
