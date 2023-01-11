# corremos el documento rmarkdown
rmarkdown::render("D:/Google_Drive_ok/R/github_control/web-scraping-con-r/sesiones/sesion07/informe_web_scraping.Rmd")

# datos de acceso FTP
login <- "curso@estudiosmaritimossociales.org"
dotenv::load_dot_env("D:/Google_Drive_ok/R/github_control/web-scraping-con-r/sesiones/ftp.env")

uploadsite <- "ftp://estudiosmaritimossociales.org"

# nombre del archivo pero sin la extensión (html, rds, csv o cualquier otra)
uploadfilename <- "informe_web_scraping"

yourlocalfilelocation <- "D:/Google_Drive_ok/R/github_control/web-scraping-con-r/sesiones/sesion07/informe_web_scraping.html"

RCurl::ftpUpload(yourlocalfilelocation,
                 paste(uploadsite,"/",uploadfilename,".html",sep=""),
                 userpwd=paste(login,Sys.getenv("SECRET"),sep=":"))

# source("informe_web_scraping.R")
