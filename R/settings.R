## Info ##################################################
##  Script to set directories based on your user
#
# working_dir: where your code is (e.g., github folder)
# data_dir: where the data is (e.g., drive folder)
# output_dir: where the outputs of the code will be saved 
##########################################################

rm(list=ls())

# get current user and node
user <- Sys.info()["user"]
node <- Sys.info()["nodename"]
code_dir = dirname(rstudioapi::getSourceEditorContext()$path)

cat("user:", user[1],'\nworking in ', code_dir)

if (node == "LAPTOP-HQ6304DA" && user == "yanis"){ #YS old compu
  
  #set working directory
  working_dir = code_dir
  cat("working dir:", working_dir,'\n')
  
  #set data directory
  data_dir <- 'C:/Users/yanis/Documents/scripts/campoGIS/campoGisDatabase/data' # github
  #data_dir <- 'G:/Shared drives/Proyectos clientes/QuintoMundo/MVP/MVP_tablasfinales' # new drive (campoGIS)
  
  cat("data dir:", data_dir,'\n')
  
  #set output directory
  output_dir <- 'G:/Shared drives/Proyectos clientes/QuintoMundo/MVP/MVP_tablasfinales' # new drive (campoGIS)
  cat("output dir:", output_dir)
  
  
} else if (node == "FB08NB-U021681" && user == "JLU-SU"){ #YS new compu
  
  #set working directory (github)
  working_dir = "C:/Users/JLU-SU/Documents/GitHub/campoGISTables/R"
  cat("working dir:", working_dir,'\n')
  
  #set directories
  #input_dir <- 'G:/Shared drives/ProyectosClientes/QuintoMundo/MVP/MVP_datos/Soundscape' #samplings
  input_dir <- 'G:/Shared drives/ProyectosClientes/QuintoMundo/MVP/MVP_tablasfinales/' #indices
  output_dir <- 'G:/Shared drives/ProyectosClientes/QuintoMundo/MVP/MVP_tablasfinales/database' 
  
  
  cat("input_dir:", input_dir,'\n')
  cat("output_dir:", output_dir,'\n')
  
  #set output directory (github)
  output_git <- 'C:/Users/JLU-SU/Documents/GitHub/campoGISTables/outputs' #github folder
  cat("output dir GitHub:", output_git,'\n')
  
} else if (node == "LAURA-SOLARI" && user == "lmsol"){ #LS compu
  
  #set working directory
  working_dir = "C:/Users/lmsol/LOCAL/soundscapes-arg/R"
  cat("working dir:", working_dir,'\n')
  
  #set data directory
  data_dir <- 'D:/Soundscape' # set manually YS
  cat("data dir:", data_dir,'\n')
  
  #set output directory
  #output_dir <- 'H:/Shared drives/ProyectosClientes/QuintoMundo/MVP/MVP_datos/Soundscape/recortes/resample2' # set manually LS resample2
  output_dir <- 'H:/Shared drives/ProyectosClientes/QuintoMundo/MVP/MVP_datos/Soundscape/recortes/resample3' # set manually LS resample3
  cat("output dir:", output_dir)
} else if (node == "xx" && user == "zz"){ #DG compu
  
  #set working directory
  working_dir = "C:/Users/lmsol/github/pruba_s/soundscapes-arg-main/R"
  cat("working dir:", working_dir,'\n')
  
  #set data directory
  data_dir <- 'C:/Users/lmsol/OneDrive/Escritorio/SOUNDSCAPE' 
  cat("data dir:", data_dir,'\n')
  
  #set output directory
  output_dir <- 'C:/Users/lmsol/OneDrive/Escritorio/SOUNDSCAPE/OUTPUT' 
  cat("output dir:", output_dir)
}
# Install required packages
listOfPackages <- c("readr", "dplyr", "stringr", "tidyr", "data.table", "lubridate", 
                    "soundecology","tuneR","seewave",
                    "googlesheets4")


# Install Packages, if needed
for (i in listOfPackages){
  if(! i %in% installed.packages()){
    print('Installing packages')
    install.packages(i, dependencies = TRUE)
  }else{
    print('Packages up to date')
  }
}


