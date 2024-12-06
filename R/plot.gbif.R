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
#'   - `"default"`: Uses the `landmass` SpatVector stored in the package.
#'   - A user-specified SpatVector or other compatible map object.
#' @param cell_colour The color used to outline grid cells in the plot. Default is `"red"`.
#' @param ... Additional arguments passed to the `plot()` function for customizing the background map.
#'
#' @return This function does not return a value. It produces a plot showing:
#'   - The specified background map.
#'   - Grid cells used in the search (if applicable), outlined in the specified `cell_colour`.
#'   - Points representing GBIF occurrence records.
#'
#' @details
#' - The function uses the `terra` package for handling spatial objects and plotting.
#' - Occurrence records are visualized as points, and grid cells are overlaid as polygons.
#' - The `landmass` SpatVector, included in the package as a `.rda` file, is used as the default background map.
#'
#' @examples
#' # Example: Plot GBIF search results
#' plot.gbif(
#'   x = gbif_results,
#'   background = "default",
#'   cell_colour = "blue"
#' )
#'
#' # Example: Use a custom background map
#' custom_map <- terra::rast("path/to/custom_map.tif")
#' plot.gbif(
#'   x = gbif_results,
#'   background = custom_map
#' )
#'
#' @import terra
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
  }
  plot(background_map, ...)
  for (r in 1:nrow(grid)) {
    row <- grid[r, ]
    cell <- terra::as.polygons(
      terra::ext(row$lonmin, row$lonmax, row$latmin, row$latmax)
    )
    plot(cell, border = cell_colour, add = TRUE)
  }
  
  all_entries <- terra::vect(
    data, geom = c("decimalLongitude", "decimalLatitude"), crs = "epsg:4326"
  )
  
  plot(all_entries, add = TRUE)
}