library(tidyverse)
source("Scripts/NOAA_tiff_functions.R")
source("Scripts/NOAA_tiff_format.R")



## NOAA files
# noaa.tiffs <- list.files("Data/ss665_data", pattern= "7521_1.tif$|20193_1.tif$") %>% 
#   str_c("Data/ss665_data/", ., sep="")
# 
# noaa.df <- str_split(noaa.tiffs, pattern= "\\.", simplify= TRUE)[1:7]
# names(noaa.df) <- c("Satellite", "Yr_JulianDay", "MoDay", "Unknown", "Level", "Unk", "Algorithm?")
# 
# 
# ## NOAA field df
# ## 4 columns: Lat/long text file, noaa.tiff object, waterbody ID from shapefile, UTM
# noaa.field.info <- as_tibble(rbind(c("Data/20190801_LakeSanAntonio/LatLong_LakeSanAntonio.txt", noaa.tiffs[3], 6342, 10, "LakeSanAntonio_20190801"),
#                                    c("Data/20190807_ClearLake/LatLong_ClearLake_20190807.txt", noaa.tiffs[4], 2075, 10, "ClearLake_20190807"),
#                                    c("Data/20190812_SanPabloReservoir/LatLong_SanPabloReservoir.txt", noaa.tiffs[6], 3884, 10, "SanPabloReservoir_20190812"),
#                                    c("Data/20190815_LakeAlmanor/LatLong_LakeAlmanor_20190815.txt", noaa.tiffs[8], 1116, 10, "LakeAlmanor_20190815"),
#                                    c("Data/20190816_ClearLake/LatLong_ClearLake_20190816.txt", noaa.tiffs[9], 2075, 10, "ClearLake_20190816"),
#                                    c("Data/20191008_ClearLake/LatLong_ClearLake_20191008.txt", noaa.tiffs[12], 2075, 10, "ClearLake_20191008"),
#                                    c("Data/20200708_ClearLake/LatLong_ClearLake_20200708_2.txt", noaa.tiffs[13], 2075, 10, "ClearLake_20200708"),
#                                    c("Data/20200724_ClearLake/GPS_avenza_map.txt", noaa.tiffs[14], 2075, 10, "ClearLake_20200724")))
# names(noaa.field.info) <- c("field.path", "NOAA.path", "DFGWATERID", "utm", "waterbody")
# 


######################################################

# Open UTM lakes shapefile R object
ca_lakes_utm <- readRDS("Data/Shapefiles/ca_lakes_shapefile_utm.rds")

# Run function to extract specific lake shapefile based on DFGWATERID field
lsa_utm <- extract_lake_shapefile(ca_lakes_utm, DFGWATER_ID= 6342)
spr_utm <- extract_lake_shapefile(ca_lakes_utm, DFGWATER_ID= 3884)
clr_utm <- extract_lake_shapefile(ca_lakes_utm, DFGWATER_ID= 2075)
alm_utm <- extract_lake_shapefile(ca_lakes_utm, DFGWATER_ID= 1116)


# Import NOAA tif
#noaa.tiff.list <- map(noaa.field.info$NOAA.path, read_noaa_tiff)
noaa.tiff.list <- readRDS("Data/ss665_data/NOAA_tiffs.RDS")


# Extract pixels for each sampled water body
noaa.extract.map.list <- map2(noaa.tiff.list, noaa.field.info$DFGWATERID, function(x, y) extract_lake_map_pixels(tif.matrix = x, lake.id= y, utm= 10))




#### MAKE PLOTS ####
  

# Lake San Antonio
plot_bounding_box(data_list= noaa.extract.map.list[1],
                  field_df= lsa_20190801_locations,
                  shapefile_utm= lsa_utm,
                  bbox= st_bbox(lsa_20190801_locations))
ggsave(last_plot(), filename= "map_sampling_lsa20190801.png", width= 8, height= 6, units= "in", dpi= 300,
       path= "Data/LakeMaps")

# Clear Lake 2019-08-07
plot_bounding_box(data_list= noaa.extract.map.list[2],
                  field_df= clr_20190807_locations,
                  shapefile_utm= clr_utm,
                  bbox= st_bbox(clr_20190807_locations))
ggsave(last_plot(), filename= "map_sampling_clr20190807.png", width= 8, height= 6, units= "in", dpi= 300,
       path= "Data/LakeMaps")


# San Pablo Reservoir
plot_bounding_box(data_list= noaa.extract.map.list[3],
                  field_df= spr_20190812_locations,
                  shapefile_utm= spr_utm,
                  bbox= st_bbox(spr_20190812_locations))
ggsave(last_plot(), filename= "map_sampling_spr20190812.png", width= 8, height= 6, units= "in", dpi= 300,
       path= "Data/LakeMaps")

# Lake Almanor
plot_bounding_box(data_list= noaa.extract.map.list[4],
                  field_df= alm_20190815_locations,
                  shapefile_utm= alm_utm,
                  bbox= st_bbox(alm_20190815_locations))
ggsave(last_plot(), filename= "map_sampling_alm20190815.png", width= 8, height= 6, units= "in", dpi= 300,
       path= "Data/LakeMaps")

# Clear Lake 2019-08-16
plot_bounding_box(data_list= noaa.extract.map.list[5],
                  field_df= clr_20190816_locations,
                  shapefile_utm= clr_utm,
                  bbox= st_bbox(clr_20190816_locations))
ggsave(last_plot(), filename= "map_sampling_clr20190816.png", width= 8, height= 6, units= "in", dpi= 300,
       path= "Data/LakeMaps")

# Clear Lake 2019-08-16
plot_bounding_box(data_list= noaa.extract.map.list[6],
                  field_df= clr_20191008_locations,
                  shapefile_utm= clr_utm,
                  bbox= st_bbox(clr_20191008_locations))
ggsave(last_plot(), filename= "map_sampling_clr20191008.png", width= 8, height= 6, units= "in", dpi= 300,
       path= "Data/LakeMaps")

# clr.plot+ coord_sf(xlim= c(510988, 519000), 
#                     ylim= c(4319000, 4323328))


# Clear Lake 2020-07-08
plot_bounding_box(data_list= noaa.extract.map.list[7],
                  field_df= clr_20200708_locations,
                  shapefile_utm= clr_utm,
                  bbox= st_bbox(clr_20200708_locations)) + 
  coord_sf(xlim= c(522000, 523500), 
           ylim= c(4318000, 4319000))

ggsave(last_plot(), filename= "map_sampling_clr20200708.png", width= 8, height= 6, units= "in", dpi= 300,
       path= "Data/LakeMaps")


# Clear Lake 2020-07-24
plot_bounding_box(data_list= noaa.extract.map.list[1],
                  field_df= clr_20200724_locations,
                  shapefile_utm= clr_utm,
                  bbox= st_bbox(clr_20200724_locations)) + 
  coord_sf(xlim= c(527200, 528000), 
           ylim= c(4311400, 4313500))

ggsave(last_plot(), filename= "map_sampling_clr20200724.png", width= 8, height= 6, units= "in", dpi= 300,
       path= "Data/LakeMaps")




