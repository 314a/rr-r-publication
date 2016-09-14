################################################################################
# Load GIS Datasets from geo.admin.ch
# 
# This script is part of the RMarkdown publication template
# usage: source("R/loadMapData.r")
# packages: rgdal, maptools, tools
############################################################################################
#' Download "zipped" data from Url and unzip it into the gisFolder into the 
#' folder "name" and load all the shp files.
#' @title Download and Extract Shp file from a remote source
#' @param url link to the .zip gis data
#' @param name of the folder and zip file has after download. e.g. name="gis", folder="gis" zip="gis.zip"
#' @param gisFolder folder where to store the data, use a subfolder to easily remove the data after download (the folder is created if it does not exist)
#' @param pattern which files to load default pattern=".shp" 
#' @param internalZipName in case the shp files are inside another zip file (! e.g. maps.geo.admin.ch data)
#' @return vector of the console output for each file
#' @examples
#' \dontrun{
#' parcsUrl   <-"http://data.geo.admin.ch/ch.bafu.schutzgebiete-paerke_nationaler_bedeutung/data.zip"
#' parcs      <-loadReadShp(url=parcsUrl,name="parcs",gisFolder=file.path(dataFolder,"gis"),pattern=".shp",internalZipName="shp.zip")
#' }
loadReadShp <- function(url,name,gisFolder,pattern=".shp",internalZipName=NA){
  # load the required packages
  require(rgdal) # install.packages("rgdal")
  require(maptools)
  require(tools)
  if(!exists(gisFolder)){dir.create(gisFolder, showWarnings = FALSE, recursive = TRUE)}
  # create file name for the zip folder and the extracted one
  zip <- file.path(gisFolder,paste(name,".zip",sep=""))
  dir <- file.path(gisFolder,name)
  if(!exists(dir)){dir.create(dir)}
  download.file(url,zip) # download the data
  # In case the data is located inside another zipfolder, else we simply unzip
  if(!is.na(internalZipName)){
    giszip <- unzip(zip,files=internalZipName,exdir=dir)
    giszip    <- unzip(giszip,exdir=dir)
  }else{giszip <- unzip(zip,exdir=dir)}# unzip the data
  # load the shapefiles
  path <- list.files(dir,pattern = pattern,recursive = T)
  # remove file that end with "shp.xml" 
  path <- path[!grepl("shp.xml",path)]
  
  # load each .shp file into R
  spList <- lapply(path,function(p){
    name <- file_path_sans_ext(basename(p))
    # NOTE: I'm not sure if layer names are always the file names without the ending..
    sp <- readOGR(dsn = file.path(dir,p), layer = name)
    return(sp)
    })
  # set the layer name as list element name
  names(spList) <- file_path_sans_ext(basename(path)) 
  return(spList)
}

################################################################################
# Download and extract Shapefiles from geo.admin.ch
# Due to license restrictions, we can't store the data on a public Git repository.
# https://map.geo.admin.ch/?topic=ech&lang=de&bgLayer=ch.swisstopo.pixelkarte-farbe&catalogNodes=458,532,639,653&layers=ch.swisstopo.swissboundaries3d-land-flaeche.fill,ch.swisstopo.swissboundaries3d-kanton-flaeche.fill,ch.bafu.schutzgebiete-paerke_nationaler_bedeutung&X=190000.00&Y=662000.00&zoom=1&layers_opacity=1,1,0.85

# Download the data to "gis" directory. (This allows us to remove the data easily afterwards)
gisFolder <- file.path(dataFolder,"gis")
gisData <- file.path(gisFolder,"gis.RData")
if(!file.exists(gisData)){
  # load, extract and read shapefiles
  boundariesUrl <- "http://data.geo.admin.ch/ch.swisstopo.swissboundaries3d-land-flaeche.fill/data.zip"
  boundaries <-loadReadShp(url=boundariesUrl,name="boundaries",gisFolder=file.path(dataFolder,"gis"),pattern=".shp",internalZipName="swissBOUNDARIES3D_LV95.zip")
  parcsUrl   <-"http://data.geo.admin.ch/ch.bafu.schutzgebiete-paerke_nationaler_bedeutung/data.zip"
  parcs      <-loadReadShp(url=parcsUrl,name="parcs",gisFolder=file.path(dataFolder,"gis"),pattern=".shp",internalZipName="shp.zip")
  
  spCH <- boundaries[["swissBOUNDARIES3D_1_3_TLM_LANDESGEBIET"]]
  spCT <- boundaries[["swissBOUNDARIES3D_1_3_TLM_KANTONSGEBIET"]]
  spParcs <- parcs[["Park_Perimeter2016"]]
  # save sp data as .RData files
  save(spCH,spCT,spParcs,file = gisData)
}else{load(gisData)}
# remove gisData folder or exclude the folder from being uploaded to the Git repository
# unlink(paste(gisFolder,"/*",sep="")) # pay attention with deleting stuff ;)