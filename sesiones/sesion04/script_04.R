
# Funciones para el raspado masivo de páginas estáticas -------------------

## Activamos las funciones del paquete {rvest}
require(rvest)

## EJEMPLO 1
## Creamos el objeto urls con los links a las páginas de interés
urls <- paste0("https://cgspace.cgiar.org/discover?rpp=", 20, "&etal=0&group_by=none&page=", 1:10)

urls

## Raspamos la información de interés dentro de un marco de datos
## Creamos un marco de datos vacío
repo <- tibble::tibble()

repo

## Corremos un ciclo for
for (i in urls) {
  html <- read_html(httr::GET(i))
  repo <- rbind(repo, tibble::tibble(
    titulo = html |> html_elements("a.description-info") |> html_text2(),
    autoria = html |> html_elements("span.description-info") |> html_text2(),
    fecha = html |> html_elements("span.date") |> html_text2(),
    tipo = html |> html_elements(".artifact-description > div > div:nth-child(3) > div:nth-child(2)") |> html_text2() |> stringr::str_remove_all("Type:"),
    link = html |> html_elements("a.description-info") |> html_attr("href") |> url_absolute("https://cgspace.cgiar.org")
  ))
  repo <- repo |> unique()
}

repo

## Con la función purrr
## Creamos una función para raspar contenido web
raspador <- function(link){
  html <- read_html(httr::GET(link))
  repo <- tibble::tibble(
    titulo = html |> html_elements("a.description-info") |> html_text2(),
    autoria = html |> html_elements("span.description-info") |> html_text2(),
    fecha = html |> html_elements("span.date") |> html_text2(),
    tipo = html |> html_elements(".artifact-description > div > div:nth-child(3) > div:nth-child(2)") |> html_text2() |> stringr::str_remove_all("Type:"),
    link = html |> html_elements("a.description-info") |> html_attr("href") |> url_absolute("https://cgspace.cgiar.org")
  )
  repo <- repo |> unique()
}

## Seleccionamos 2 de los 10 links del objeto urls
links <- urls[1:2]

links

## Raspamos la información de interés dentro de un marco de datos con la función map_df()
output <- purrr::map_df(urls[1:2], raspador)

## Pasamos a raspar el contenido de los 500 links recuperados
## Creamos el objeto links con 20 urls a las páginas de interés
links <- repo$link[1:20]

links

## Raspamos la información de interés
## Creamos vectores vacíos
titulo <- c()
autoria <- c()
fecha <- c()
idioma <- c()
tipo <- c()
acceso <- c()
cita <- c()
link_permanente <- c()
resumen <- c()
items <- c()
descripcion <- c()
link <- c()

## Corremos un ciclo for
for (i in links) {
  html <- read_html(GET(i))
    titulo <- append(titulo, html |> html_element("h2.page-header.first-page-header") |> html_text2())
    autoria <- append(autoria, html |> html_elements(".col-sm-4 > div.simple-item-view-authors.item-page-field-wrapper.table > div") |> html_text2() |> paste(collapse = "; "))
    fecha <- append(fecha, html |> html_elements(xpath = "//*[@id='aspect_artifactbrowser_ItemViewer_div_item-view']/div/div/div[1]/div[3]/text()[2]") |> html_text2())
    idioma <- append(idioma, html |> html_elements(xpath = "//*[@id='aspect_artifactbrowser_ItemViewer_div_item-view']/div/div/div[1]/div[4]/text()[2]") |> html_text2())
    cita <- append(cita, html |> html_element("div.col-sm-8 > div:nth-child(2) > div") |> html_text2())
    link_permanente <- append(link_permanente, html |> html_element("div.col-sm-8 > div:nth-child(3) > div:nth-child(1) > span > a") |> html_attr("href"))
    items <- append(items, html |> html_element(".col-sm-4") |> html_text2())
    descripcion <- append(descripcion, html |> html_element(".simple-item-view-description") |> html_text2())
    link <- append(link, html |> html_elements(".simple-item-view-show-full.item-page-field-wrapper.table a") |> html_attr("href") |> url_absolute("https://cgspace.cgiar.org"))
}

# Armamos el marco de datos
biblio <- tibble::tibble(
  titulo = titulo,
  autoria = autoria,
  fecha = fecha,
  idioma = idioma,
  tipo = tipo,
  acceso = acceso,
  cita = cita,
  link_permanente = link_permanente,
  resumen = resumen,
  items = items,
  descripcion = descripcion,
  link = link
)

## EJEMPLO 2
## Creamos el objeto url con el link a la página de interés
urls <- c(paste0("https://agendaeventos.sercotec.cl/Centro/Detalle?regionId=",0:20),
          paste0("https://agendaeventos.sercotec.cl/Centro/Detalle?centroId=",0:20),
          paste0("https://agendaeventos.sercotec.cl/Centro/Detalle?id=",0:20))

## Creamos un marco de datos vacío
cursos <- data.frame()

## Corremos un ciclo for
for (i in urls) {
  html <- read_html(i)
  cursos <-  rbind(cursos, data.frame(
    fecha = html |> html_elements(".card-body > .d-inline:nth-child(2)") |> html_text2(),
    titulo = html |> html_elements(".card-body > .title-event") |> html_text2(),
    descripcion = html |> html_elements(".card-body > .p-event") |> html_text2(),
    region = html |> html_elements(".card-body > .d-inline:nth-child(3)") |> html_text2(),
    hora = html |> html_elements(".card-body > .d-inline:nth-child(4)") |> html_text2(),
    lugar = html |> html_elements(".card-body > .d-inline:nth-child(5)") |> html_text2()
  )) |> unique()
}

curso

## EJEMPLO 3
## Creamos el objeto urls con los links a las páginas de interés
urls <- paste0("https://eligemejor.sence.cl/BuscarCursoNuevo/DetalleCursoDcp?curso=",99:210)

## Creamos un marco de datos vacío
cursos <- data.frame()

## Corremos un ciclo for
for (i in urls) {
  html <- read_html(i)
  cursos <-  rbind(cursos, data.frame(
    titulo = html |> html_elements(".fuenteTitulo") |> html_text2(),
    ejecutor = html |> html_elements(".fuenteChica") |> html_text2(),
    requisitos = html_text2(html_elements(html, ".panel-body-capa p"))[1] |> stringr::str_trim(),
    descripcion = html_text2(html_elements(html, ".panel-body-capa p"))[2] |> stringr::str_trim(),
    objetivo = html_text2(html_elements(html, ".panel-body-capa p"))[3] |> stringr::str_trim(),
    fecha = html_text2(html_elements(html, ".col-md-12.DetallesCurso .col-md-6 p.codSence"))[6] |> stringr::str_trim(),
    lugar = html_text2(html_elements(html, ".col-md-12.DetallesCurso .col-md-6 p.codSence"))[9] |> stringr::str_trim()
  )) |> unique()
}

cursos |> tibble::tibble()

## Hacemos una limpieza de texto básica
cursos$ejecutor <- gsub("^EJECUTOR: ", "", cursos$ejecutor)
cursos$requisitos <- gsub("^- ", "", cursos$requisitos)
cursos$requisitos <- gsub("^\\. ", "", cursos$requisitos)
cursos$fecha <- gsub("^Inicio de Clases:\r ", "", cursos$fecha)
cursos$fecha <- as.Date(cursos$fecha, format = "%d-%m-%Y")
cursos$lugar <- gsub("^Dirección: ", "", cursos$lugar)

cursos |> tibble::tibble()

## EJEMPLO 4
## Creamos el objeto urls con los links a las páginas de interés
urls <- paste0("https://coolprice.cl/t/categorias/desayuno-y-dulces?page=", 1:15)

## Creamos un marco de datos vacío
precios <- data.frame()

## Corremos un ciclo for
for (i in urls) {
  html <- read_html(i)
  precios <-  rbind(precios, data.frame(
    marca = html |> html_elements(".product-brand") |> html_text2(),
    producto = html |> html_elements(".product-component-name") |> html_text2(),
    precio = html |> html_elements(".margin-price-p") |> html_text2(),
    precio_unidad = gsub("if @is_in_taxon_show.present\\? ", "",
                         html |> html_elements(".product-component-price-by-measurement") |> html_text2())
  )) |> unique()
}

precios |> tibble::tibble()
