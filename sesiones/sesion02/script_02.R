
# Introducción a la estructura de etiquetas HTML --------------------------

# Antes un ejemplo con la API de Google Books

require(httr)
require(glue)
require(data.table)
require(jsonlite)
require(tibble)
require(rvest)

url <- "https://www.googleapis.com/books/v1/volumes?q=web%20scraping"

get_url <- httr::GET(url)

data_url <- httr::content(get_url, as = "parsed")

data_url$items[[1]]$volumeInfo$title

data_url$items[[1]][[5]][[1]]

get_url_text <- httr::content(get_url, "text")

data_json <- jsonlite::fromJSON(get_url_text, flatten = TRUE)

data_text <- tibble::as_tibble(data_json)

head(data_text)

# más de 10...

i <- 0
n <- 1

url <- "https://www.googleapis.com/books/v1/volumes?q=web%20scraping&maxResults=40&startIndex={i}"

list_data = list()

while (TRUE) { # Este es un tipo de bucle que ocurre mientras una condición es verdadera

  get_url <- httr::GET(glue::glue(url))

  get_url_text <- httr::content(get_url, "text")

  data_json <- jsonlite::fromJSON(get_url_text, flatten = TRUE)

  if (length(data_json$items) == 0) {break} #  Se utiliza para salir de un bucle

  list_data[[n]] <- as.data.frame(data_json)

  i = i + 40

  n = n + 1

  }

data_text <- data.table::rbindlist(list_data, fill = TRUE) |> tibble::as_tibble()

data_text[ , c(7:8)] |> print(n = 30)

# https://developers.google.com/books/docs/v1/using


# Recuperar y analizar una página HTML ------------------------------------

url <- "https://github.com/agusnieto77/web-scraping-con-r"

pag <- rvest::read_html(url)

# obtener los nombres de las sesiones mediante XPATH
pag |> rvest::html_elements(xpath="//article/h3") |> rvest::html_text2()

# obtener los nombres de las sesiones mediante CSS Selector
pag |> rvest::html_elements(css = "article h3") |> rvest::html_text2()

# obtener los párrafos de las sesiones mediante XPATH
pag |> rvest::html_elements(xpath="//article/p") |> rvest::html_text2()

# obtener los párrafos de las sesiones mediante CSS Selector
pag |> rvest::html_elements(css = "article > p") |> rvest::html_text2()

# obtener los párrafos anidados de las sesiones mediante XPATH
pag |> rvest::html_elements(xpath="//article //p") |> rvest::html_text2()

# obtener los párrafos anidados de las sesiones mediante CSS Selector
pag |> rvest::html_elements(css = "article p") |> rvest::html_text2()

# Análisis de enlaces ---------------------------------

pag |> rvest::html_elements(xpath = "//a") |> rvest::html_attr("href")

pag |> rvest::html_elements(css = "a") |> rvest::html_attr("href")

tibble::tibble(
  h3 = pag |> rvest::html_elements(css = "article h3") |> rvest::html_text2(),
  p = pag |> rvest::html_elements(css = "article > p") |> rvest::html_text2(),
  a = pag |> rvest::html_elements(css = "article h3 a") |> rvest::html_attr("href")
)
