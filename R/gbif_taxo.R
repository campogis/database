## Info ##########################################################
# Work with tables (CampoGIS 2024)
# 1- create taxonomy table
# 2- ..
# 3- ..
#
# Authors: Yanina Sica
# Date: July 2024

## Settings----
# RUN settings.R
setwd(working_dir)
# check settings
getwd()
options(scipen = 999)

## Packages
library(stringr)
library(dplyr)
library(tidyr)
library(readr)
library(data.table)
library(lubridate)
library(googlesheets4)

## taxonomia de GBIF 
# Downloaded from https://hosted-datasets.gbif.org/datasets/backbone/
# Dataset "Current" 2023-08-28 15:19

gbif = fread("../data/GBIFbackbone/Taxon.tsv", sep = "\t")

names(gbif)
gbif %>% distinct(kingdom)
gbif %>% distinct(taxonRank)

# Reducing dataset
gbif = filter(gbif, kingdom %in% c('Plantae','Animalia'))
gbif = filter(gbif, taxonRank != 'unranked')

gbif_taxo = dplyr::select(gbif, "taxonID","parentNameUsageID", "acceptedNameUsageID","taxonRank","taxonomicStatus",     
                     "scientificName","scientificNameAuthorship","canonicalName",           
                     "kingdom","phylum","class","order","family","genus","specificEpithet","infraspecificEpithet","datasetID")

#write_csv(gbif_taxo, "../data/GBIFbackbone_subset.csv")

# still very large dataset
# gbif %>% distinct(taxonomicStatus)
# gbif2 = filter(gbif, taxonomicStatus == 'accepted')
# gbif2 = dplyr::select(gbif, "taxonID","parentNameUsageID","taxonRank",     
#                      "scientificName","scientificNameAuthorship","canonicalName",           
#                      "kingdom","phylum","class","order","family","genus","specificEpithet","infraspecificEpithet")
# 
# write_csv(gbif2, "../data/GBIFbackbone_subsetAcc.csv")


# assign taxo_id to attributes
taxa <- read_csv("../data/taxo-traits-occ.csv")

#resultado2 <- gbif_taxo[gbif_taxo$scientificName == "Lotus tenuis Waldst. & Kit. ex Willd.", ]

result1 <- taxa %>%
  left_join(gbif_taxo, by = c("taxonName" = "scientificName")) %>% 
  #left_join(gbif_taxo, by = c("taxo" = "canonicalName")) %>%
  select(taxonName, taxonID, taxonomicStatus,taxonRank,parentNameUsageID)  %>% 
  filter(!is.na(taxonID))

result2 <- taxa %>%
  left_join(gbif_taxo, by = c("taxonName" = "scientificName")) %>% 
  select(taxonName, taxonID)  %>% 
  filter(is.na(taxonID)) %>% 
  left_join(gbif_taxo, by = c("taxonName" = "canonicalName")) %>%
  select(taxonName, taxonID = taxonID.y, taxonomicStatus,taxonRank,parentNameUsageID)  # Select only the columns of interest

result = result1 %>% 
  rbind(result2)

write_csv(result, "../data/taxonID.csv")

