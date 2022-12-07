# Web Scraping con R y RStudio

## Contenido

### Sesión 1: Introducción al raspado web con R y RStudio

Presentación general del curso. Un repaso sobre el lenguaje de
programación R y de RStudio. Organización del directorio de trabajo.
Creación de proyectos. Vinculación con GitHub. ¿Qué es el web scraping?
¿Cuándo debemos hacer uso del web scraping y cuando no? API o No API,
esa es la cuestión. Algunos ejemplos de uso de APIs: Twitter y el
paquete rtweet.

### Sesión 2: Introducción a la estructura de etiquetas HTML

Una introducción a HTML, CSS y XPath: la importancia de las etiquetas
para la recuperación de la información que necesitamos. Inspección de
estructuras HTML: herramientas nativas y softwares para la inspección,
detección y selección de etiquetas HTML para el rapado web (F12,
SelectorGadget, ScrapeMate).

### Sesión 3: Web scraping en páginas estáticas

¿Cómo hacer web scraping de páginas estáticas en R? Recuperación de
información publicada en la web: páginas estáticas. Introducción al
paquete rvest. Instalación del paquete desde RStudio. Reconocimiento de
las funciones básicas de rvest: `read_html()`, `html_elements()`,
`html_text()`, `html_table()`.

### Sesión 4: Funciones para el raspado masivo de páginas estáticas

¿Cómo llevar a cabo un raspado masivo del contenido de páginas
estáticas? Combinar las funciones de rvest con las funciones de otra
librería del paquete tidyverse: purrr. Transformación de la información
semi-estructurada en datos estructurados.

### Sesión 5: Web scraping en páginas dinámicas

¿Cómo hacer web scraping del contenido de páginas dinámicas en R?
Recuperación de información publicada en la web: páginas dinámicas.
Introducción al paquete RSelenium. Instalación del paquete desde
RStudio. Reconocimiento de las funciones básicas de RSelenium:
`remoteDriver()`, `rsDriver()`, `navigate()`, `findElement()`.

### Sesión 6: Funciones para el raspado masivo de páginas dinámicas

¿Cómo llevar a cabo un raspado masivo del contenido de páginas
dinámicas? Combinar las funciones de rvest con las funciones de rvest y
purrr. Guardar la información raspada en formato tabular.

### Sesión 7: Automatización de las tareas de raspado web: PC, Raspberry Pi, VPS

Tres soportes para una misma tarea:

-   ejecución automática de scripts en R desde una PC de escritorio o
    portátil;

-   ejecución automática de scripts en R desde una Raspberry Pi;

-   ejecución automática de scripts en R desde una máquina virtual
    (VPS). Una introducción a crontab y a los paquetes cronR (Linux) y
    taskcheduleR (Windows).
