#' Natural Earth: Landmass at scale 1:110
#'
#' An `sf::sfc_POLYGON` object representing global landmasses. This dataset is
#' used as a default background map in the package's plotting functions.
#'
#' @format A `sf::sfc_POLYGON` with the following attributes:
#' \describe{
#'   \item{geometry}{Polygon geometries representing landmasses.}
#' }
#' @source Natural Earth: https://www.naturalearthdata.com/
#' @examples
#' plot(landmass)
#'
#' @keywords datasets
"landmass"
