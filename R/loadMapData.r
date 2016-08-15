################################################################################
# Load GIS Datasets from geo.admin.ch
# 
# This script is part of the RMarkdown publication template
# usage: source("R/loadMapData.r")
# packages: rgdal, maptools, tools
################################################################################
# Download and extract Shapefiles from geo.admin.ch
# Due to license restrictions, we can't store the data on a public Git repository.
# https://map.geo.admin.ch/?topic=ech&lang=de&bgLayer=ch.swisstopo.pixelkarte-farbe&catalogNodes=458,532,639,653&layers=ch.swisstopo.swissboundaries3d-land-flaeche.fill,ch.swisstopo.swissboundaries3d-kanton-flaeche.fill,ch.bafu.schutzgebiete-paerke_nationaler_bedeutung&X=190000.00&Y=662000.00&zoom=1&layers_opacity=1,1,0.85

# Download the data to "gis" directory. (This allows us to remove the data easily afterwards)
gisFolder <- file.path(dataFolder,"gis")
gisData <- file.path(gisFolder,"gis.RData")
if(!file.exists(gisData)){
  # read shapefiles
  require(rgdal) # install.packages("rgdal")
  require(maptools)
  require(tools)
  # download the necessairy boundaries (see swisstopo opendata license)
  if(!exists(gisFolder)){dir.create(gisFolder)}
  
  # Download and load Swiss boundaries:
  # you find the download URL on https://map.geo.admin.ch in the layer geocatalog infobox 
  url <- "http://data.geo.admin.ch/ch.swisstopo.swissboundaries3d-land-flaeche.fill/data.zip"
  zip <- file.path(gisFolder,"boundaries.zip")
  dir <- file.path(gisFolder,"boundaries")
  if(!exists(dir)){dir.create(dir)}
  download.file(url,zip)
  boundarieszip <- unzip(zip,files="swissBOUNDARIES3D_LV95.zip",exdir=dir)
  boundaries <-unzip(boundarieszip,exdir=dir)
  # extract the paths to the shp files
  path <- list.files(dir,pattern = "LANDESGEBIET.shp",recursive = T) 
  path <- path[!grepl("shp.xml",path)]# remove file that end with "shp.xml"
  # load the shape file 
  spCH <- readOGR(dsn = file.path(dir,path), layer = file_path_sans_ext(basename(path)))
  
  path <- list.files(dir,pattern = "KANTONSGEBIET.shp",recursive = T)
  path <- path[!grepl("shp.xml",path)]# remove file that end with "shp.xml"
  spCT <- readOGR(dsn = file.path(dir,path), layer = file_path_sans_ext(basename(path)))
  
  # Download and load Swiss parcs
  # http://data.geo.admin.ch/ch.bafu.schutzgebiete-paerke_nationaler_bedeutung/data.zip
  url <- "http://data.geo.admin.ch/ch.bafu.schutzgebiete-paerke_nationaler_bedeutung/data.zip"
  zip <- file.path(gisFolder,"parcs.zip")
  dir <- file.path(gisFolder,"parcs")
  if(!exists(dir)){dir.create(dir)}
  download.file(url,zip)
  # unzip(zip,list=TRUE) 
  parcszip <- unzip(zip,files="shp.zip",exdir=dir)
  parcs <-unzip(parcszip,exdir=dir)
  # load the shape file   
  path <- list.files(dir,pattern = "Park_Perimeter2016.shp",recursive = T)
  spParcs <- readOGR(dsn = file.path(dir,path[1]), layer = file_path_sans_ext(basename(path[1])))
  
  # save and retrieve shp files
  save(spCH,spCT,spParcs,file = gisData)
}else{load(gisData)}
# remove gisData folder or exclude the folder from being uploaded to the Git repository
# unlink(paste(gisFolder,"/*",sep="")) # pay attention with deleting stuff ;)


# Create the map:
# mapPng <- file.path(figureFolder,"map.png")
# Extract parc adula perimeter
parcAdula <- spParcs[spParcs$Name %in% "Parc Adula",]
# plot
png(filename=mapPng,width = 800,height=550,res=72)
plot.new()
par(mar=c(0,0,0,0), oma=c(0,0,0,0))
# add a plot title and legend
sp::plot(spCT,border="lightgray") # ,axes=T
sp::plot(spCH,border="darkgrey",add=T)
sp::plot(parcAdula,col="lightgreen",border="green",add=T)
text(2748381, 1179781 , labels=as.character(parcAdula$Name), col="darkgreen",cex = 1)
legend("bottomright", legend=c("Canton", "Parc Adula"),title="", bty="n", inset=0.02,
       lty=c( 1,-1,-1), pch=c(-1,15, 1),col=c("lightgray", "lightgreen"),cex = 1)
dev.off()