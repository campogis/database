## Info ##########################################################
# Work with tables (CampoGIS 2024)
# 1- create taxonomy table from GBIF backbone
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
library()

## taxonomia de GBIF----
# Downloaded from https://hosted-datasets.gbif.org/datasets/backbone/
# Dataset "Current" 2023-08-28 15:19

gbif = fread("../data/GBIFbackbone/Taxon.tsv", sep = "\t")

names(gbif)
gbif %>% distinct(kingdom)
gbif %>% distinct(taxonRank)

# Reducing dataset
gbif_taxo = gbif %>% 
  filter(kingdom %in% c('Plantae','Animalia')) %>% 
  filter(taxonRank != 'unranked') %>% 
  dplyr::select("taxonID","parentNameUsageID", "acceptedNameUsageID","taxonRank","taxonomicStatus",     
                     "scientificName","scientificNameAuthorship","canonicalName",           
                     "kingdom","phylum","class","order","family","genus","specificEpithet","infraspecificEpithet","datasetID")

fwrite(gbif_taxo, "../data/MVP_tablasfinales/GBIFbackbone_subset.csv")
#gbif_taxo = fread("../data/MVP_tablasfinales/GBIFbackbone_subset.csv")

## assign GGBIF taxonID to registered species----
taxa <- read_csv("../data/taxo-traits-occ.csv")

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

matches = result1 %>% 
  rbind(result2)

#write_csv(matches, "../data/taxonID.csv") # this was manually completed
matches = read_csv("../data/MVP_tablasfinales/taxonID.csv")
matches = arrange(matches, taxonID)

# checks
checks = left_join(matches, gbif_taxo, by = "taxonID")
names(checks)
filter(checks, is.na(taxonRank.y))

# add missing taxa
Peltigerales1 = gbif[gbif$taxonID == 1055, ]
Peltigerales2 = gbif[gbif$taxonID == 180, ]
Peltigerales3 = gbif[gbif$taxonID == 95, ]
Peltigerales4 = gbif[gbif$taxonID == 5, ]
Peltigerales = Peltigerales1 %>% 
  rbind(Peltigerales2, Peltigerales3, Peltigerales4) %>% 
  dplyr::select("taxonID","parentNameUsageID", "acceptedNameUsageID","taxonRank","taxonomicStatus",     
                          "scientificName","scientificNameAuthorship","canonicalName",           
                          "kingdom","phylum","class","order","family","genus","specificEpithet","infraspecificEpithet","datasetID")

gbif_taxo = rbind(gbif_taxo,Peltigerales)
fwrite(gbif_taxo, "../data/MVP_tablasfinales/GBIFbackbone_subset.csv")

# Create taxonomy table using only the registered GBIF taxonIDs and all their parents----

# TaxonID
gbif_taxo_all_matches1 = filter(gbif_taxo, taxonID %in% matches$taxonID)
gbif_taxo_all_matches1 = arrange(gbif_taxo_all_matches1,taxonID)

# get all parents
gbif_taxo_all_matches2 = data.frame()

for (i in 1:length(gbif_taxo_all_matches1$taxonID)){

  # iterate through every taxonID
  cat(i,'taxonID: ', gbif_taxo_all_matches1$taxonID[i],'parenttaxonID: ', gbif_taxo_all_matches1$parentNameUsageID[i],'\n')
  
  # get parentID for that taxonID
  id = gbif_taxo_all_matches1$parentNameUsageID[i]
  
  #Add inmediate parent
  gbifID = gbif_taxo[gbif_taxo$taxonID == id,]
  gbif_taxo_all_matches2 = rbind(gbif_taxo_all_matches2,gbifID)
  
  gbifIDp = gbifID
  
  #iterate 10 times or until parent most Id is found
  for (j in 1:10){
    print(j)
    idp = gbifIDp$parentNameUsageID[1]
    
    if(!is.na(idp)){
    gbifIDp = gbif_taxo[gbif_taxo$taxonID == idp,]
    gbif_taxo_all_matches2 = rbind(gbif_taxo_all_matches2,gbifIDp)
    
    }else{print('parent most taxa found')}
  
  }
}

# Join TaxonIDs and their parents
gbif_taxo_all_matches = gbif_taxo_all_matches1 %>% 
  rbind(gbif_taxo_all_matches2) %>% 
  distinct(taxonID, .keep_all  = TRUE) %>% 
  dplyr::select("taxonID","parentNameUsageID", "acceptedNameUsageID","taxonRank","taxonomicStatus",     
                "scientificName","scientificNameAuthorship","canonicalName",           
                "kingdom","phylum","class","order","family","genus","specificEpithet","infraspecificEpithet")

names(gbif_taxo_all_matches)
unique(gbif_taxo_all_matches$taxonomicStatus)

fwrite(gbif_taxo_all_matches, "../data/MVP_tablasfinales/taxonomy.csv")
