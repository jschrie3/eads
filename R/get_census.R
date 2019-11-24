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

  if (missing(topic)){
    topic <- NULL
  }

  if (missing(table)){
    table <- NULL
  }

  if (missing(variable)){
    variable <- NULL
  }

  ## vintage
  if (missing(year)){
    stop("The 'year' argument must be specified.")
  }

  if (is.numeric(year) == FALSE){
    stop("The 'year' input is invalid - it must be a numeric value.")
  }

  ## product
  if (missing(product)){
    stop("The 'product' argument must be specified.")
  }

  if (product %in% c("census", "acs1", "acs3", "acs5") == FALSE){
    stop("The 'product' input is invalid - it must be one of 'census', 'acs1', 'acs3', or 'acs5'.")
  }

  if (product == "census" & year %in% c(1990,2000,2010) == FALSE){
    stop("The given 'year' and 'product' do not match. See documentation ('?stl_get_data') for valid inputs.")
  }

  if (product %in% c("acs1", "acs3", "acs5")){

    if (product == "acs1" & (year > 2017 | year < 2010)){
      stop("The given 'year' and 'product' do not match. See documentation ('?stl_get_data') for valid inputs.")
    }

    if (product == "acs3" & (year > 2013 | year < 2010)){
      stop("The given 'year' and 'product' do not match. See documentation ('?stl_get_data') for valid inputs.")
    }

    if (product == "acs5" & (year > 2017 | year < 2010)){
      stop("The given 'year' and 'product' do not match. See documentation ('?stl_get_data') for valid inputs.")
    }

  }

  ## geometry
  if (is.logical(geometry) == FALSE){
    stop("The 'geometry' input is invalid - it must be a logical value (either TRUE or FALSE).")
  }

  # pull data
  if (product == "census"){

    out <- stl_get_decennial(region = region, level = level,
                             variable = variable,
                             year = year, geometry = geometry)

  } else if (product != "census"){

    out <- stl_get_acs(region = region, level = level,
                       table = table, variable = variable,
                       year = year, product = product, geometry = geometry)

  }

  # return output
  return(out)

}


stl_get_acs <- function(region, level, table, variable, year, product, geometry){

  # global variables
  state = NULL

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

      out <- tidycensus::get_acs(geography = level,
                                 state = unique(codes$state),
                                 county = codes$counties,
                                 table = table,
                                 variables = variable,
                                 year = year,
                                 survey = product,
                                 geometry = geometry,
                                 output = "wide")

    } else if (multi_state == TRUE){

      # subset codes into MO and IL vectors
      il_counties <- dplyr::filter(codes, state == "17")
      il_counties <- il_counties$counties
      mo_counties <- dplyr::filter(codes, state == "29")
      mo_counties <- mo_counties$counties

      # get IL data
      il <- suppressMessages(tidycensus::get_acs(geography = level,
                                state = 17,
                                county = il_counties,
                                table = table,
                                variables = variable,
                                year = year,
                                survey = product,
                                geometry = geometry,
                                output = "wide"))

      # get MO data
      mo <- tidycensus::get_acs(geography = level,
                                state = 29,
                                county = mo_counties,
                                table = table,
                                variables = variable,
                                year = year,
                                survey = product,
                                geometry = geometry,
                                output = "wide")

      # construct output
      out <- rbind(il, mo)

    }

  }

  # non-county based products

}

stl_get_decennial <- function(region, level, variable, year, geometry){

  # global variables
  state = NULL

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

      out <- tidycensus::get_decennial(geography = level,
                                 state = unique(codes$state),
                                 county = codes$counties,
                                 variables = variable,
                                 year = year,
                                 geometry = geometry,
                                 output = "wide")

    } else if (multi_state == TRUE){

      # subset codes into MO and IL vectors
      il_counties <- dplyr::filter(codes, state == "17")
      il_counties <- il_counties$counties
      mo_counties <- dplyr::filter(codes, state == "29")
      mo_counties <- mo_counties$counties

      # get IL data
      il <- suppressMessages(tidycensus::get_decennial(geography = level,
                                state = 17,
                                county = il_counties,
                                variables = variable,
                                year = year,
                                geometry = geometry,
                                output = "wide"))

      # get MO data
      mo <- tidycensus::get_decennial(geography = level,
                                state = 29,
                                county = mo_counties,
                                variables = variable,
                                year = year,
                                geometry = geometry,
                                output = "wide")

      # construct output
      out <- rbind(il, mo)

    }

  }

  # non-county based products

}
