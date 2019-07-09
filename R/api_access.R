# API Key Storage Functions

#' Install API Keys for Census and BLS APIs
#'
#' @param census Your Census Bureau API key, can be obtained from \href{Census Bureau API}{} If you already have a \code{tidycensus} key installed, you do not need this
#' @param bls Bureau of Labor Statistics API key, can be obtained from \href{Bureau of Labor Statistics}{} If you already have a \code{blscrapeR} key installed you do not need this
#' @param overwrite Logical, if TRUE will overwrite the installation in the .Renviron of the keys specified


eads_install_keys <- function(census, bls, overwrite = FALSE){

  if(missing(census) & missing(bls)){
    stop("No keys were provided to be installed")
  }

  if(!missing(census)){
    tidycensus::census_api_key(census, overwrite, install = TRUE)
  }

  if(!missing(bls)){
    blscrapeR::set_bls_key(bls, overwrite)
  }

}
