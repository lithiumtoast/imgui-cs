@echo off
setlocal

call:download_C2CS_windows
call:bindgen
EXIT /B %errorlevel%

:exit_if_last_command_failed
if %errorlevel% neq 0 (
    exit %errorlevel%
)
goto:eof

:download_C2CS_windows
if not exist "%~dp0\C2CS.exe" (
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://nightly.link/lithiumtoast/c2cs/workflows/build-test-deploy/develop/win-x64.zip', '%~dp0\win-x64.zip')"
    "C:\Program Files\7-Zip\7z.exe" x "%~dp0\win-x64.zip" -o"%~dp0"
    del "%~dp0\win-x64.zip"
)
goto:eof

:bindgen
%~dp0\C2CS ast -i .\ext\cimgui\cimgui.h -o .\ast.json -s .\ext\cimgui -b 64 -d CIMGUI_DEFINE_ENUMS_AND_STRUCTS
call:exit_if_last_command_failed
%~dp0\C2CS cs -i .\ast.json -o .\src\cs\production\imgui-cs\imgui.cs -l "cimgui" -c "imgui"
call:exit_if_last_command_failed
del %~dp0\ast.json
goto:eof