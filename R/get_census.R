# get census data

# need to define/operationalize topics of interest, such as race, poverty,
# other metrics of evaluation

#' Get Census Variables
#'
#'
#' @param region One of a predefined region (see description)
#' @param variables A vector of at least length 1 containg acceptable categories (see description) and or dataset variables
#' @param year 4 digit numeric year to obtain data from
#' @param output One of \code{tibble} or \code{sf}
#'

ead_census <- function(region, variables, year, class){

  # NSE Implementation

  # Build API Call

  # Get Data
  if(race %in% variables){
    vars <- append(vars, c("B02001_01", "B02001_02"))
  }


  # Parse and return data...
  if(race %in% variables){
    .data <- dplyr::mutate(race = B02001_02E/B02002_01E) %>% dplyr::select(-B02001_01E, -B02001_02E, -B02001_01M, -B02001_02M)
  } # should I include margin of error?


  # optionally convert to sf
  if (output == "sf"){

    out <- dplyr::filter(out, !is.na(lon) & !is.na(lat))
    out <- sf::st_as_sf(out, coords = c("lon", "lat"), crs = 4326)

  }

  # return result
  return(out)

}
