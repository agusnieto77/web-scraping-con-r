
# Funciones para el raspado masivo de páginas dinámicas -------------------

# Web scraping en páginas dinámicas ---------------------------------------
## Cargamos las librerías
require(RSelenium)
require(rvest)
require(tibble)
require(stringr)
require(dplyr)
require(lubridate)


# EJEMPLO 0 ---------------------------------------------------------------

# Creamos los objetos url1 y url2 con la página de cursos
url1 <- "https://eligetucurso.sence.cl/"
url2 <- "https://agendaeventos.sercotec.cl/Centro/Detalle"
url3 <- "https://www.google.com/?hl=es"

# Activamos el servidor selenium y un navegador
servidor <- rsDriver(browser = "chrome", port = 1937L, chromever = "108.0.5359.22")

# Creamos al usuario
cliente <- servidor$client

# Navegamos
cliente$navigate(url1)
cliente$navigate(url2)

# Maximizamos la ventana
cliente$maxWindowSize()

# Hacia atrás
cliente$goBack()

# Hacia delante
cliente$goForward()

# Detectamos el elemento fecha
fecha <- cliente$findElement(using = "css",  value = '#txtFecha')

# Ingresamos datos
fecha$sendKeysToElement(list("10", "10", "2021"))

# Limpiamos datos ingresados
fecha$clearElement()

# Ingresamos datos nuevamente
fecha$sendKeysToElement(list("10", "10", "2020"))

# Hacemos clic en 'Buscar'
cliente$findElement(using = "xpath",
                    value = "/html/body/div/div[3]/div/div[5]/button[1]"
)$clickElement()

# Actualizamos
cliente$refresh()

# Raspamos la dirección URL actual
cliente$getCurrentUrl()[[1]] |> cat()

# Cerramos el navegador
cliente$close()

# Reabrimos el navegador
cliente$open()

# Maximizamos la ventana
cliente$maxWindowSize()

# Navegamos
cliente$navigate(url3)

cliente$findElement(using = "css",  value = '.gLFyf'
                    )$sendKeysToElement(list(
                      "Estacion Lastarria",
                      key = "enter")
                      )

# Cerramos el navegador
cliente$close()

# Detenemos el servidor
servidor$server$stop()

# Limpiamos
rm(list=ls())
cat("\014")


# EJEMPLO 1 ---------------------------------------------------------------

# Creamos el objeto url con la página de cursos
url <- "https://eligetucurso.sence.cl/"

# Activamos el servidor selenium y un navegador
servidor <- rsDriver(browser = "chrome", port = 1937L, chromever = "108.0.5359.22")

# Creamos al usuario
cliente <- servidor$client

# Maximizamos la ventana
cliente$maxWindowSize()

# Navegamos
cliente$navigate(url)

# Vamos hacia abajo
cliente$findElement("css", "body")$sendKeysToElement(list(key = "end"))

# Buscamos el botón de páginas
n_items <- cliente$findElement("css", "#porPagina")

# Hacemos clic para desplegar la lista
n_items$clickElement()

# Buscamos el ítem de 50 páginas
items_50 <- cliente$findElement("css selector", "#porPagina > option:nth-child(4)")

# Seleccionamos los 50 ítems x página
items_50$clickElement()

# Vamos hacia abajo nuevamente
cliente$findElement("css", "body")$sendKeysToElement(list(key = "end"))

# Establecemos la cantidad de páginas totales
n_pags <- cliente$findElements("css", "#pagination div div ul li.paginationjs-page")

# Creamos el vector con los números de página
np <- as.integer(unlist(lapply(n_pags, function(x) x$getElementText())))[-1]

# Creamos el objeto html como documento xml
html <- cliente$getPageSource()[[1]] |> read_html()

# Raspamos el contenido de la primera página
cursos_sence <- tibble(
  titulo = html |> html_elements("h4.cursoTitulo.movitit") |> html_text2(),
  ejecutor = html |> html_elements("#bOtec") |> html_text2(),
  codigo = html |> html_elements("div.row.divPM > div > b:nth-child(2)") |> html_text2(),
  modalidad = html |> html_elements("h5:nth-child(5) > span") |> html_text2(),
  region = html_text2(html_elements(html, "div:nth-child(2) > div > div:nth-child(1) > h6:nth-child(1)"))|> str_remove_all("Región: "),
  comuna = html_text2(html_elements(html, "div:nth-child(2) > div > div:nth-child(1) > h6:nth-child(2)"))|> str_remove_all("Comuna: "),
  horas = html_text2(html_elements(html, "div:nth-child(2) > div > div:nth-child(2) > h6:nth-child(1)"))|> str_remove_all("Horas: "),
  fecha = html_text2(html_elements(html, "div:nth-child(2) > div > div:nth-child(2) > h6:nth-child(2)"))|> str_remove_all("Fecha Inicio: "),
  puntuacion = html_text2(html_elements(html, "#evalDesk > div:nth-child(1) > div > a > label:nth-child(1)")) |> str_trim(),
  evaluaciones = html_text2(html_elements(html, "div:nth-child(1) > div > a > div:nth-child(4) > label")) |>
    str_remove_all("\\(| Evaluaciones de los capacitados\\)"),
  link = html_elements(html, ".col-md-12.col-xs-12.col-sm-12.cursoTituloEmpresa a") |> html_attr("href")
)

# Armamos el ciclo for para raspar todas las páginas
for (i in np) {
  cat("Vuelta", i-1, "\n")
  cliente$findElement("css selector", paste0("#pagination > div > div > ul > li:nth-child(", i, ")"))$clickElement()
  Sys.sleep(2)
  cliente$findElement("css", "body")$sendKeysToElement(list(key = "end"))
  Sys.sleep(1)
  html <- cliente$getPageSource()[[1]] |> read_html()
  Sys.sleep(1)
  cursos_sence <-
    rbind(cursos_sence,
      tibble(
        titulo = html |> html_elements("h4.cursoTitulo.movitit") |> html_text2(),
        ejecutor = html |> html_elements("#bOtec") |> html_text2(),
        codigo = html |> html_elements("div.row.divPM > div > b:nth-child(2)") |> html_text2(),
        modalidad = html |> html_elements("h5:nth-child(5) > span") |> html_text2(),
        region = html_text2(html_elements(html, "div:nth-child(2) > div > div:nth-child(1) > h6:nth-child(1)"))|> str_remove_all("Región: "),
        comuna = html_text2(html_elements(html, "div:nth-child(2) > div > div:nth-child(1) > h6:nth-child(2)"))|> str_remove_all("Comuna: "),
        horas = html_text2(html_elements(html, "div:nth-child(2) > div > div:nth-child(2) > h6:nth-child(1)"))|> str_remove_all("Horas: "),
        fecha = html_text2(html_elements(html, "div:nth-child(2) > div > div:nth-child(2) > h6:nth-child(2)"))|> str_remove_all("Fecha Inicio: "),
        puntuacion = html_text2(html_elements(html, "#evalDesk > div:nth-child(1) > div > a > label:nth-child(1)")) |> str_trim(),
        evaluaciones = html_text2(html_elements(html, "div:nth-child(1) > div > a > div:nth-child(4) > label")) |>
          str_remove_all("\\(| Evaluaciones de los capacitados\\)"),
        link = html_elements(html, ".col-md-12.col-xs-12.col-sm-12.cursoTituloEmpresa a") |> html_attr("href")
      ))
  Sys.sleep(1)
}

# Cerramos cliente y paramos el servidor
cliente$close()
servidor$server$stop()

# Normalizamos la base
cursos_sence
cursos_sence$ejecutor <- toupper(cursos_sence$ejecutor)
cursos_sence$ejecutor <- as.factor(cursos_sence$ejecutor)
cursos_sence$modalidad <- as.factor(cursos_sence$modalidad)
cursos_sence$region <- as.factor(cursos_sence$region)
cursos_sence$comuna <- as.factor(cursos_sence$comuna)
cursos_sence$horas <- as.integer(cursos_sence$horas)
cursos_sence$fecha <- as.Date(cursos_sence$fecha)
cursos_sence$puntuacion <- gsub(",", ".", cursos_sence$puntuacion)
cursos_sence$puntuacion <- as.numeric(cursos_sence$puntuacion)
cursos_sence$evaluaciones <- as.integer(cursos_sence$evaluaciones)
cursos_sence

# Limpiamos
rm(list=ls())
cat("\014")


# EJEMPLO 2 ---------------------------------------------------------------

# Creamos el objeto url
url <- "https://agendaeventos.sercotec.cl/Centro/Detalle"

# Creamos el vector de fechas para el año 2020
fechas <- seq(as.Date("2020-01-01"), by="day", len=90)

# Creamos un  vector con los días de la semana
diadelasemana <- lubridate::wday(fechas)

# Nos quedamos solo con los días lunes
lunes <- data.frame(fechas = fechas, diadelasemana = diadelasemana) |>
  filter( diadelasemana == 2) |>
  tidyr::separate(fechas, c("anio", "mes", "dia"), "-") |>
  select(3,2,1)

# Activamos el servidor selenium y un navegador
servidor <- rsDriver(browser = "chrome", port = 8866L, chromever = "108.0.5359.22")

# Creamos al usuario
cliente <- servidor$client

# Maximizamos la ventana
cliente$maxWindowSize()

# Navegamos
cliente$navigate(url)

# Creamos un marco de datos vacío
agendaeventos <- tibble()

# Armamos el ciclo for para raspar todas las páginas
for (i in seq_along(lunes$anio[1:2])) {
  date <- cliente$findElement(using = "css", value = '#txtFecha')
  Sys.sleep(1)
  date$sendKeysToElement(list(lunes[i,1]))
  date$sendKeysToElement(list(lunes[i,2]))
  date$sendKeysToElement(list(lunes[i,3]))
  Sys.sleep(1)
  cliente$findElement(using = "css selector",
                      value = "body > div > div.container.mt-4 > div > div:nth-child(5) > button:nth-child(1)"
  )$clickElement()
  Sys.sleep(1)
  html <- cliente$getPageSource()[[1]] |> read_html()
  Sys.sleep(1)
  cat("Vuelta", i, "| pagina 1\n")
  agendaeventos <- rbind(agendaeventos,
    tibble(
    fecha = html |> html_elements(".card-body > .d-inline:nth-child(2)") |> html_text2(),
    titulo = html |> html_elements(".card-body > .title-event") |> html_text2(),
    descripcion = html |> html_elements(".card-body > .p-event") |> html_text2(),
    region = html |> html_elements(".card-body > .d-inline:nth-child(3)") |> html_text2(),
    hora = html |> html_elements(".card-body > .d-inline:nth-child(4)") |> html_text2(),
    lugar = html |> html_elements(".card-body > .d-inline:nth-child(5)") |> html_text2()
  ))
  Sys.sleep(1)
  cliente$findElement("css", "body")$sendKeysToElement(list(key = "end"))
  Sys.sleep(1)
  n_pags <- cliente$findElement("css selector",
                                "#contenedor4 > div.row.m-2.d-flex.justify-content-center > nav > ul > li:nth-child(3) > label:nth-child(3)"
                                )$getElementText()[[1]] |> as.integer() - 1
  Sys.sleep(1)

  for (p in seq_len(n_pags)) {
    cat("Vuelta", i, "| pagina", p+1, "\n")
    cliente$findElement("css selector",
                        "#contenedor4 > div.row.m-2.d-flex.justify-content-center > nav > ul > li:nth-child(4) > a"
                        )$clickElement()
    Sys.sleep(1)
    cliente$findElement("css", "body")$sendKeysToElement(list(key = "end"))
    Sys.sleep(1)
    html <- cliente$getPageSource()[[1]] |> read_html()
    agendaeventos <-  rbind(agendaeventos, data.frame(
      fecha = html |> html_elements(".card-body > .d-inline:nth-child(2)") |> html_text2(),
      titulo = html |> html_elements(".card-body > .title-event") |> html_text2(),
      descripcion = html |> html_elements(".card-body > .p-event") |> html_text2(),
      region = html |> html_elements(".card-body > .d-inline:nth-child(3)") |> html_text2(),
      hora = html |> html_elements(".card-body > .d-inline:nth-child(4)") |> html_text2(),
      lugar = html |> html_elements(".card-body > .d-inline:nth-child(5)") |> html_text2()
    ))
    Sys.sleep(1)
  }
  cat("------------------------\n")
}

# Cerramos cliente y paramos el servidor
cliente$close()
servidor$server$stop()

# Normalizamos la base
agendaeventos
agendaeventos$titulo <- toupper(agendaeventos$titulo)
agendaeventos$fecha <- as.Date(agendaeventos$fecha, format = "%d-%m-%Y")
agendaeventos$region <- as.factor(agendaeventos$region)
agendaeventos$lugar <- as.factor(agendaeventos$lugar)
agendaeventos

# Limpiamos
rm(list=ls())
cat("\014")
