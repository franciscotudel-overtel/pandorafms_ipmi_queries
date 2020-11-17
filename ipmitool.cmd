@echo off
@setlocal enableextensions enabledelayedexpansion

@set VERSION=0.1

@REM BINS
@rem Descargar desde: https://support.advantech.co.jp/support/KnowledgeBaseSRDetail_New.aspx?SR_ID=1-1LDVAOC
@set IPMIBIN=c:\pandorafms\bin\ipmi\isc_ipmitool.exe
@set GREPBIN=c:\pandorafms\bin\utils\grep.exe
@set AWKBIN=c:\pandorafms\bin\utils\gawk.exe
@set HEAD=c:\pandorafms\bin\utils\head.exe
@SET INIREAD=c:\pandorafms\scripts\ini.cmd
@SET INIFILE=c:\pandorafms\scripts\ipmitool.ini

@SET DEBUG=0

if NOT exist %IPMIBIN% ( @echo %IPMIBIN%_NOT_FOUND & @GOTO end )
if NOT exist %GREPBIN% ( @echo %GREPBIN%_NOT_FOUND & @GOTO end )
if NOT exist %AWKBIN%  ( @echo %AWKBIN%_NOT_FOUND  & @GOTO end )
if NOT exist %HEAD%    ( @echo %HEAD%_NOT_FOUND    & @GOTO end )
if NOT exist %INIREAD% ( @echo %INIREAD%_NOT_FOUND & @GOTO end )
if NOT exist %INIFILE% ( @echo %INIFILE%_NOT_FOUND & @GOTO end )

:: Variables en blanco
@set IP=
@set USER=
@set PASS=
@set HOST_TYPE=
@set COMMAND=
@if "%~1"=="" goto end
@set COMMAND=%~1
@set HOST=%~2
@IF "%~1"=="GET_HOSTS" GOTO GET_HOSTS
@IF "%~1"=="VERSION" GOTO VERSION
@IF "%~1"=="TEST" GOTO TEST
@IF "%~1"=="HELP" GOTO HELP
:: Leer fichero ini
for /f "delims=" %%a in ('call %INIREAD% %INIFILE% /s %HOST% /i IP') do (
    @set IP=%%a
)

for /f "delims=" %%a in ('call %INIREAD% %INIFILE% /s %HOST% /i USER') do (
    @set USER=%%a
)

for /f "delims=" %%a in ('call %INIREAD% %INIFILE% /s %HOST% /i PASS') do (
    @set PASS=%%a
)
for /f "delims=" %%a in ('call %INIREAD% %INIFILE% /s %HOST% /i HOST_TYPE') do (
    @set HOST_TYPE=%%a
)

@call :DEBUGDATA

@rem Fuentes
@IF "%~1"=="PSU" GOTO PSU
@IF "%~1"=="PSUS" GOTO PSUS

@rem Estado en marcha o parado
@IF "%~1"=="SYS_POW" GOTO SYS_POW

@rem AYUDA
@IF "%~1"=="HELP" GOTO HELP
@IF "%~1"=="help" GOTO HELP
@IF "%~1"=="Help" GOTO HELP

@IF "%~1"=="SDR" GOTO SDR
@IF "%~1"=="SDR_TYPE_LIST" GOTO SDR_TYPE_LIST
@IF "%~1"=="SDR_ELIST" GOTO SDR_ELIST
@IF "%~1"=="SDR_ELIST_LINE" GOTO SDR_ELIST_LINE
@IF "%~1"=="SDR_ELIST_FIELD" GOTO SDR_ELIST_FIELD
@IF "%~1"=="SDR_ELIST_LINETOEND" GOTO SDR_ELIST_LINETOEND
@IF "%~1"=="SDR_ELIST_C4C5" GOTO SDR_ELIST_C4C5
@IF "%~1"=="SENSOR_LIST" GOTO SENSOR_LIST
@IF "%~1"=="PR" GOTO PR
@IF "%~1"=="SEL" GOTO SEL
@IF "%~1"=="SEL_ELIST" GOTO SEL_ELIST
@IF "%~1"=="FRU" GOTO FRU
@IF "%~1"=="FANS" GOTO FANS
@IF "%~1"=="FAN" GOTO FAN
@IF "%~1"=="MEM" GOTO MEM
@IF "%~1"=="LOM" GOTO LOM
@IF "%~1"=="LOMS" GOTO LOMS
@IF "%~1"=="PSU" GOTO PSU
@IF "%~1"=="PSUS" GOTO PSUS
@IF "%~1"=="SYS_POW" GOTO SYS_POW
@IF "%~1"=="POWER_SYS_OVERLOAD" GOTO POWER_SYS_OVERLOAD
@IF "%~1"=="POWER_CONTROL_FAULT" GOTO POWER_CONTROL_FAULT
@IF "%~1"=="MAIN_POWER_FAULT" GOTO MAIN_POWER_FAULT
@IF "%~1"=="DRIVE_FAULT" GOTO DRIVE_FAULT
@IF "%~1"=="FAN_FAULT" GOTO FAN_FAULT
@IF "%~1"=="CHASSIS_STATUS" GOTO CHASSIS_STATUS
@IF "%~1"=="LED_STATUS" GOTO LED_STATUS
@IF "%~1"=="GET_HOST" GOTO GET_HOST
@IF "%~1"=="DISCOVERY" GOTO DISCOVERY



@echo Comando %1 desconocido
@GOTO end

@GOTO end

@rem ESTADO DEL CHASIS
:CHASSIS_STATUS
@%IPMIBIN% -I lanplus -H %IP% -U %USER% -P %PASS% chassis status
@GOTO end

@rem DRIVE_FAULT
:DRIVE_FAULT
FOR /F "tokens=* USEBACKQ" %%F IN (`%IPMIBIN% -I lanplus -H %IP% -U %USER% -P %PASS% chassis status ^| %GREPBIN% Drive ^| %AWKBIN% " {print $4} "`) DO (
  SET var=%%F
)
@rem ECHO %var%
@if %var%==false (
	@echo 0
) else (
    @echo 1
)
@SET var=
@SET COMANDO=
@GOTO end


@rem FAN_FAULT
:FAN_FAULT
@rem SET COMANDO=%IPMIBIN% -I lanplus -H %IP% -U %USER% -P %PASS% chassis status ^| %GREPBIN% Fan ^| %AWKBIN% " {print $4} "
@rem %COMANDO%
FOR /F "tokens=* USEBACKQ" %%F IN (`%IPMIBIN% -I lanplus -H %IP% -U %USER% -P %PASS% chassis status ^| %GREPBIN% Fan ^| %AWKBIN% " {print $4} "`) DO (
SET var=%%F
)
@rem ECHO %var%
@if %var%==false (
	@echo 0
) else (
    @echo 1
)
@SET var=
@SET COMANDO=
@GOTO end


:GET_HOSTS
@if exist %INIFILE% @type %INIFILE%
@GOTO end

:GET_HOST
@if "%~3"=="" @echo IP=%IP%,USER=%USER%,PASS=%PASS%
::@if "%~3"=="" goto end
@if "%~3"=="IP" @echo %IP%
@if "%~3"=="ip" @echo %IP%
@if "%~3"=="Ip" @echo %IP%
@if "%~3"=="USER" @echo %USER%
@if "%~3"=="User" @echo %USER%
@if "%~3"=="user" @echo %USER%
@if "%~3"=="PASS" @echo %PASS%
@if "%~3"=="Pass" @echo %PASS%
@if "%~3"=="pass" @echo %PASS%
@GOTO end

@rem MAIN_POWER_FAULT
:MAIN_POWER_FAULT
@rem SET COMANDO=%IPMIBIN% -I lanplus -H %IP% -U %USER% -P %PASS% chassis status ^| %GREPBIN% Main ^| %AWKBIN% " {print $5} "
@rem %COMANDO%
FOR /F "tokens=* USEBACKQ" %%F IN (`%IPMIBIN% -I lanplus -H %IP% -U %USER% -P %PASS% chassis status ^| %GREPBIN% Main ^| %AWKBIN% " {print $5} "`) DO (
SET var=%%F
)
@rem ECHO %var%
@if %var%==false (
	@echo 0
) else (
    @echo 1
)
@SET var=
@rem SET COMANDO=
@GOTO end

:POWER_CONTROL_FAULT
FOR /F "tokens=* USEBACKQ" %%F IN (`@%IPMIBIN% -I lanplus -H %IP% -U %USER% -P %PASS% chassis status ^| %GREPBIN% Control  ^| %GREPBIN% Fault ^| %AWKBIN% " {print $5} "`) DO (
SET var=%%F
)
@rem ECHO %var%
@if %var%==false (
	@echo 0
) else (
    @echo 1
)
@SET var=
@GOTO end

:POWER_SYS_OVERLOAD
FOR /F "tokens=* USEBACKQ" %%F IN (`@%IPMIBIN% -I lanplus -H %IP% -U %USER% -P %PASS% chassis status ^| %GREPBIN% Overload ^| %AWKBIN% " {print $4} "`) DO (
SET var=%%F
)
@rem ECHO %var%
@if %var%==false (
	@echo 0
) else (
    @echo 1
)
@SET var=
@GOTO end


:PSUS
@if "%~2"=="" goto end
@SET PSU_NUM=10
@%IPMIBIN% -I lanplus -H %IP% -U %USER% -P %PASS% sdr entity %PSU_NUM%
@SET PSU_NUM=
@GOTO end

:PSU
@if "%~2"=="" goto end
@if "%~3"=="" goto end
@SET PSU_NUM=10.%~3
@if "%~4"=="" ( 
	@%IPMIBIN% -I lanplus -H %IP% -U %USER% -P %PASS% sdr entity %PSU_NUM% | %GREPBIN% Power | %AWKBIN% "{print $11 $12}"
	@GOTO end
	)
@if "%~4"=="TEMP" (
	@if "%~3"=="1" (
		@%IPMIBIN% -I lanplus -H %IP% -U %USER% -P %PASS% sdr entity %PSU_NUM% | %GREPBIN% 41-P | %AWKBIN% "{print $10}"
		)
	@if "%~3"=="2" (
		@%IPMIBIN% -I lanplus -H %IP% -U %USER% -P %PASS% sdr entity %PSU_NUM% | %GREPBIN% 42-P | %AWKBIN% "{print $10}"
		)
	@GOTO end
	)
@if "%~4"=="WATT" (
	@%IPMIBIN% -I lanplus -H %IP% -U %USER% -P %PASS% sdr entity %PSU_NUM% | %GREPBIN% Output | %AWKBIN% "{print $11}"
	@GOTO end
	)
@SET PSU_NUM=
@GOTO end

:SYS_POW
@%IPMIBIN% -I lanplus -H %IP% -U %USER% -P %PASS% chassis status | %GREPBIN% System | %AWKBIN% " {print $4} "
@GOTO end




:VERSION
@echo %VERSION%
@GOTO end

:TEST
@echo Version       : %VERSION%
@echo Consulta      : %COMMAND%
@echo Host en el INI: %HOST%
@echo IP            : %IP%
@echo USER          : %USER%
@echo PASS          : %PASS%
@echo HOST_TYPE     : %HOST_TYPE%
@GOTO end

:DISCOVERY
for /f "delims=" %%a in ('call %INIREAD% %INIFILE% /s Host1 /i IP') do (
    @set IP=%%a
)

for /f "delims=" %%a in ('call %INIREAD% %INIFILE% /s Host1 /i USER') do (
    @set USER=%%a
)

for /f "delims=" %%a in ('call %INIREAD% %INIFILE% /s Host1 /i PASS') do (
    @set PASS=%%a
)

@echo {"data":[{"{#IPMINAME}":"Host1","{#IPMIIP}":"%IP%","{#IPMIUSER}":"%USER%"}]}
@GOTO end


:READHOSTINFO
:: @call :READHOSTINFO
::REM READ INI FILE
for /f "delims=" %%a in ('call %INIREAD% %INIFILE% /s %2 /i IP') do (
    @set IP=%%a
)

for /f "delims=" %%a in ('call %INIREAD% %INIFILE% /s %2 /i USER') do (
    @set USER=%%a
)

for /f "delims=" %%a in ('call %INIREAD% %INIFILE% /s %2 /i PASS') do (
    @set PASS=%%a
)
@exit /b 0

:DEBUGDATA
::@echo Parametros    : %*
@if %DEBUG% EQU 1 (
	@echo Consulta      : %COMMAND%
	@echo Host en el INI: %HOST%
	@echo IP            : %IP%
	@echo USER          : %USER%
	@echo PASS          : %PASS%
	@echo HOST_TYPE     : %HOST_TYPE%
)
@exit /b 0


:get-ini-sections <filename>
for /f "usebackq eol=; tokens=*" %%a in ("%~1") do (
	set line=%%a
	rem Is this a section?
	if "!line:~0,1!"=="[" (
		rem echo Seccion = !line!
		for /f "delims=[]" %%b in ("!line!") do (
			if "!result!"=="" (
				set result=%%b
			) else (
				set result=%%b,!result!
			)
		)
	)
)
@exit /b 0

:get-ini <filename> <section> <key> <result>

	set %~4=
	setlocal
	set insection=

	for /f "usebackq eol=; tokens=*" %%a in ("%~1") do (
		set line=%%a

		rem We are inside a section, look for the right key
		if defined insection (
			rem Let's look for the right key
			for /f "tokens=1,* delims==" %%b in ("!line!") do (
				if /i "%%b"=="%3" (
					endlocal
					set %~4=%%c
					goto :eof
				)
			)
		)

		rem Is this a section?
		if "!line:~0,1!"=="[" (
			rem echo Seccion= !line!
			for /f "delims=[]" %%b in ("!line!") do (
				rem Is this the right section?
				if /i "%%b"=="%2" (
					set insection=1
				) else (
					rem We previously found the right section, so just exit when you encounter a new one
					endlocal
					if defined insection goto :eof
				)
			)
		)
	)
	endlocal
@exit /b 0

:HELP
@echo Ayuda del Script.
@echo.
@echo %~n0%~x0 HELP
@echo   Este mensaje de ayuda
@echo.
@echo %~n0%~x0 SDR_ELIST_FIELD $2 $3 $4
@echo   Consulta IPMI en el host $2, con texto $3 y campo $4 usando como separador el espacio ' '.
@echo    (Si la consulta es generica devolvera mas de una linea.)
@echo   $2: Ip del host ipmi
@echo   $3: Cadena a buscar en el fichero
@echo   $4: Columna a imprimir
@echo   Ejemplo: %~n0%~x0 SDR_ELIST_FIELD 192.168.0.56 "Power Supply 1" 7
@echo     En el caso de servidores HP con ILO 5 devuelve el estado de la fuente.
@echo.
@echo %~n0%~x0 C2 $2 $3 $4
@echo   Consulta IPMI en el host $2, con texto $3 y campo $4 y todos los campos hasta final de linea
@echo    (Si la consulta es generica devolvera mas de una linea.)
@echo   $2: Ip del host ipmi
@echo   $3: Cadena a buscar en el fichero
@echo   $4: Columna a imprimir
@echo   Ejemplo: %~n0%~x0 C2 192.168.0.56 "Power Supply 1" 5
@echo     En el caso de servidores HP con ILO 5 devuelve el estado de la fuente.
@echo.
@echo %~n0%~x0 C3 $2 $3 $4
@echo   Consulta IPMI en el host $2, con texto $3 y campo $4 y siguiente campo, seria el 5.
@echo.
@echo %~n0%~x0 ALL
@echo   Devuelve el resultado de la consulta sdr elist integro
@echo   Ejemplo: %~n0%~x0 ALL 192.168.0.56 
@echo.
@echo Uso con zabbix
@echo    Poner en fichero de configuracion:
@echo.     
@echo     UserParameter=ipmitool[*],%~n0%~x0 $1 $2 $3 $4
@echo     Siendo $1 un valor soportado C1, ALL
@GOTO end

:end
@set IP=
@set USER=
@set PASS=
exit /b
