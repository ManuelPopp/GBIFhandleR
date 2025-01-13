#' Retrieve spatial polygons for species distribution
#'
#' This function retrieves spatial polygons corresponding to native and introduced
#' locations for a species using TDWG WGSRPD polygons.
#'
#' @param locations A list containing location information for a species, typically obtained
#' from the \code{\link{get_distribution_powo}} function. The list should have the following elements:
#' \describe{
#'   \item{native_tdwg}{A character vector of TDWG codes for native regions.}
#'   \item{introduced_tdwg}{A character vector of TDWG codes for introduced regions.}
#'   \item{native_name}{(Optional) A character vector of native region names.}
#'   \item{introduced_name}{(Optional) A character vector of introduced region names.}
#' }
#'
#' @return A list containing two `sf::st_sfc` objects:
#' \describe{
#'   \item{native}{A simple feature collection object containing polygons for native regions.}
#'   \item{introduced}{A simple feature collection object containing polygons for introduced regions.}
#' }
#' If any location codes are not found in the TDWG WGSRPD level 4 dataset, a warning is issued.
#'
#' @details
#' The function matches the TDWG codes from the input `locations` to the `tdwg` dataset, which contains the WGSRPD polygons combined for all levels. For unmatched codes, a warning is raised with the names of the missing locations. The function returns two spatial objects corresponding to native and introduced distributions.
#'
#' @note
#' The `tdwg` dataset must be preloaded and should contain at least two columns:
#' \describe{
#'   \item{code}{TDWG region codes (level 4).}
#'   \item{geometry}{The spatial polygons for the regions.}
#' }
#'
#' @examples
#' \dontrun{
#' # Example locations input
#' locations <- list(
#'   native_tdwg = c("AFC", "AMZ"),
#'   introduced_tdwg = c("ANT", "AUS"),
#'   native_name = c("Africa", "Amazon"),
#'   introduced_name = c("Antarctica", "Australia")
#' )
#'
#' # Retrieve spatial polygons
#' spatial_data <- spatial_distribution(locations)
#'
#' # View native polygons
#' plot(spatial_data$native)
#'
#' # View introduced polygons
#' plot(spatial_data$introduced)
#' }
#'
#' @seealso \link{tdwg}, \link{get_distribution_powo}
#'
#' @export
spatial_distribution <- function(locations) {
  native <- locations$native_tdwg
  introduced <- locations$introduced_tdwg
  all_codes <- c(native, introduced)
  all_names <- c(locations$native_name, locations$introduced_name)
  
  if (any(!all_codes %in% tdwg$code)) {
    mssg <- paste(
      "The following locations were not found in TDWG WGSRPD level 4 polygons:",
      paste(all_names[which(!all_codes %in% tdwg$code)], collapse = ", ")
    )
    warning(mssg)
  }
  
  native_polygons <- tdwg %>%
    dplyr::filter(
      code %in% native
    )
  
  introduced_polygons <- tdwg %>%
    dplyr::filter(
      code %in% introduced
    )
  
  return(
    list(
      native = native_polygons,
      introduced = introduced_polygons
    )
  )
}
