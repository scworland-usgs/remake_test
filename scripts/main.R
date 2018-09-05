library(pdftools)
library(tidyverse)
library(mapview)
library(sf)

# source functions
source("scripts/functions.R")

# download pdf and extract zips
sf_zip_codes <- get_sf_zips(file_name="data/zip_codes.pdf")

# load CA shapefile and subset
ca_shapefile <- st_read('data/ca_zips/ZCTA2010.shp')
sf_zips_spatial <- subset_ca_zips(shapefile=ca_shapefile,codes=sf_zip_codes)

# write san francisco zip shapefile
st_write(sf_zip_spatial,"data/sf_zips/sf_zips.shp",delete_layer=TRUE)

# sample points in polygons
sf_points_spatial <- sample_points(sf_zips_spatial, n=1000)

# generate interactive map
make_map(sf_zips_spatial, sf_points_spatial)


