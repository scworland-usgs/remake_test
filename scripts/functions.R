# download pdf and extract zips
get_sf_zips <- function(file_name){
  
  download.file(url="http://sfwater.org/Modules/ShowDocument.aspx?documentID=2525", 
                destfile=file_name)
  
  txt <- pdf_text("data/zip_codes.pdf")
  
  # extract only zip codes
  sf_zip_codes <- NULL
  for(i in 1:length(txt)){
    zips_on_page <- regmatches(txt[i], gregexpr("[[:digit:]]+", txt[i])) 
    df_zips <- data.frame(zip=unlist(zips_on_page))
    sf_zip_codes <- rbind(sf_zip_codes,df_zips)
  }
  
  return(sf_zip_codes)
}

# load CA shapefile and subset
subset_ca_zips <- function(shapefile,codes){
  
  sf_zip_spatial <- shapefile %>%
    filter(ZCTA %in% codes$zip) %>%
    select(zipcode=ZCTA,pop=TOT_POP)
  
  return(sf_zip_spatial)
  
}

# sample points in polygons
sample_points <- function(sf_zips_spatial, n=1000){
  
  sf_points_spatial <- sf_zips_spatial %>%
    group_by(zipcode) %>%
    st_sample(size=n) %>%
    data.frame() %>%
    st_as_sf() %>%
    mutate(customer_id=1:nrow(.))
  
  return(sf_points_spatial)
  
}

# generate interactive map
make_map <- function(polygon, points){
  
  mapview(polygon, zcol='pop') + 
    mapview(st_geometry(points), cex=2)
  
}



