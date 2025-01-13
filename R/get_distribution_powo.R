#' Retrieve species distribution (TDWG codes) from POWO
#'
#' This function queries the Plants of the World Online (POWO) database to
#' retrieve the distribution information for a species using its unique POWO
#' code.
#'
#' @param species_code A character string representing the unique POWO code for the species.
#' This code is typically retrieved from the POWO API via the \code{\link{search_powo_code_by_name}} function.
#'
#' @return A list containing the following elements:
#' \describe{
#'   \item{native_name}{A character vector of native region names for the species.}
#'   \item{introduced_name}{A character vector of introduced region names for the species.}
#'   \item{native_tdwg}{A character vector of native region codes (TDWG standard).}
#'   \item{introduced_tdwg}{A character vector of introduced region codes (TDWG standard).}
#' }
#' If the species code is invalid or the API request fails, the function returns `NULL` and prints an error message.
#'
#' @details
#' The function sends an HTTP GET request to the POWO API to retrieve distribution data for the species identified by the provided code. It extracts information on native and introduced distributions, including both names and TDWG region codes.
#'
#' @note
#' This function depends on the `httr` and `jsonlite` packages for API interaction and JSON parsing.
#' Ensure you have a stable internet connection and that the POWO API endpoint is accessible.
#'
#' @examples
#' \dontrun{
#' # Example usage with a valid POWO species code
#' species_code <- "urn:lsid:ipni.org:names:30003501-2"
#' distribution <- get_distribution_powo(species_code)
#' print(distribution)
#'
#' # Handling an invalid species code
#' invalid_code <- "urn:lsid:ipni.org:names:invalid-code"
#' distribution <- get_distribution_powo(invalid_code)
#' }
#'
#' @seealso \link[httr]{GET}, \link[jsonlite]{fromJSON}
#'
#' @export
get_distribution_powo <- function(species_code) {
  base_url <- "http://www.plantsoftheworldonline.org/api/2/"
  species_url <- paste0(base_url, species_code)
  species_response <- httr::GET(
    species_url, query = list(fields = "distribution")
  )

  if (species_response$status_code == 200) {
    detailed_data <- jsonlite::fromJSON(
      httr::content(species_response, as = "text")
      )
    distribution <- detailed_data$distribution

    return(
      list(
        native_name = distribution$natives$name,
        introduced_name = distribution$introduced$name,
        native_tdwg = distribution$natives$tdwgCode,
        introduced_tdwg = distribution$introduced$tdwgCode
      )
    )
  } else {
    cat(
      "Failed to retrieve species data. Status code:",
      species_response$status_code,
      "\n"
    )
    return(NULL)
  }
}
