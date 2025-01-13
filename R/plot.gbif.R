#' Plot GBIF search results
#'
#' This function visualizes the results of a GBIF search, including occurrence records and grid cells used in gridded downloads, over a specified background map.
#'
#' @param x A list containing GBIF search results, typically the output from `get_observations()`.
#'   Must include the following components:
#'   - `data`: A data frame of occurrence records, with columns `decimalLongitude` and `decimalLatitude`.
#'   - `grid`: A data frame defining grid cells, with columns `lonmin`, `lonmax`, `latmin`, and `latmax`.
#'   - `gbifname`: The GBIF taxonomic name used in the search.
#' @param background The background map to plot. Options:
#'   - `"default"`: Uses the `landmass` sfc_POLYGON stored in the package.
#'   - A user-specified sfc_POLYGON or other compatible map object.
#' @param cell_colour The color used to outline grid cells in the plot. Default is `"red"`.
#' @param ... Additional arguments passed to the `plot()` function for customizing the background map.
#'
#' @return This function does not return a value. It produces a plot showing:
#'   - The specified background map.
#'   - Grid cells used in the search (if applicable), outlined in the specified `cell_colour`.
#'   - Points representing GBIF occurrence records.
#'
#' @details
#' - The function uses the `sf` package for handling spatial objects and plotting.
#' - Occurrence records are visualized as points, and grid cells are overlaid as polygons.
#' - The `landmass` `sfc_POLYGON`, included in this package as a `.rda` file, is used as the default background map.
#'
#' @examples
#' \dontrun{
#' # Example: Plot GBIF search results
#' data(landmass)
#' data(observations)
#' plot.gbif(
#'   x = observations$data,
#'   background = "default",
#'   cell_colour = "blue"
#' )
#' }
#'
#' @import sf
#' @export
plot.gbif <- function(
    x, background = "default", cell_colour = "red", ...
    ) {
  if (is.list(x)) {
    data <- x$data
    grid <- x$grid
    name <- x$gbifname
  }

  if (background == "default") {
    background_map <- landmass
  } else {
    background_map <- background
  }
  # Get current plot settings
  original_par <- par()
  # Plot
  par(mar = c(0, 0, 0, 0), mfrow = c(1, 1))
  plot(sf::st_geometry(background_map), ...)
  for (r in 1:nrow(grid)) {
    row <- grid[r, ]
    bbox <- matrix(
      c(row$lonmin, row$latmin,
        row$lonmax, row$latmin,
        row$lonmax, row$latmax,
        row$lonmin, row$latmax,
        row$lonmin, row$latmin),
      ncol = 2, byrow = TRUE
    )
    cell <- sf::st_polygon(list(bbox)) %>%
      sf::st_sfc(crs = 4326)
    plot(cell, border = cell_colour, add = TRUE)
  }

  all_entries <- sf::st_as_sf(
    data, coords = c("decimalLongitude", "decimalLatitude"), crs = 4326
  )

  plot(
    sf::st_geometry(all_entries), add = TRUE, pch = 16, cex = 0.5,
    col = grDevices::rgb(0, 102, 102, 75, maxColorValue = 255)
    )
  # Reset plot setting
  readonly_params <- c("cin", "cra", "csi", "cxy", "din", "page")
  reset_par <- original_par[setdiff(names(original_par), readonly_params)]
  par(reset_par)
}
