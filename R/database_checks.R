## Info ##########################################################
# Work with tables (CampoGIS 2024)
# 1- check proper relationships
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

## occurrences----
occ = fread("../data/MVP_tablasfinales/occurrences.csv", sep = "\t")

## traits----
trait = fread("../data/MVP_tablasfinales/traits.csv", sep = "\t")
trait = filter(trait, !is.na(taxonID))

## survey-event----
event = fread("../data/MVP_tablasfinales/survey-event.csv", sep = "\t")

## taxonomy----
taxo = fread("../data/MVP_tablasfinales/taxonomy.csv", sep = ",")

# How many vegetation points are there?
event %>% filter(parentEventID == "MVP5WArgentina") %>% 
  filter(protocolNames != "") %>% 
  distinct(eventID)
# 1:       acousticRecording
# 2: anuransAuditiveSampling
# 3:   anuransParcelSampling
# 4:      birdsPointSampling
# 5:    flyingArthropPanTrap
# 6:           gdPitfallTrap
# 7:         quadVegSampling
# 8:            soilSampling
# 9:               soilSound

# all quadVegSampling
event_veg_farms = event[event$parentEventID == "quadVegSampling",]
event_veg_BMS = event[event$parentEventID %in% event_veg_farms$eventID,]
event_veg_points = event[event$parentEventID %in% event_veg_BMS$eventID,]

# all occurrences
veg_occ = occ[occ$eventID %in% event_veg_points$eventID]
veg_occ = distinct(veg_occ,taxonID, .keep_all = TRUE)

# get how many species
veg_taxo = taxo[taxo$taxonID %in% veg_occ$taxonID]
veg_taxo %>% filter(taxonRank =='species') %>% count()

# get verbatim for edits to match GBIF
occ_matches1 = taxo[taxo$scientificName %in% occ$taxonName,]
occ_matches2 = taxo[taxo$canonicalName %in% occ$taxonName,]
