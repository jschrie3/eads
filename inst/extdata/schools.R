# create vector of St Louis City/County Municipalities

# dependencies
library(dplyr)

library(sf)
library(tidycensus)
library(tigris)

# download and process schools data
schools <- school_districts(state = 29, class = "sf") %>%
  st_transform(crs = 26915) %>%
  select(GEOID, NAME)

# convert to centroid
schools_centroid <- st_centroid(schools)

# download and process county data
counties <- counties(state = 29, class = "sf") %>%
  st_transform(crs = 26915) %>%
  select(GEOID, NAMELSAD) %>%
  filter(GEOID %in% c("29189", "29510"))

# intersect
stl_schools <- st_intersection(schools_centroid, counties) %>%
  rename(
    COUNTYID = GEOID.1,
    COUNTY = NAMELSAD
  ) %>%
  select(-NAME)

# remove geometry
st_geometry(stl_schools) <- NULL

# combine with place data
schools <- left_join(schools, stl_schools, by = "GEOID") %>%
  filter(is.na(COUNTY) == FALSE)

# clean-up enviornment
rm(counties, schools_centroid, stl_schools)
