#' Split grid cells with many observations into four quarters
#' 
#' Split grid into four quarters if the number of observations
#' within the grid cell is larger than the maximum allowed by
#' GBIF. Grid cells are only split as long as they retain the
#' minimum height and width as provided through min_collapse_lat
#' and min_collapse_lon. If the minimum height or width criterium
#' is no longer met after splitting, the grid cell is returned as
#' is and the number of observations is set to the maximum value
#' of 100'000. Thus, there will only 100'000 observations be
#' extracted per minimum grid cell during the analyses.
#' @param grid The initial grid (a data.frame with the columns `latmin`,
#'     `lonmin`, `latmax`, and `lonmax`, as well as a column `num_records`
#'     which indicates the current number of records found in the grid cells).
#' @param min_collapse_lat Numeric. A threshold providing the minimum
#'     height of a grid cell in degrees latitude. The default is 1.
#' @param min_collapse_lon Numeric. A threshold providing the minimum
#'     width of a grid cell in degrees longitude The default is 1.
#' @return A data.frame containing a new grid where cells with too many
#'     observations have been split into quarters by longitude and latitude.
#'
#' @export
split_grid <- function(grid, min_collapse_lat = 1, min_collapse_lon = 1) {
  grid_new <- grid[grid$num_records <= config$GBIFMAX,]
  grid_split <- grid[grid$num_records > config$GBIFMAX,]
  
  for (r in 1:nrow(grid_split)) {
    lat_min_a <- grid_split$latmin[r]
    lat_max_b <- grid_split$latmax[r]
    lon_min_a <- grid_split$lonmin[r]
    lon_max_b <- grid_split$lonmax[r]
    lat_max_a <- lat_min_a + (lat_max_b - lat_min_a) / 2
    lat_min_b <- lat_max_a
    lon_max_a <- lon_min_a + (lon_max_b - lon_min_a) / 2
    lon_min_b <- lon_max_a
    if (
      (lat_max_b - lat_min_a) <= min_collapse_lat |
      (lon_max_b - lon_min_a) <= min_collapse_lon
    ) {
      new_rows <- grid_split[r, ]
      new_rows$num_records <- config$GBIFMAX
    } else {
      new_rows <- data.frame(
        latmin = c(lat_min_a, lat_min_b, lat_min_b, lat_min_a),
        latmax = c(lat_max_a, lat_max_b, lat_max_b, lat_max_a),
        lonmin = c(lon_min_a, lon_min_a, lon_min_b, lon_min_b),
        lonmax = c(lon_max_a, lon_max_a, lon_max_b, lon_max_b),
        num_records = rep(NA, 4)
      )
    }
    
    grid_new <- rbind(grid_new, new_rows)
  }
  
  return(grid_new)
}