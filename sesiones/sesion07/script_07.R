
# Automatización de las tareas de raspado web: PC, Raspberry Pi, VPS ------

# En la PC con Windows
require(taskscheduleR)

miscript <- "D:/Google_Drive_ok/R/github_control/web-scraping-con-r/sesiones/sesion07/tarea_windows.R"

taskscheduler_create(taskname = "cron_windows", rscript = miscript, schedule = "DAILY", starttime = "13:32")

# taskscheduleR::taskscheduler_ls()
# taskscheduleR::taskscheduler_delete(taskname = "cron_windows")

# En la Raspberry Pi
require(cronR)

cmd <- cron_rscript("/home/agustin8/RepositoriosGit/web-scraping-con-r/sesiones/sesion07/tarea_raspberry.R")

cron_add(command = cmd, frequency = 'daily', at = "11:08" , id = 'cron_raspberry', description = "cron raspberry")

# En un VPS
require(cronR)

cmd <- cron_rscript("/root/scripts_r/scripts/tarea_vps.R")

cron_add(command = cmd, frequency = 'daily', at = "23:32" , id = 'cron_vps', description = "cron vps")
