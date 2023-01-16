
# Automatización de las tareas de raspado web: PC, Raspberry Pi, VPS ------

# En la PC con Windows
require(taskscheduleR)

miscriptftp <- system.file("extdata", "informe_web_scraping.R", package = "taskscheduleR")

taskscheduler_create(taskname = "cron_windows_informe", rscript = miscriptftp, schedule = "HOURLY", starttime = "20:00", modifier = 2)

# En la Raspberry Pi
require(cronR)

cmd <- cron_rscript("/home/agustin8/RepositoriosGit/web-scraping-con-r/sesiones/sesion07/tarea_raspberry.R")

cron_add(command = cmd, frequency = 'daily', at = "11:08" , id = 'cron_raspberry', description = "cron raspberry")

# En un VPS
require(cronR)

cmd <- cron_rscript("/root/scripts_r/scripts/tarea_vps.R")

cron_add(command = cmd, frequency = 'daily', at = "23:32" , id = 'cron_vps', description = "cron vps")
