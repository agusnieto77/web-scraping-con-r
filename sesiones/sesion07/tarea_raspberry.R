# Paquetes a cargar ----------------
require(tibble)
require(dplyr)
require(rvest)

# Creamos la función para raspar El Mundo cuyo nombre será 'scraping_EM()' ------------------------

scraping_EM <- function (x){          # abro función para raspado web y le asigno un nombre: scraping_EM
    rvest::read_html(x) |>            # llamo a la función read_html() para obtener el contenido de la página
    rvest::html_elements(".ue-c-cover-content__headline-group") |>  # llamo a la función html_elements() y especifico las etiquetas de los títulos
    rvest::html_text() |>             # llamo a la función html_text() para especificar el formato 'chr' del título.
    tibble::as_tibble() |>            # llamo a la función as_tibble() para transforma el vector en tabla
    dplyr::rename(titulo = value)     # llamo a la función rename() para renombrar la variable 'value'
}                                     # cierro la función para raspado web

# Usamos la función para scrapear el diario El Mundo ----------------------------------------------

scraping_EM("https://www.elmundo.es/espana.html") |> saveRDS(paste0("/run/user/1000/gvfs/google-drive:host=gmail.com,user=agustin.nieto77/0AAwMIh-cC2HvUk9PVA/1wAoRmwGREOSBmUegU9iv6xoSomRsZuSK/el_mundo_", format(Sys.time(), format = "%Y_%m_%d_%H_%M_%S"), ".rds"))
