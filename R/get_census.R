#' Get Census Variables
#'
#' @description Pull data from the U.S. Census Bureau's API via the \code{tidycensus} package.
#'
#' @param region One of \code{"city"}, \code{"city/county"}, \code{"core"}, \code{"ew gateway"},
#'     \code{"metro east"}, \code{"metro west"}, or \code{"full metro"}
#' @param level One of...
#' @param topic For all users who wish to make common data requests.
#' @param table For advanced users who wish to specify a full Decennial Census or American
#'     Comunity Survey table.
#' @param variable For advanced users who wish to specify a specific Decennial Census or American
#'     Comunity Survey variable.
#' @param year Vintage for data. For 1990, 2000, and 2010, it is possible to obtain data from
#'     the Decennial Census. For 2010-2017, it is possible to obtain data from the American
#'     Community Survey.
#' @param product One of \code{"census"} for Decennial Census, \code{"acs1"} for the 1-year
#'     American Community Survey (ACS) estimates, \code{"acs3"} for the 3-year ACS estimates
#'     (only available 2010-2013), or \code{"acs5"} for the 5-year ACS estimates.
#' @param geometry If \code{TRUE}, will return spatial data as an \code{sf} object; defaults
#'     to \code{FALSE}.
#'
#' @export
stl_get_census <- function(region, level, topic, table, variable, year, product, geometry = FALSE){

  # check inputs
  ## region
  if (missing(region)){
    stop("The 'region' argument must be specified.")
  }

  if (region %in% c("city", "city/county", "core", "ew gateway", "metro east",
                    "metro west", "full metro") == FALSE){
    stop("The 'region' input is invalid. See documentation ('?stl_get_data') for valid inputs.")
  }

  ## level
  if (missing(level)){
    stop("The 'level' argument must be specified.")
  }

  ## content
  content_status <- c(missing(topic), missing(table), missing(variable))

  if (sum(content_status) < 2){
    stop("Only one of the 'topic', 'table', or 'variable' arguments may be specified.")
  }

  ## vintage
  if (missing(year)){
    stop("The 'year' argument must be specified.")
  }

  if (is.numeric(year) == FALSE){
    stop("The 'year' input is invalid - it must be a numeric value.")
  }

  if (year < 2010){
    stop("The 'year' input is invalid - data are only available from 2010 onwards.")
  }

  ## product
  if (missing(product)){
    stop("The 'product' argument must be specified.")
  }

  if (product %in% c("census", "acs1", "acs3", "acs5") == FALSE){
    stop("The 'product' input is invalid - it must be one of 'census', 'acs1', 'acs3', or 'acs5'.")
  }

  ## geometry
  if (is.logical(geometry) == FALSE){
    stop("The 'geometry' input is invalid - it must be a logical value (either TRUE or FALSE).")
  }

}
