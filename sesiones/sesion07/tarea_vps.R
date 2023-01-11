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

scraping_EM("https://www.elmundo.es/espana.html") |> saveRDS("/root/el_mundo.rds")

# datos de acceso FTP
login <- "curso@estudiosmaritimossociales.org"
dotenv::load_dot_env("./sesiones/ftp.env")

uploadsite <- "ftp://estudiosmaritimossociales.org/uploads/VPS"

# nombre del archivo pero sin la extensión (rds, csv o cualquier otra)
uploadfilename <- paste0("el_mundo_",format(Sys.time(), format = "%Y_%m_%d_%H_%M_%S"))

yourlocalfilelocation <- "/root/el_mundo.rds"

RCurl::ftpUpload(yourlocalfilelocation,
          paste(uploadsite,"/",uploadfilename,".rds",sep=""),
          userpwd=paste(login,Sys.getenv("SECRET"),sep=":"))
