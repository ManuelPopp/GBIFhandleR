#' Plot a Distribution object
#'
#' Visualizes the geographical distribution of a species represented by a \code{Distribution} object.
#' The native and introduced ranges are overlaid on the TDWG regions map with customisable colours.
#'
#' @param x An object of class \code{Distribution}, containing the species name and its geographical distribution.
#' @param native_col A character string specifying the coluor used to represent the native range. Defaults to \code{"aquamarine4"}.
#' @param introduced_col A character string specifying the colour used to represent the introduced range. Defaults to \code{"firebrick4"}.
#' @param ... Additional graphical parameters to pass to the underlying \code{\link[graphics]{plot}} function.
#'
#' @details
#' This method plots the TDWG regions map and overlays the native and introduced ranges of the species.
#' The native regions are displayed in \code{native_col}, while the introduced regions are displayed in \code{introduced_col}.
#' The TDWG regions are provided by the preloaded \code{tdwg} dataset.
#'
#' @examples
#' \dontrun{
#' # Example: Plotting the distribution of Quercus robur
#' qr_dist <- get_range("Quercus robur")
#' plot(qr_dist, native_col = "green", introduced_col = "red")
#' }
#'
#' @seealso \link{get_range}, \link{Distribution-class}
#'
#' @exportMethod plot
setMethod(
  f = "plot",
  signature = c(x = "Distribution"),
  definition = function(
    x,
    native_col = "aquamarine4",
    introduced_col = "firebrick4",
    ...) {
    # Get current plot settings
    original_par <- par()
    # Plot
    par(mar = c(0, 0, 0, 0), mfrow = c(1, 1))
    plot(sf::st_geometry(tdwg), ...)
    plot(
      sf::st_geometry(x@geo_distribution$native),
      col = native_col, add = TRUE
      )
    plot(
      sf::st_geometry(x@geo_distribution$introduced),
      col = introduced_col, add = TRUE
    )
    # Reset plot setting
    readonly_params <- c("cin", "cra", "csi", "cxy", "din", "page")
    reset_par <- original_par[setdiff(names(original_par), readonly_params)]
    par(reset_par)
  }
)
