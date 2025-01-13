#' Distribution Class
#'
#' An S4 class to represent the geographical distribution of a species, including
#' native and introduced regions.
#'
#' @slot species_name A character string representing the scientific name of the species.
#' @slot geo_distribution A list containing spatial objects of type `st_sfc` for native and introduced regions.
#' Typically, this list is generated using the `spatial_distribution` function.
#'
#' @details
#' The `Distribution` class stores the scientific name of a species along with its geographical distribution, which includes native and introduced regions.
#' The `geo_distribution` slot contains spatial polygons following the TDWG regions as returned from POWO
#' @section Methods:
#' \describe{
#'   \item{\code{plot}}{
#'     A method to visualize the distribution. It plots the TDWG regions and overlays the native and introduced distributions in different colors.
#'   }
#' }
#'
#' @examples
#' \dontrun{
#' # Create a Distribution object for Quercus robur
#' range <- get_range("Quercus robur")
#'
#' # Plot the distribution
#' plot(range)
#' }
#'
#' @seealso \link{get_range}, \link{spatial_distribution}, \link{plot}
#'
#' @exportClass Distribution
setClass(
  Class = "Distribution",
  slots = list(
    species_name = "character",
    geo_distribution = "ANY"
  )
)
