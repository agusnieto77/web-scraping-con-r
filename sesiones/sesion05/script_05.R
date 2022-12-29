
# Web scraping en páginas dinámicas ---------------------------------------
## Cargamos las librerías
require(rvest)
require(tibble)
require(stringr)
require(RSelenium)

# Intentamos con rvest
# Creamos el objeto url con la página de cursos
url <- "https://eligetucurso.sence.cl/"

# Leemos y recuperamos el contenido del html
html <- read_html(url)

# Imprimimos en consola
html

# Raspamos el título de cada curso
html |> html_elements("h4.cursoTitulo") |> html_text2()
html |> html_elements("h4") |> html_text2()

# Intentamos con RSelenium
# Activamos el servidor selenium y un navegador
servidor <- rsDriver(browser = "chrome", port = 1937L, chromever = "108.0.5359.22")

# Creamos al usuario
cliente <- servidor$client

# Navegamos
cliente$navigate("https://eligetucurso.sence.cl/")

# Buscamos los elemento del título y los guardamos en un objeto
elementos <- cliente$findElements("class name", "cursoTitulo")

# Creamos el vector con los titulo como cadena de caracteres en un vector
unlist(lapply(elementos, function(x) x$getElementText()))

# Buscamos los elemento del título y los guardamos en un objeto
elementos <- cliente$findElements("css selector", "#cursos > div > div > div.col-md-8.col-xs-8.col-sm-8 > div.col-md-12.col-xs-12.col-sm-12.tituloCursocaja > div:nth-child(1) > div > a")

# Creamos el vector con los titulso como cadena de caracteres en un vector
unlist(lapply(elementos, function(x) x$getElementAttribute("href")))

# Cerramos cliente y paramos el servidor
cliente$close()
servidor$server$stop()

# Limpiamos
rm(list=ls())
cat("\014")

# Vamos por más información con RSelenium y rvest
# Activamos el servidor selenium y un navegador
selenium <- rsDriver(browser = "chrome", port = 7844L, chromever = "108.0.5359.22")

# Creamos al usuario
usuario <- selenium$client

# Creamos el objeto url
url <- "https://eligetucurso.sence.cl/"

# Navegamos
usuario$navigate(url)

# Vamos a la página y seleccionamos 50 cursos por página

# Leemos y recuperamos el contenido del html
html <- usuario$getPageSource()[[1]] |> read_html()

# Cerramos cliente y paramos el servidor
usuario$close()
selenium$server$stop()

# Raspamos la información de cada curso
cursos_sence <-  tibble::tibble(
  titulo = html |> html_elements("h4.cursoTitulo.movitit") |> html_text2(),
  ejecutor = html |> html_elements("#bOtec") |> html_text2(),
  codigo = html |> html_elements("div.row.divPM > div > b:nth-child(2)") |> html_text2(),
  modalidad = html |> html_elements("h5:nth-child(5) > span") |> html_text2(),
  region = html_text2(html_elements(html, "div:nth-child(2) > div > div:nth-child(1) > h6:nth-child(1)"))|> stringr::str_remove_all("Región: "),
  comuna = html_text2(html_elements(html, "div:nth-child(2) > div > div:nth-child(1) > h6:nth-child(2)"))|> stringr::str_remove_all("Comuna: "),
  horas = html_text2(html_elements(html, "div:nth-child(2) > div > div:nth-child(2) > h6:nth-child(1)"))|> stringr::str_remove_all("Horas: "),
  fecha = html_text2(html_elements(html, "div:nth-child(2) > div > div:nth-child(2) > h6:nth-child(2)"))|> stringr::str_remove_all("Fecha Inicio: "),
  puntuacion = html_text2(html_elements(html, "#evalDesk > div:nth-child(1) > div > a > label:nth-child(1)")) |> stringr::str_trim(),
  evaluaciones = html_text2(html_elements(html, "div:nth-child(1) > div > a > div:nth-child(4) > label")) |> stringr::str_remove_all("\\(| Evaluaciones de los capacitados\\)"),
  link = html_elements(html, ".col-md-12.col-xs-12.col-sm-12.cursoTituloEmpresa a") |> html_attr("href")
)

# Normalizamos la base
cursos_sence
cursos_sence$modalidad <- as.factor(cursos_sence$modalidad)
cursos_sence$region <- as.factor(cursos_sence$region)
cursos_sence$comuna <- as.factor(cursos_sence$comuna)
cursos_sence$fecha <- as.Date(cursos_sence$fecha)
cursos_sence$puntuacion <- gsub(",", ".", cursos_sence$puntuacion)
cursos_sence$puntuacion <- as.numeric(cursos_sence$puntuacion)
cursos_sence$evaluaciones <- as.integer(cursos_sence$evaluaciones)
cursos_sence

# Limpiamos
rm(list=ls())
cat("\014")

# Otro ejemplo
# Creamos el objeto url
url <- "https://agendaeventos.sercotec.cl/Centro/Detalle"

# Cambiamos la fecha en el navegador

# Con rvest
# Leemos y recuperamos el contenido del html
html <- read_html(url)

# Imprimimos en consola
html

# Raspamos las fechas de cada curso
html |> html_elements("#todos-eventos > div > div > div > div > div > div:nth-child(2)") |> html_text2()

# Ahora lo intentamos con RSelenium
# Creamos el objeto url
url <- "https://agendaeventos.sercotec.cl/Centro/Detalle"

# Activamos el servidor selenium y un navegador
servidor <- rsDriver(browser = "chrome", port = 9966L, chromever = "108.0.5359.22")

# Creamos al usuario
cliente <- servidor$client

# Navegamos
cliente$navigate(url)

# Creamos el objeto html
html <- cliente$getPageSource()[[1]] |> read_html()

# # Cambiamos la fecha en el navegador de selenium

# Recuperamos las fechas más antiguas
html |> html_elements("#todos-eventos > div > div > div > div > div > div:nth-child(2)") |> html_text2()

# Cerramos cliente y paramos el servidor
cliente$close()
servidor$server$stop()

# Un ejemplo con contenedores
# Para instalar Docker ver: https://docs.ropensci.org/RSelenium/articles/docker.html
# Abrir la aplicación Docker
# Corre la función shell con los parámetros de docker
shell('docker run -d -p 4445:4444 selenium/standalone-firefox')

# Activamos el servidor selenium y un navegador
dockerRS <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "firefox")

# Abrimos el navegador
dockerRS$open()

# Navegamos hacia la dirección url
dockerRS$navigate("https://agendaeventos.sercotec.cl")

# Pedimos el título
dockerRS$getTitle()[[1]]

# Ahora creamos el objeto url
url <- 'https://eligetucurso.sence.cl/'

# Navegamos a la dirección url de los cursos
dockerRS$navigate(url)

# Obtenemos los títulos
dockerRS$getPageSource()[[1]] |>
  read_html() |>
  html_elements("h4.cursoTitulo.movitit") |>
  html_text2()
