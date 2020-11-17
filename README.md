<!--
*** Thanks for checking out this README Template. If you have a suggestion that would
*** make this better, please fork the repo and create a pull request or simply open
*** an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
-->





<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://www.overtel.com">
    <img src="images/logo.png" alt="Logo Overtel" width="30%" height="30%">
  </a>
  <!--
  <a href="https://pandorafms.com/">
    <img src="images/pandorafms_logo.png" alt="Logo PandoraFMS" width="30%" height="30%">
  </a>
  

  <h3 align="center">Recogida de datos del estado físico de servidores mediante protocolo IPMI</h3>

  <p align="center">
    Scripts que nos permite extraer datos de las consultas IPMI a servidores físicos para luego almacenarlos en PandoraFMS
    <br />
    <a href="https://github.com/franciscotudel-overtel/pandorafms_ipmi_queries/issues">Reportar un Bug</a>
    ·
    <a href="https://github.com/franciscotudel-overtel/pandorafms_ipmi_queries/issues">Requerir una nueva caracteristica</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
## Tabla de contenido

* [Acerca de nosotros](#Acerca-de-nosotros)
* [Comenzando](#Comenzando)
  * [Prerequisitos](#Prerequisitos)
  * [Instalacion](#Instalacion)
* [Ejemplos de Uso](#Ejemplos-de-uso)
  * [Listado de Tareas](#listado-de-tareas)
  * [Listado de Parametros para una tarea especifica](#listado-de-parametros)
  * [Lisado de Datastores](#uso_3)
  * [Parametros de Datastores especifica](#uso_4)
* [Contribuir](#contribuir)
* [Licencia](#licencia)
* [Contacto](#contacto)
* [Agradecimientos](#agradecimientos)



<!-- Sobre el proyecto -->
## Acerca de Nosotros
*Overtel Technology Systems* está edicada al desarrollo y la implementación de Nuevas Tecnologías de la Información y Comunicaciones (TIC), aparece en el panorama nacional en mayo de 1996, abriendo su primer centro de trabajo en Cartagena (Región de Murcia) donde a día de hoy ubica su central de recursos y oficinas administrativas, siendo el epicentro de su constante expansión hacia otras provincias de España, principalmente el levante Español, Murcia, Almería, Alicante, Valencia…
Operando con un equipo de calidad humana y técnica sobresaliente, damos servicio a toda la geografía nacional.

*Pandora FMS* es un software de código abierto que sirve para monitorear (monitorizar) y medir todo tipo de elementos. Monitoriza sistemas, aplicaciones o dispositivos de red. Permite conocer el estado de cada elemento de un sistema a lo largo del tiempo ya que dispone de histórico de datos y eventos. Pandora FMS está orientado a grandes entornos, y permite gestionar con y sin agentes, varios miles de sistemas, por lo que se puede emplear en grandes clusters, centros de datos y redes de todo tipo.

*IPMI*
Segú [Wikipedia](https://en.wikipedia.org/wiki/Intelligent_Platform_Management_Interface):

The Intelligent Platform Management Interface (IPMI) is a set of computer interface specifications for an autonomous computer subsystem that provides management and monitoring capabilities independently of the host system's CPU, firmware (BIOS or UEFI) and operating system. IPMI defines a set of interfaces used by system administrators for out-of-band management of computer systems and monitoring of their operation.

Este repositorio pretende facilitar la tarea de recoger datos de las tareas de Veeam Backup asi como de los repositorios para luego poder usarlos en Pandora FMS y con ellos obtener graficos de uso así como poder enviar alarmas en caso de que fallen.

Todas las llamadas a la API están documentadas perfectamente por parte del fabricante [aqui](https://helpcenter.veeam.com/docs/backup/powershell/getting_started.html?ver=100)


<!-- COMENZANDO -->


### Prerequisitos

El agente de PandoraFMS debe estar instalado y ser funcional.

La herramienta con la que vamos a extraer la información se llama *isc_ipmitool* y se puede descargar desde [aqui](https://support.advantech.co.jp/support/KnowledgeBaseSRDetail_New.aspx?SR_ID=1-1LDVAOC).
Es la encargada de hablar con el interface IPMI de los servidores para obtener los datos.

Por ejemplo: 
- En la ILO de un servidor HP se configura [asi](https://techexpert.tips/es/hp-ilo-es/ipmi-en-la-interfaz-de-ilo/).
- En la IDRAC de un servidor DELL se configura [asi](https://techexpert.tips/es/dell-idrac-es/ipmi-en-la-interfaz-idrac/).
- En Lenovo, el fabricante mantiene un set de scripts en los que se detalla también como recoger datos de sus servidores, el repositorio está en [Github](https://github.com/lenovo/powershell-redfish-lenovo)

También nos hacen falta una serie de herramientas que provienen del mundo linux. AWK, GREP, HEAD ...

Hay varias implementaciones de estas, yo personalmente uso alguna de [estas](https://tinyapps.org/blog/201606040700_tiny_unix_tools_windows.html)

### Instalacion

1. Clonar el repositorio en la carpeta de scripts de pandorafms. Desde una linea de comandos (Tecla Win + R) ... cmd + Enter
```sh
cd c:\
cd pandorafms
mkdir scripts
cd scripts
git clone https://github.com/franciscotudel-overtel/pandorafms_ipmi_queries
```
2. En la misma carpeta donde este el script, debemos tener un fichero ini donde se configuren las Ip, user, pass y tipo de cada servidor físico a monitorizar.
```sh
[Host1]
IP=192.168.3.14
USER=USERID
PASS=PASSW0RD
HOST_TYPE=IBM
[Host2]
IP=1192.168.3.14
USER=Administrator
PASS=XXXXXXXX
HOST_TYPE=HP
```
3. Seguidamente testeamos si puede leer los datos de los host y si puede comunicar con ellos.
```sh
c:\pandorafms\sripts\ipmitool.cmd Host1 TEST
Ipmitool.cmd
IP:   1.2.2.3.4
USER: abcd
PASS: dcba
TYPE: HP

Comando: 
Conexión de Test: OK
```

4. Comenzar a poner modulos al agente, para ello podemos seguir el manual del fabricate [aqui](https://pandorafms.com/docs/index.php?title=Pandora:Documentation_es:Configuracion_Agentes) o editar directamente el fichero pandora_agent.conf que estará en la carpeta de instalación del agente. 

Por ejemplo el módulo que devuelve el estado de la fuente de alimentacion 1 del Host1 (cuyos datos de conexion estan en el fichero ini) se configuraría así:
```
module_begin
module_name Servidor HP 1 - Estado Fisico Fuente Alimentacion 1
module_type generic_data_string
module_exec c:\pandorafms\sripts\ipmitool.cmd Host1 PSU1
module_description Servidor HP 1 - Estado Fisico Fuente Alimentacion 1
module_end
```


<!-- USAGE EXAMPLES -->
## Ejemplos de uso

A partir de aqui detallo todos los posibles usos del script para obtener parametros concretos de un host físico.

Simplemente para recordar, [aqui](https://pandorafms.com/docs/index.php?title=Pandora:Documentation_es:Configuracion_Agentes#module_type_.3Ctipo.3E) en la sección 1.6.1.3 se detalla los tipos de modulos que pueden ser usados en un agente.

- *Numérico* (generic_data): Datos numéricos sencillos, con coma flotante o enteros.
- *Incremental* (generic_data_inc): Dato numérico igual a la diferencia entre el valor actual y el valor anterior dividida por el número de segundos transcurridos. Cuando esta diferencia es negativa, se reinicia el valor, esto significa que cuando la diferencia vuelva a ser positiva de nuevo se tomará el valor anterior siempre que el incremento vuelva a dar un valor positivo.
- *Absolute incremental* (generic_data_inc_abs): Dato numérico igual a la diferencia entre el valor actual y el valor anterior, sin realizar la división entre el número de segundos transcurridos, para medir incremento total en lugar de incremento por segundo. Cuando esta diferencia es negativa, se reinicia el valor, esto significa que cuando la diferencia de nuevo vuelva a ser positiva, se empleará el último valor desde el que el actual incremento obtenido da positivo.
- *Alfanumérico* (generic_data_string): Recoge cadenas de texto alfanuméricas.
- *Booleanos* (generic_proc): Para valores que solo pueden ser correcto o afirmativo (1) o incorrecto o negativo (0). Útil para comprobar si un equipo está vivo, o un proceso o servicio está corriendo. Un valor negativo (0) trae preasignado el estado crítico, mientras que cualquier valor superior se considerará correcto.
- *Alfanumérico asíncrono* (async_string): Para cadenas de texto de tipo asíncrono. La monitorización asíncrona depende de eventos o cambios que pueden ocurrir o no, por lo que este tipo de módulos nunca están en estado desconocido.
- *Booleano asíncrono* (async_proc): Para valores booleanos de tipo asíncrono.
- *Numérico asíncrono* (async_data): Para valores numéricos de tipo asíncrono.

Podrían configurarse todos los módulos para recoger los datos una vez cada hora asi:
```
module_crontab 45 * * * *
module_timeout 50
```
Con esto conseguiriamos que el módulo se ejecutase cada hora (a la hora y 45 minutos) con un timeout de 50 segundos para dar tiempo a la herramienta a hacer la consulta.
Peeeero, siendo datos críticos, lo dejo a la elección de cada usuario.

### Listado de tareas
Obtener listados de las tareas para su posterior uso en los modulos.

#### Todas las tareas
Lista todas las tareas programadas en Veeam Backup de la maquina local, en formato CSV y sin importar si están o no habilitadas.

```
module_begin
module_name Veeam Backup - Jobs
module_type generic_data_string
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\zabbix\scripts_pandorafms\vb_job.ps1 ListCSV
module_description Lista de Tareas
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Solo tareas en estado enabled
Lista las tareas con estado 'enabled' programadas en Veeam Backup de la maquina local, en formato CSV y sin importar si están o no habilitadas.

```
module_begin
module_name Veeam Backup - Jobs
module_type generic_data_string
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\zabbix\scripts_pandorafms\vb_job.ps1 ListEnabledCSV
module_description Lista de Tareas
module_crontab 45 * * * *
module_timeout 50
module_end
```
### Listado de parametros



¡OJO! Recordar cambiar el UUID de la tarea por uno de los obtenidos en las listas del apartado anterior.

#### Modulo Result
Obtener el resultado de ejecución de la tarea.
Veeam define los siguientes [resultados](https://helpcenter.veeam.com/docs/backup/powershell/enums.html?ver=100#vbrsessionresult).

- None: The result is N/A.
- Success: The session finished successfully.
- Warning: The session finished with warnings.
- Failed: The session failed.

Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - Result
module_type generic_data
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 Result d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - Result de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo JobName
Obtener el nombre de la tarea según Veeam.
Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - JobName
module_type generic_data_string
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 JobName d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - JobName de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo RetainDays
Obtener el numero de dias minimo que la tarea retiene datos.
Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - RetainDays
module_type generic_data
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 RetainDays d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - RetainDays de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo TargetDir
Obtener la ruta donde se guardan los backups en esta tarea.
Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - TargetDir
module_type generic_data_string
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 TargetDir d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - TargetDir de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo TargetFile
Obtener el nombre de fichero SIN extension ni ruta usado por la tarea para guardar los backups.
Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - TargetFile
module_type generic_data_string
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 TargetFile d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - TargetFile de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo LastRunStart
Obtener la fecha y hora de último comienzo de ejecución.
Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - LastRunStart
module_type generic_data_string
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 LastRunStart d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - LastRunStart de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo LastRunStop
Obtener la fecha y hora de última finalización de ejecución.
Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - LastRunStop
module_type generic_data_string
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 LastRunStop d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - LastRunStop de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo LastRunMinutes
Obtener tiempo transcurrido en minutos desde la última finalización de ejecución.
Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - LastRunMinutes
module_type generic_data_string
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 LastRunMinutes d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - LastRunMinutes de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo NextRun
Obtener la fecha y hora de la próxima ejecución.
Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - NextRun
module_type generic_data_string
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 NextRun d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - NextRun de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo JobType
Obtener tipo de tarea, Backup, Replica, Copy file ...
Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - JobType
module_type generic_data_string
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 JobType d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - JobType de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo VmCount
Obtener numero de máquinas virtuales implicadas en esta tarea.
Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - VmCount
module_type generic_data
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 VmCount d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - VmCount de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo IsEnabled
Preguntar si la tarea está activa o no, si no lo está no se ejecutará.
Devuelve un *Booleano*

Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - IsEnabled
module_type generic_proc
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 IsEnabled d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - IsEnabled de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo IsRunning
Preguntar si la tarea está actualmente en marcha o no.
Devuelve un *Booleano*

Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - IsRunning
module_type generic_proc
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 IsRunning d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - IsRunning de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo RunManually
Preguntar si la tarea se ha ejecutado manualmente.
Devuelve un *Entero*
- 0 No
- 1 Si

Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - RunManually
module_type generic_data
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 RunManually d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - Se ha ejecutado la tarea manualmente?
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo TransferedSize
Devuelve la cantidad de bytes transferidos en la última ejecución de la tarea.
Devuelve un *Entero*

Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - TransferedSize
module_type generic_data
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 TransferedSize d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - Valor en bytes transferido por la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo TimeFromLast
Devuelve la cantidad de horas desde la última ejecución de la tarea.<br>
Devuelve un *Entero*

Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - TimeFromLast
module_type generic_data
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 TimeFromLast d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - Tiempo en horas transcurrido desde la última ejecución de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo TimeFromLastMinutes
Devuelve la cantidad de minutos desde la última ejecución de la tarea.<br>
Devuelve un *Entero*

Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - TimeFromLastMinutes
module_type generic_data
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 TimeFromLastMinutes d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - Tiempo en minutos transcurrido desde la última ejecución de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```

#### Modulo Percent
Devuelve la cantidad de minutos desde la última ejecución de la tarea.<br>
Devuelve un *Entero*

Ejemplo de uso:
```
module_begin
module_name Veeam Backup - Job Copia_Ejemplo_1 - Percent
module_type generic_data
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 Percent d9c799c4-2d33-2641-a2db-116aa917078c
module_description Veeam Backup - Job Copia_Ejemplo_1 - Tiempo en minutos transcurrido desde la última ejecución de la tarea
module_crontab 45 * * * *
module_timeout 50
module_end
```


## Uso_3
Datastores

## Uso_4
Datos especificos por Datastore

## Version

#### Modulo Version
Devuelve la version del script.<br>
Devuelve un *string*

Ejemplo de uso:
```
module_begin
module_name Veeam Backup Jobs - version script
module_type generic_data
module_exec %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -nologo -Noprofile -ExecutionPolicy Bypass -command C:\pandorafms\scripts\vb_job.ps1 Version
module_description Veeam Backup Jobs - version del script
module_crontab 45 * * * *
module_timeout 50
module_end
```

<!-- LICENCIA -->
## Licencia

Distribuido con the GNU General Public License v3.0. Ver `LICENSE` para mas informacion.



<!-- CONTACTO -->
## Contacto

- Project Link: [https://github.com/franciscotudel-overtel/pandorafms_ipmi_queries](https://github.com/franciscotudel-overtel/pandorafms_ipmi_queries)
- LinkedIn: [LinkedIn][linkedin-url]

<!-- AGRADECIMIENTOS -->
## Agradecimientos
* [Jean-Jacques Martrès](https://github.com/jjmartres)


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/franciscotudel-overtel/pandorafms_ipmi_queries.svg?style=flat-square
[contributors-url]: https://github.com/franciscotudel-overtel/pandorafms_ipmi_queries/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/francisco-tudel-escalona-44076069/pandorafms_ipmi_queries.svg?style=flat-square
[forks-url]: https://github.com/franciscotudel-overtel/pandorafms_ipmi_queries/network/members
[stars-shield]: https://img.shields.io/github/stars/francisco-tudel-escalona-44076069/pandorafms_ipmi_queries.svg?style=flat-square
[stars-url]: https://github.com/franciscotudel-overtel/pandorafms_ipmi_queries/stargazers
[issues-shield]: https://img.shields.io/github/issues/francisco-tudel-escalona-44076069/pandorafms_ipmi_queries.svg?style=flat-square
[issues-url]: https://github.com/franciscotudel-overtel/pandorafms_ipmi_queries/issues
[license-shield]: https://img.shields.io/github/license/francisco-tudel-escalona-44076069/pandorafms_ipmi_queries.svg?style=flat-square
[license-url]: https://github.com/franciscotudel-overtel/pandorafms_ipmi_queries/blob/main/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=flat-square&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/francisco-tudel-escalona-44076069

