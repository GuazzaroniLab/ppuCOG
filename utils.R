readCogFun <- function(file = "cog-24.fun.tab") {

  cog.fun.file <- readr::read_lines(file) |>
              stringr::str_split(pattern = "\\t")

  out <- list()
  idx <- 1

  for (el in cog.fun.file) {

    COG_CATEGORY <- NA

    if (length(el) == 2 & stringr::str_detect(el[1], "\\d")) {
      FUNC_CATEGORY_NUMBER <- el[1]
      FUNC_CATEGORY <- el[2]
    } else {
      COG_CATEGORY <- el[1]
      COG_GROUP <- el[2]

      # there is a group without color, so let's test for that
      ASSOC_COLOR <- el[3]
      COG_CATEGORY_DESCRIPTION  <- el[4]

      if (stringr::str_length(ASSOC_COLOR) != 6) {
        ASSOC_COLOR <- NA
        COG_CATEGORY_DESCRIPTION  <- el[3]
      }
    }

    if(!is.na(COG_CATEGORY)) {
    out[[idx]] <- tibble::tibble(FUNC_CATEGORY_NUMBER,
                                 FUNC_CATEGORY,
                                 COG_CATEGORY,
                                 COG_GROUP,
                                 COG_CATEGORY_DESCRIPTION,
                                 ASSOC_COLOR)

    idx <- idx + 1
    }
  }

    out <- out |> purrr::list_rbind()
    return(out)
}
