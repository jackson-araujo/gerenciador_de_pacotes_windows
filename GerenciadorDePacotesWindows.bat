@echo off

REM Barra de título
title Gerenciador de Pacote do Windows - jks_84@hotmail.com

REM  Dimensão do terminal
MODE CON: COLS=85 Lines=30

REM Coloração de background e fonte do terminal.
color 0E

REM Menu de opções.
:MENU
cls
echo.
echo ======================= Gerenciador de Pacotes do Windows ========================
echo.
echo 0 - Sair; 1 - Pesquisar; 2 - Instalacao; 3 - Remocao; 4 - Listar; 5 - Atualizacao. 
echo.
set /p OPCAO=Digite a opcao correspondente.:
echo.

if not defined OPCAO (
	echo Opcao NAO informada! Tente Novamente!
	echo.
	timeout /t 2
	goto:MENU
) else (
	if "%OPCAO%" EQU "0" (goto:SAIR)
	if "%OPCAO%" EQU "1" (goto:PESQUISAR)
	if "%OPCAO%" EQU "2" (goto:INSTALAR)
	if "%OPCAO%" EQU "3" (goto:REMOVER)
	if "%OPCAO%" EQU "4" (goto:LISTAR)
	if "%OPCAO%" EQU "5" (goto:ATUALIZAR)
	if "%OPCAO%" GTR "5" (goto:MENU)
)

REM Submenu de opções.
:MINI_MENU
echo.
set /p OPCAO_1=Digite: 0 para SAIR; 1 Para retornar ao MENU INICIAL ou 2 para %OPCAO_3%.:
echo.

REM Verifica se a opção foi fornecida e executa o menu. Caso contrário, retorna ao Submenu de opções.
if not defined OPCAO_1 (
	echo Opcao NAO informada! Tente Novamente!
	echo.
	timeout /t 2
	goto:MINI_MENU
) else (
	if "%OPCAO_1%" EQU "0" (goto:SAIR)
	if "%OPCAO_1%" EQU "1" (goto:MENU)
	if "%OPCAO_1%" EQU "2" (goto:%OPCAO_3%)
	if "%OPCAO_1%" GTR "2" (goto:MINI_MENU)
)

REM Pesquisa o programa através do nome genérico para obter o ID. 

:PESQUISAR
echo PESQUISAR para obter o ID do Pacote...
echo.
set /p NOME_PACOTE=Digite o nome do programa e tecle ENTER.:
echo.

REM Verifica se o ID foi fornecido e executa a pesquisa. Caso contrário, retorna ao Submenu de opções.

if not defined NOME_PACOTE (
	echo Nome ou ID NAO informado! Tente Novamente!
	echo.
	goto:PESQUISAR
) else (
	winget search "%NOME_PACOTE%" | findstr /I winget | more
	set OPCAO_3=PESQUISAR
	goto:MINI_MENU
)

REM Realiza a instalação do programa conforme ID informado.

:INSTALAR
echo INSTALAR programa...
echo.
set /p ID_APLICATIVO=Insira o ID do pacote para INSTALAR o programa e tecle ENTER.:
echo.

REM Verifica se o ID foi fornecido e executa a instalação. Caso contrário, retorna ao Submenu de opções.

if not defined ID_APLICATIVO (
	echo ID NAO informado! Tente Novamente!
	echo.
	goto:INSTALAR
) else (
	winget install %ID_APLICATIVO% --silent --disable-interactivity --accept-package-agreements --accept-source-agreements
	set OPCAO_3=INSTALAR
	goto:MINI_MENU
)

REM Realiza a desinstalação do programa conforme ID informado.

:REMOVER
echo REMOVER programa...
echo.
set /p ID_APLICATIVO2=Insira o ID do pacote para REMOVER o programa e tecle ENTER.:
echo. 

REM Verifica se o ID foi fornecido e executa a desinstalação. Caso contrário, retorna ao Submenu de opções.

if not defined ID_APLICATIVO2 (
	echo ID NAO informado! Tente Novamente!
	echo.
	goto:REMOVER
) else (
	winget uninstall %ID_APLICATIVO2% -h --silent --disable-interactivity --accept-source-agreements --force
	set OPCAO_3=REMOVER
	goto:MINI_MENU
)

REM Realiza a listagem do programa conforme ID informado.

:LISTAR
echo LISTAR Programa...
echo.
set /p ID_APLICATIVO3=Insira o ID do pacote para LISTAR o programa e tecle ENTER.:
echo.

REM Verifica se o ID foi fornecido e executa a listagem. Caso contrário, retorna ao Submenu de opções.
if not defined ID_APLICATIVO3 (
	echo ID NAO informado! Tente Novamente!
	echo.
	goto:LISTAR
) else (
	winget list %ID_APLICATIVO3% | findstr /I "winget" >nul
)

echo.

REM Caso o resultado do comando a cima seja diferente de zero, o programa não está instalado.
REM Caso contrário, o programa está instalado.
IF not %ERRORLEVEL% EQU 0 (
    echo "Programa (%ID_APLICATIVO3%) NAO instalado!"
) ELSE (
    echo "Programa (%ID_APLICATIVO3%) INSTALADO: "
	echo.
	winget list %ID_APLICATIVO3% | findstr /I "winget" | more
)

set OPCAO_3=LISTAR
goto:MINI_MENU

REM Realiza a atualização do programa, conforme ID fornecido. Caso não insira o ID, será exibido todos os programas que necessitam de atualização.
:ATUALIZAR
echo ATUALIZAR Programa...
echo.
set /p ID_APLICATIVO4=Insira o ID do pacote para ATUALIZAR o programa e tecle ENTER.:
echo.

winget upgrade %ID_APLICATIVO4% --silent --disable-interactivity --accept-package-agreements --accept-source-agreements | more
set OPCAO_3=ATUALIZAR
goto:MINI_MENU


:SAIR
exit
