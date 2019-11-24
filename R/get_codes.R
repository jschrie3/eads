# Given an input, return a vector or list of fips codes

get_codes <- function(region){

  # global variables
  city = city_county = core = ew_gateway = metro_east = metro_west = msa = NULL

  # subset stl_levels object
  if (region == "city"){
    tbl <- dplyr::filter(eads::stl_levels, city == TRUE)
  } else if (region == "city/county"){
    tbl <- dplyr::filter(eads::stl_levels, city_county == TRUE)
  } else if (region == "core"){
    tbl <- dplyr::filter(eads::stl_levels, core == TRUE)
  } else if (region == "ew gateway"){
    tbl <- dplyr::filter(eads::stl_levels, ew_gateway == TRUE)
  } else if (region == "metro east"){
    tbl <- dplyr::filter(eads::stl_levels, metro_east == TRUE)
  } else if (region == "metro west"){
    tbl <- dplyr::filter(eads::stl_levels, metro_west == TRUE)
  } else if (region == "full metro"){
    tbl <- dplyr::filter(eads::stl_levels, msa == TRUE)
  }

  # construct output
  out <- dplyr::tibble(
    state = tbl$state_fips,
    counties = tbl$county_fips
  )

  # return output
  return(out)

}
