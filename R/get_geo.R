# get geometric data

#' Download Shapes for use in external GIS application
#'
#' @param geography One of several predefined geogrpahies (see details)
#' @param region A specific region to get the geogrpahy from (see details)
#' @param file If specified, directory to write to, including filename and extension of choice
#' @param reproject Logical, If TRUE, exported data is reprojected to an appropriate coordinate system for mapping, else it is exported with the NAD83 Datum
#'
#' @description Geography (Defaults to boundary) but valid geographies are as follows:
#'
#' @return Returns an object of class sf or if file is specified, writes to an external directory
#'
#' @importFrom tigris counties tracts
#' @importFrom dplyr filter
#'


eads_download_geo <- function(geography = "boundary", region = "msa", file, reproject = TRUE){

  # NSE Implementation

  # Selection of Region and Data Download
  if(tolower(region) == "county"){

    .data <- tigris::counties(state, class = "sf")

  }else if(tolower(region) == "tract"){

    .data <- tigris::tracts(state, class = "sf")

  }else if(tolower(region) == "msa"){

    .data <- tigris::core_based_statistical_areas(class = "sf") %>%
      filter(NAME == "St. Louis, MO-IL")

  }else if(tolower(region) == "state"){

    .data <- tigris::states(class = "sf") %>%
      dplyr::filter(STUSPS == state)

  }




}
# store some of these data locally in the package?
# Or an alternative data package containing only the shapes..
