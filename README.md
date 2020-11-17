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
  * [Estado de fuentes de alimentacion](#Estado-de-fuentes-de-alimentacion)
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
Según la [Wikipedia](https://en.wikipedia.org/wiki/Intelligent_Platform_Management_Interface):

The Intelligent Platform Management Interface (IPMI) is a set of computer interface specifications for an autonomous computer subsystem that provides management and monitoring capabilities independently of the host system's CPU, firmware (BIOS or UEFI) and operating system. IPMI defines a set of interfaces used by system administrators for out-of-band management of computer systems and monitoring of their operation.

Este repositorio pretende facilitar la tarea de recoger datos de las tareas de Veeam Backup asi como de los repositorios para luego poder usarlos en Pandora FMS y con ellos obtener graficos de uso así como poder enviar alarmas en caso de que fallen.


<!-- COMENZANDO -->


### Prerequisitos

* El agente de PandoraFMS debe estar instalado y ser funcional.

* La herramienta con la que vamos a extraer la información se llama *isc_ipmitool* y se puede descargar desde [aqui](https://support.advantech.co.jp/support/KnowledgeBaseSRDetail_New.aspx?SR_ID=1-1LDVAOC).
Es la encargada de hablar con el interface IPMI de los servidores para obtener los datos.
Los ejemplos de uso de la herramienta que he usado como base, se pueden ver [aqui](http://fibrevillage.com/sysadmin/71-ipmitool-useful-examples)

* Para cada fabricante y casi para cada modelo de servidor, la manera de configurar la interfaz es diferente. Aquí van algunos ejemplos.

  - En la ILO de un servidor HP se configura [asi](https://techexpert.tips/es/hp-ilo-es/ipmi-en-la-interfaz-de-ilo/).
  - En la IDRAC de un servidor DELL se configura [asi](https://techexpert.tips/es/dell-idrac-es/ipmi-en-la-interfaz-idrac/).
  - En Lenovo, el fabricante mantiene un set de scripts en los que se detalla también como recoger datos de sus servidores, el repositorio está en [Github](https://github.com/lenovo/powershell-redfish-lenovo)

* También nos hacen falta una serie de herramientas que provienen del mundo linux. AWK, GREP, HEAD ...
  Hay varias implementaciones de ellas, yo personalmente uso alguna de [estas](https://tinyapps.org/blog/201606040700_tiny_unix_tools_windows.html)

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

De momento, los tipos son HP e IBM... que son con los que he podido probar :-)

3. Seguidamente testeamos si puede leer los datos de los host y si puede comunicar con ellos.
```sh
c:\pandorafms\sripts\ipmitool.cmd Host1 TEST
Ipmitool.cmd
IP:   1.2.3.4
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
module_exec c:\pandorafms\sripts\ipmitool.cmd PSU1 Host1
module_description Servidor HP 1 - Estado Fisico Fuente Alimentacion 1
module_end
```

5. Usuarios de Zabbix
Los usuarios de Zabbix también pueden usarlo de la siguiente forma, poner esta linea en el archivo zabbixagent.conf del agente añadir esta linea al final y reiniciarlo
```
UserParameter=ipmitool[*],c:\zabbix\scripts\ipmitool.cmd $1 $2 $3 $4
```
Reiniciar el agente en el equipo
En el servidor, configurar los item según corresponda.


<!-- USAGE EXAMPLES -->
## Ejemplos de uso

A partir de aqui detallo todos los posibles usos del script para obtener parametros concretos de un host físico.

Simplemente para recordar, En la Wiki de pandorafms, [aqui](https://pandorafms.com/docs/index.php?title=Pandora:Documentation_es:Configuracion_Agentes#module_type_.3Ctipo.3E) en la sección 1.6.1.3 se detalla los tipos de modulos que pueden ser usados en un agente.

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
Con esto conseguiriamos que el módulo se ejecutase cada hora (a la hora y 45 minutos) con un timeout de 50 segundos para dar tiempo a la herramienta a hacer la consulta.<BR>
Peeeero, siendo datos críticos, lo dejo a la elección de cada usuario.

## Estado de fuentes de alimentacion

### Todas
*Descripción*:
Obtener Estado de todas las fuentes de alimentación del equipo.<br>
*Dato Devuelto*:
Devuelve un *string*.<br>

Ejemplo de uso para las fuente de alimentación 1 de un servidor HP:<br>
```
module_begin
module_name Servidor HP 1 - Estado Fisico Fuentes Alimentacion
module_type generic_data_string
module_exec c:\pandorafms\sripts\ipmitool.cmd PSUS Host1
module_description Servidor HP 1 - Estado Fisico Fuentes Alimentacion
module_end
```

### Una concreta
*Descripción*:
Obtener Estado de cada una de las fuentes de alimentación del equipo.<br>
*Dato Devuelto*:
Devuelve un *string*.<br>

Ejemplo de uso para la fuente de alimentación 1 de un servidor tipo HP:<br>
```
module_begin
module_name Servidor HP 1 - Estado Fisico Fuente Alimentacion 1
module_type generic_data_string
module_exec c:\pandorafms\sripts\ipmitool.cmd PSU 1 Host1
module_description Servidor HP 1 - Estado Fisico Fuente Alimentacion 1
module_end
```
## Estado de los discos

### Fallo de alguno
*Descripción*:
Obtener Estado de fallo de alguno de los discos. Es una alarma interna del servidor que se pone a 1 cuando alguno de los discos no funciona correctamente.<br>
*Dato Devuelto*:
Devuelve un *int*.<br>
- 0 Si todo bien
- 1 Si alguno mal

*Alarma*:
Critico si alguno va mal.<br>

Ejemplo de uso para el estado de los discos de un servidor IBM:<br>
```
module_begin
module_name Servidor IBM 5 - Alarma Discos Duros
module_type generic_data
module_exec c:\pandorafms\sripts\ipmitool.cmd DRIVE_FAULT Host5
module_description Servidor IBM 5 - Alarma Discos Duros
module_min_warning 0
module_max_warning 0
module_min_critical 1
module_max_critical 0
module_end
```

## Estado de los ventiladores

### Fallo de alguno
*Descripción*:
Obtener Estado de fallo de alguno de los ventiladores. Es una alarma interna del servidor que se pone a 1 cuando alguno de los ventiladores no funciona correctamente.<br>
*Dato Devuelto*:
Devuelve un *int*.<br>
- 0 Si todo bien
- 1 Si alguno mal

*Alarma*:
Critico si alguno va mal.<br>

Ejemplo de uso para el estado de los ventiladores de un servidor HP:<br>
```
module_begin
module_name Servidor HP 1 - Alarma Fuentes Alimentacion
module_type generic_data
module_exec c:\pandorafms\sripts\ipmitool.cmd FAN_FAULT Host1
module_description Servidor HP 1 - Alarma Fuentes Alimentacion
module_min_warning 0
module_max_warning 0
module_min_critical 1
module_max_critical 0
module_end
```


## Version

#### Modulo Version
Devuelve la version del script.<br>
Devuelve un *string*

Ejemplo de uso:
```
module_begin
module_name IPMI TOOL - Version
module_type generic_data_string
module_exec c:\pandorafms\sripts\ipmitool.cmd VERSION
module_description IPMI TOOL - Version del script y fecha de publicación
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
* [Wikipedia - Que es IPMI](https://en.wikipedia.org/wiki/Intelligent_Platform_Management_Interface)
* [Ejemplos de uso de la herramienta isc_ipmi](http://fibrevillage.com/sysadmin/71-ipmitool-useful-examples)
* [Como configurar IPMI en diferentes Servidores](https://techexpert.tips/es/hp-ilo-es/ipmi-en-la-interfaz-de-ilo/).
* [Herramientas del mundo unix para Windows](https://tinyapps.org/blog/201606040700_tiny_unix_tools_windows.html)


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

