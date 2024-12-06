#' Default configuration for GBIFhandleR package
#'
#' A list containing default configuration values used across the package.
#'
#' @format A list with the following elements:
#' \describe{
#'   \item{COLUMNS}{Character vector of default column names for GBIF data.}
#'   \item{GBIFMAX}{Numeric value specifying the maximum number of records to retrieve from GBIF (default: 100).}
#' }
#' @export
config <- list(
  COLUMNS = c(
    "scientificName", "taxonID", "taxonKey", "continent", "decimalLatitude",
    "decimalLongitude", "year"
  ),
  # GBIF maximum returned records = 100'000. Reduce number to speed up script.
  GBIFMAX = 100#0#0#0
)
