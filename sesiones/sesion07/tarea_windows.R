# Paquetes a cargar ----------------
require(tibble)
require(dplyr)
require(rvest)

# Creamos la función para raspar El Mundo cuyo nombre será 'scraping_EM()' ------------------------

scraping_EM <- function (x){
  rvest::read_html(x) |>
    rvest::html_elements(".ue-c-cover-content__headline-group") |>
    rvest::html_text() |>
    tibble::as_tibble() |>
    dplyr::rename(titulo = value)
}

# Usamos la función para scrapear el diario El Mundo ----------------------------------------------

scraping_EM("https://www.elmundo.es/espana.html") |>
  saveRDS(paste0("D:/Google_Drive_ok/datos_windows/el_mundo_",
                 format(Sys.time(), format = "%Y_%m_%d_%H_%M_%S"),
                 ".rds"))
