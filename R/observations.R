#' Observations of Tragopogon dubius
#'
#' This dataset is the result of a GBIF search conducted using the `get_observations()` function for the species "Tragopogon dubius".
#'
#' @format A list with the following components:
#' \describe{
#'   \item{data}{A tibble containing observation data. The columns typically include:
#'     \describe{
#'       \item{\code{scientificName}}{The scientific name of the species.}
#'       \item{\code{taxonID}}{The taxon identifier.}
#'       \item{\code{taxonKey}}{The GBIF taxon key.}
#'       \item{\code{continent}}{The continent where the observation occurred.}
#'       \item{\code{decimalLatitude}}{The latitude of the observation.}
#'       \item{\code{decimalLongitude}}{The longitude of the observation.}
#'       \item{\code{year}}{The year of the observation.}
#'     }
#'   }
#'   \item{grid}{A data frame containing the grid cells used during the search. Columns include:
#'     \describe{
#'       \item{\code{latmin}}{The minimum latitude of the grid cell.}
#'       \item{\code{latmax}}{The maximum latitude of the grid cell.}
#'       \item{\code{lonmin}}{The minimum longitude of the grid cell.}
#'       \item{\code{lonmax}}{The maximum longitude of the grid cell.}
#'       \item{\code{num_records}}{The number of records found within the grid cell.}
#'     }
#'   }
#'   \item{inputname}{A character string representing the input species name used for the search ("Tragopogon dubius").}
#'   \item{gbifname}{A character string representing the GBIF-matched scientific name ("Tragopogon dubius Scop.").}
#' }
#'
#' @details
#' The `observations` object provides the result of a GBIF search for the species "Tragopogon dubius". It includes:
#' - The matched GBIF name to ensure taxonomic consistency.
#' - A tibble of observations, including key metadata.
#' - Information on the grid cells used for splitting the search when large datasets were encountered.
#'
#' @examples
#' # Access observation data
#' observations$data
#'
#' # Access grid information
#' observations$grid
#'
#' # Input and matched species names
#' observations$inputname
#' observations$gbifname
#'
#' @seealso \code{\link{get_observations}}
#'
#' @keywords datasets
"observations"
