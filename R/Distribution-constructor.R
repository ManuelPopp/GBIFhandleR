#' Constructor for the Distribution class
#'
#' Creates an object of the \code{Distribution} S4 class by fetching and
#' processing geographical distribution data for a specified species.
#'
#' @param species_name A character string representing the scientific name of the species.
#' This should be a valid name recognized by the Plants of the World Online (POWO) database.
#'
#' @return An object of class \code{Distribution}, containing:
#' \describe{
#'   \item{species_name}{The scientific name of the species.}
#'   \item{geo_distribution}{A list with spatial data for native and introduced regions.}
#' }
#'
#' @details
#' The function performs the following steps to create a \code{Distribution} object:
#' \enumerate{
#'   \item Queries the POWO database to fetch the species code using \code{\link{search_powo_code_by_name}}.
#'   \item Retrieves geographical distribution data from POWO using \code{\link{get_distribution_powo}}.
#'   \item Processes the distribution data to generate spatial polygons for native and introduced regions using \code{\link{spatial_distribution}}.
#' }
#'
#' @examples
#' \dontrun{
#' # Create a Distribution object for Quercus robur
#' distribution_obj <- get_range("Quercus robur")
#'
#' # Access species name
#' distribution_obj@species_name
#'
#' # Plot the distribution
#' plot(distribution_obj)
#' }
#'
#' @seealso \link{Distribution-class}, \link{search_powo_code_by_name}, \link{get_distribution_powo}, \link{spatial_distribution}
#'
#' @export
get_range <- function(species_name) {
  species_code <- search_powo_code_by_name("Quercus robur")
  locations <- get_distribution_powo(species_code)
  sdist <- spatial_distribution(locations)
  new("Distribution", species_name = species_name, geo_distribution = sdist)
}
