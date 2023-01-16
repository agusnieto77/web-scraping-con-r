
# Funciones para el raspado de páginas estáticas --------------------------

## Activamos las funciones del paquete {rvest}
require(rvest)
require(htmltidy)

## EJEMPLO 1
## Creamos el objeto url con el link a la página de interés
url <- "https://agendaeventos.sercotec.cl/Centro/Detalle?regionId=0&id=0&centroId=0"

## Inspeccionamos el contenido de la página web
url(url) |> tidy_html() |> cat()
## con otro enfoque
for (i in as.list(readLines(con = url))) {print(i)}

## Creamos el objeto html con el contenido de la url
html <- read_html(url)

## Raspamos la información de interés dentro de un marco de datos
cursos <- tibble::tibble(
    fecha = html |> html_elements(".card-body > .d-inline:nth-child(2)") |> html_text2(),
    titulo = html |> html_elements(".card-body > .title-event") |> html_text2(),
    descripcion = html |> html_elements(".card-body > .p-event") |> html_text2(),
    region = html |> html_elements(".card-body > .d-inline:nth-child(3)") |> html_text2(),
    hora = html |> html_elements(".card-body > .d-inline:nth-child(4)") |> html_text2(),
    lugar = html |> html_elements(".card-body > .d-inline:nth-child(5)") |> html_text2()
    ) |> unique()

## Inspeccionamos el marco de datos
cursos

## EJEMPLO 2
## Creamos el objeto url con el link a la página de interés
url1 <- "https://eligemejor.sence.cl/BuscarCursoNuevo/DetalleCursoDcp?curso=CAP-21-01-13-0129-1"
url2 <- "https://eligemejor.sence.cl/BuscarCursoNuevo/DetalleCursoDcp?curso=CAP-22-01-05-0030-1"

## Inspeccionamos el contenido de la página web
url(url1) |> tidy_html() |> cat()
## con otro enfoque
for (i in as.list(readLines(con = url2))) {print(i)}

## Creamos el objeto html con el contenido de la url
html1 <- read_html(url1)
html2 <- read_html(url2)

## Raspamos la información de interés dentro de un marco de datos
curso1 <- data.frame(
    titulo = html1 |> html_elements(".fuenteTitulo") |> html_text2(),
    ejecutor = html1 |> html_elements(".fuenteChica") |> html_text2(),
    requisitos = html_text2(html_elements(html1, ".panel-body-capa p"))[1] |> stringr::str_trim(),
    descripcion = html_text2(html_elements(html1, ".panel-body-capa p"))[2] |> stringr::str_trim(),
    objetivo = html_text2(html_elements(html1, ".panel-body-capa p"))[3] |> stringr::str_trim(),
    fecha = html_text2(html_elements(html1, ".col-md-12.DetallesCurso .col-md-6 p.codSence"))[6] |> stringr::str_trim(),
    lugar = html_text2(html_elements(html1, ".col-md-12.DetallesCurso .col-md-6 p.codSence"))[9] |> stringr::str_trim()
  )

curso2 <- data.frame(
  titulo = html2 |> html_elements(".fuenteTitulo") |> html_text2(),
  ejecutor = html2 |> html_elements(".fuenteChica") |> html_text2(),
  requisitos = html_text2(html_elements(html2, ".panel-body-capa p"))[1] |> stringr::str_trim(),
  descripcion = html_text2(html_elements(html2, ".panel-body-capa p"))[2] |> stringr::str_trim(),
  objetivo = html_text2(html_elements(html2, ".panel-body-capa p"))[3] |> stringr::str_trim(),
  fecha = html_text2(html_elements(html2, ".col-md-12.DetallesCurso .col-md-6 p.codSence"))[6] |> stringr::str_trim(),
  lugar = html_text2(html_elements(html2, ".col-md-12.DetallesCurso .col-md-6 p.codSence"))[9] |> stringr::str_trim()
)

## Unificamos las tablas
cursos <- rbind(curso1, curso2)

## Borramos los objetos que no vamos a usar
rm(curso1, curso2, html1, html2, i, url1, url2)

## Limpiamos la consola
cat("\014")

## Inspeccionamos el marco de datos
str(cursos)
## Otro enfoque
dplyr::glimpse(cursos)

## EJEMPLO 3
## Creamos el objeto url con el link a la página de interés
url <- "https://coolprice.cl/t/categorias/congelados/pescados-y-mariscos-congelados"

## Creamos el objeto html con el contenido de la url
html <- read_html(url)

## Creamos el objeto NODOS con los elementos contenidos en el objeto html
nodos <- html_elements(html, ".product-component-name")

## Creamos el vector de textos con los productos con la función html_text()
nodos |> html_text()
## Creamos el vector de textos con los productos con la función html_text2()
nodos |> html_text2()

## EJEMPLO TABLAS

poblacion <- read_html("https://datosmacro.expansion.com/demografia/poblacion/chile") |>
  html_element("table") |> html_table()

## Imprimimos el marco de datos
poblacion
