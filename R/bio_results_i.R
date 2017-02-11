#' Results
#'
#' @description Analyzes all the required biophysical indicators at once
#'
#' @param data The data to be analyzed
#' @param res The name of the reserve
#' @param con The name of the control site
#' @param values A list, created within the Shiny app, that contains the list of indicators selected and the community
#'
#' @return results, a tibble containing the name of the indicator as well as DiD estimates, p values, a string to be used as input for valueBox, the color of the valueBox, and the lm object fit to the indicator extracted from the data
#' @export
#'
#'

bio_results_i <- function(values, data, res, con) {
  library(broom)
  # Establish a dataframe where to store all values
  results <- tibble::tibble(
    Ind = c(
      "Shannon",
      "Riqueza",
      "Densidad",
      "DensidadObj"
    ),
    e = NA,
    p = NA,
    string = NA,
    color = NA,
    model = list(NA),
    plot = list(NA)
  )

  ####
  if ("Indice de diversidad de Shannon" %in% values$indB) {
    model <- MPAtools::shannon(data, values$comunidad) %>%
      turfeffect(res, con, type = "bio")

    TidyModel <- tidy(model) %>%
      filter(term == "Ano:ZonaReserva")

    results$e[1] <- TidyModel$estimate
    results$p[1] <- TidyModel$p.value
    results$string[1] <- valueBoxString(model, "bio")
    results$color[1] <- bio_score(model)
    results$model[[1]] <- model
    results$plot[[1]] <- mpa_plot4(model, y.lab = "Shannon (H'/Transecto)")
  }

  ####
  if ("Riqueza" %in% values$indB) {
    model <- richness(data, values$comunidad) %>%
      turfeffect(res, con, type = "bio")

    TidyModel <- tidy(model) %>%
      filter(term == "Ano:ZonaReserva")

    results$e[2] <- TidyModel$estimate
    results$p[2] <- TidyModel$p.value
    results$string[2] <- valueBoxString(model, "bio")
    results$color[2] <- bio_score(model)
    results$model[[2]] <- model
    results$plot[[2]] <- mpa_plot4(model, y.lab = "Riqueza (Especies/Transecto)")
  }

  ####
  if ("Densidad" %in% values$indB) {
    model <- density(data, values$comunidad) %>%
      turfeffect(res, con, type = "bio")

    TidyModel <- tidy(model) %>%
      filter(term == "Ano:ZonaReserva")

    results$e[3] <- TidyModel$estimate
    results$p[3] <- TidyModel$p.value
    results$string[3] <- valueBoxString(model, "bio")
    results$color[3] <- bio_score(model)
    results$model[[3]] <- model
    results$plot[[3]] <- mpa_plot4(model, y.lab = "Densidad (Organismos/Transecto)")
  }

  return(results)
}