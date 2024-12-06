#' Count records for a species within a lon lat grid cell in GBIF
#'
#' This function uses count_records to query the GBIF database and count the
#' number of observation records for a specified species without retrieving the
#' dataset.
#'
#' @param x A data frame holding the grid cells.
#' @param species_name A character string specifying the scientific name of
#'     the species to search for.
#' @param hasCoordinate Logical. If `TRUE`, only count records with coordinate
#'     data. The default is `TRUE`.
#' @param hasGeospatialIssue Logical. If `FALSE`, excludes records with known
#'     geospatial issues. Default is `FALSE`.
#' @param ... Additional parameters to pass to `rgbif::occ_search()` for
#'     further filtering (e.g., year, country).
#'
#' @return An integer representing the observation count.
#'
#' @details
#' - The function uses the `rgbif::occ_search()` function with a `limit` of
#'     `0` to efficiently count records without downloading data.
#' - Filters such as `hasCoordinate` and `hasGeospatialIssue` allow for
#'     restricting the count to specific types of records.
#'
#' @examples
#' # Example 1: Count records for a species with coordinates and no geospatial issues
#' count_records("Ficaria verna Huds.")
#'
#' # Example 2: Count records for a species in a specific year
#' count_records("Ficaria verna Huds.", year = "2020")
#'
#' @import rgbif
#' @export
count_records_grid <- function(
    x, species_name, hasCoordinate = TRUE, hasGeospatialIssue = FALSE, ...
) {
  if (is.na(x[5])) {
    num_records <- count_records(
      species_name,
      hasCoordinate = TRUE, hasGeospatialIssue = FALSE,
      decimalLatitude = paste(x[c(1, 2)], collapse = ","),
      decimalLongitude = paste(x[ c(3, 4)], collapse = ","),
      ...
    )
    return(num_records)
  } else {
    return(x[5])
  }
}
