@echo off
setlocal enableextensions

set parent=%~dp0
set VENV_PATH=%parent%\.venv

set APP=%1
set ARGS=%~2


echo.
echo Running an app: %APP%
echo ===
echo ARGS -- %ARGS%
echo VENV_PATH -- %VENV_PATH%
echo.

cd %VENV_PATH%\Scripts && call activate.bat
cd %parent%

pip --version
echo.

python %APP% %ARGS%
