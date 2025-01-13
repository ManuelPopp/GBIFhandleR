#' Biodiversity Information Standards: World Geographical Scheme for Recording Plant Distributions
#'
#' A simple feature collection delineating locations following the World Geographical Scheme for Recording Plant Distributions (WGSRPD).
#'
#' @format A `sf::st_sfc` with the following attributes:
#' \describe{
#'   \item{code}{TDWG location code.}
#'   \item{name}{Location name.}
#'   \item{level}{Locality level.}
#'   \item{geometry}{Polygon geometries.}
#' }
#' @source Biodiversity Information Standards (TDWG): https://github.com/tdwg/wgsrpd/tree/master/geojson
#' @examples
#' plot(tdwg)
#'
#' @keywords datasets
"tdwg"
