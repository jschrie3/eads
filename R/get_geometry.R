#' Get Census Spatial Data
#'
#' @description Pull TIGER/Line data from the U.S. Census Bureau's API via the
#'     \code{tidycensus} package. These are commonly known as "shapefiles"
#'     in GIS contexts.
#'
#' @param region One of \code{"city"}, \code{"city/county"}, \code{"core"}, \code{"ew gateway"},
#'     \code{"metro east"}, \code{"metro west"}, or \code{"full metro"}
#' @param level One of...
#' @param year Vintage for data; defaults to 2017.
#' @param crs EPSG code to transform data to; defaults to UTM 15N.
#' @param ... Advanced options to pass on to the \code{tigris} package.
#'
#' @export
stl_get_geo <- function(region, level, year = 2017, crs = 26915, ...){

  # check inputs
  ## region
  if (missing(region)){
    stop("The 'region' argument must be specified.")
  }

  if (region %in% c("city", "city/county", "core", "ew gateway", "metro east",
                    "metro west", "full metro") == FALSE){
    stop("The 'region' input is invalid. See documentation ('?stl_get_geo') for valid inputs.")
  }

  ## level
  if (missing(level)){
    stop("The 'level' argument must be specified.")
  }

  if (level %in% c("block", "block group", "tract", "county") == FALSE){
    stop("The 'level' input in invalid. See documentation ('?stl_get_geo') for valid inputs.")
  }

  ## vintage
  if (is.numeric(year) == FALSE){
    stop("The 'year' input is invalid - it must be a numeric value.")
  }

  # pull data
  out <- stl_get_tiger(region, level, year = year, ...)

  # transform
  out <- sf::st_transform(out, crs = 26915)

  # return output
  return(out)

}


stl_get_tiger <- function(region, level, year, ...){

  # global variables
  state = COUNTYFP = NULL

  # identify fips codes
  codes <- get_codes(region = region)

  if (length(unique(codes$state)) == 1){
    multi_state <- FALSE
  } else if (length(unique(codes$state)) == 2){
    multi_state <- TRUE
  }

  # county-based products
  if (level %in% c("block", "block group", "tract", "county")){

    if (multi_state == FALSE){

      if (level == "county"){

        out <- tigris::counties(state = unique(codes$state),
                                year = year,
                                class = "sf",
                                ...)

        out <- dplyr::filter(out, COUNTYFP %in% codes$counties)

      }

    } else if (multi_state == TRUE){

      # subset codes into MO and IL vectors
      il_counties <- dplyr::filter(codes, state == "17")
      il_counties <- il_counties$counties
      mo_counties <- dplyr::filter(codes, state == "29")
      mo_counties <- mo_counties$counties

      if (level == "county"){

        il <- tigris::counties(state = 17, year = year, class = "sf", ...)
        il <- dplyr::filter(il, COUNTYFP %in% il_counties)

        mo <- tigris::counties(state = 29, year = year, class = "sf", ...)
        mo <- dplyr::filter(mo, COUNTYFP %in% mo_counties)

        out <- rbind(il, mo)

      }


    }
  }

  # return output
  return(out)

}
