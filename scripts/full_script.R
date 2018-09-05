library(pdftools)
library(tidyverse)
library(mapview)
library(sf)

# download PDF from web
download.file(url="http://sfwater.org/Modules/ShowDocument.aspx?documentID=2525", 
              destfile="data/zip_codes.pdf")

txt <- pdf_text("data/zip_codes.pdf")

# extract only zip codes
sf_zip_codes <- NULL
for(i in 1:length(txt)){
  zips_on_page <- regmatches(txt[i], gregexpr("[[:digit:]]+", txt[i])) 
  df_zips <- data.frame(zip=unlist(zips_on_page))
  sf_zip_codes <- rbind(sf_zip_codes,df_zips)
}

# load shapefile from here and filter zipcodes
# https://earthworks.stanford.edu/catalog/stanford-dc841dq9031
sf_zip_spatial <- st_read('data/ca_zips/ZCTA2010.shp') %>%
  filter(ZCTA %in% sf_zip_codes$zip) %>%
  select(zipcode=ZCTA,pop=TOT_POP)

# save san franciso zip shapefile
st_write(sf_zip_spatial,"data/sf_zips/sf_zips.shp",delete_layer=TRUE)

# sample points in each polygon
sf_points_spatial <- sf_zip_spatial %>%
  group_by(zipcode) %>%
  st_sample(size=1000) %>%
  data.frame() %>%
  st_as_sf() 

# generate interactive map
mapview(sf_zip_spatial, zcol='pop') + 
  mapview(st_geometry(sf_points_spatial), cex=2)

# note maxFeatures
# hold <- sf::read_sf("https://geowebservices.stanford.edu/geoserver/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=druid:dc841dq9031&maxFeatures=50&outputFormat=JSON")

