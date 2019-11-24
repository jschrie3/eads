# create vector of St Louis City/County Municipalities

# dependencies
library(dplyr)

library(sf)
library(tigris)

# download and process place data
places <- places(state = 29, class = "sf") %>%
  st_transform(crs = 26915) %>%
  select(GEOID, NAMELSAD)

# convert to centroid
places_centroid <- st_centroid(places)

# download and process county data
counties <- counties(state = 29, class = "sf") %>%
  st_transform(crs = 26915) %>%
  select(GEOID, NAMELSAD) %>%
  filter(GEOID %in% c("29189", "29510"))

# intersect
stl_places <- st_intersection(places_centroid, counties) %>%
  rename(
    COUNTYID = GEOID.1,
    COUNTY = NAMELSAD.1
  ) %>%
  select(-NAMELSAD)

# remove geometry
st_geometry(stl_places) <- NULL

# combine with place data
places <- left_join(places, stl_places, by = "GEOID") %>%
  filter(is.na(COUNTY) == FALSE)

# clean-up enviornment
rm(counties, places_centroid, stl_places)
