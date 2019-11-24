# levels

# dependencies
library(dplyr)
library(sf)
library(tigris)

# list count names
mo_names <- c("Franklin", "Jefferson", "Lincoln", "St. Charles", "St. Louis", "Warren")
il_names <- c("Calhoun", "Clinton", "Greene", "Jersey", "Macoupin", "Madison", "Monroe", "Randolph", "St. Clair")

# download missouri counties
mo_counties <- counties(state = "MO", class = "sf") %>%
  filter(NAME %in% mo_names) %>%
  mutate(STATE = "MO") %>%
  select(STATE, GEOID, NAMELSAD)

# download illinois counties
il_counties <- counties(state = "IL", class = "sf") %>%
  filter(NAME %in% il_names) %>%
  mutate(STATE = "IL") %>%
  select(STATE, GEOID, NAMELSAD)

# combine and remove geometry
stl_levels <- rbind(mo_counties, il_counties)
st_geometry(stl_levels) <- NULL

# clean-up
rm(il_names, il_counties, mo_names, mo_counties)

# define levels
stl_levels %>%
  rename(
    state = STATE,
    geoid = GEOID,
    name = NAMELSAD
  ) %>%
  mutate(name = ifelse(geoid == "29510", "St. Louis City", name)) %>%
  mutate(
    city = ifelse(geoid == "29510", TRUE, FALSE),
    city_county = ifelse(geoid %in% c("29189", "29510"), TRUE, FALSE),
    core = ifelse(geoid %in% c("29189", "29510", "17119", "17163"), TRUE, FALSE),
    ew_gateway = ifelse(geoid %in% c("29189", "29510", "29071", "29099", "29183",
                                     "17119", "17163", "17133"), TRUE, FALSE),
    metro_east = ifelse(state == "IL", TRUE, FALSE),
    metro_west = ifelse(state == "MO", TRUE, FALSE),
    msa = TRUE
  ) %>%
  select(-state) %>%
  arrange(as.numeric(geoid)) -> stl_levels

# save data
save(stl_levels, file = "data/stl_levels.rda")

# readr::write_csv(stl_levels, path = "stl_levels.csv")
