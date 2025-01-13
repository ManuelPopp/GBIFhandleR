#' Search POWO code by species name
#'
#' This function searches the Plants of the World Online (POWO) database for a
#' species by name and returns the unique POWO code (URL) for the first match.
#'
#' @param species_name A character string representing the scientific name of the species to search for.
#' @param preview A logical value indicating whether to preview the first few results. If `TRUE`, prints a preview of up to six results. Defaults to `FALSE`.
#'
#' @return A character string containing the POWO URL for the first match if found; otherwise, `NULL`.
#'
#' @details The function sends a GET request to the POWO API to search for the specified species.
#' If results are found, the unique POWO code (URL) of the first match is returned.
#' If `preview = TRUE`, the function prints a summary of the first few results.
#'
#' @examples
#' \dontrun{
#' # Search for the POWO code of "Quercus robur"
#' powo_code <- search_powo_code_by_name("Quercus robur")
#' print(powo_code)
#'
#' # Preview search results
#' search_powo_code_by_name("Quercus robur", preview = TRUE)
#' }
#'
#' @export
search_powo_code_by_name <- function(
    species_name, preview = FALSE
) {
  base_url <- "http://www.plantsoftheworldonline.org/api/2/"
  encoded_species <- utils::URLencode(species_name)
  search_url <- paste0(base_url, "search?q=", encoded_species)
  response <- httr::GET(search_url)

  if (response$status_code == 200) {
    response_content <- jsonlite::fromJSON(httr::content(response, as = "text"))
  } else {
    cat(
      "Failed to search for species. Status code:",
      response$status_code,
      "\n"
    )
  }

  if (length(response_content$results) > 0) {
    if (preview) {
      cat("Found", nrow(response_content$results), "entries:\n")
      print(response_content$results[1:6])
    } else {
      cat("Found", nrow(response_content$results), "entries.\n")
    }

    species_id <- response_content$results$url[1]

    return(species_id)
  } else {
    cat("No results found for species:", species_name, "\n")
    return(NULL)
  }
}
