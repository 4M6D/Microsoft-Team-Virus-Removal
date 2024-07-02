@echo off
title Weird Microsoft Dll Swap Virus (Assuming) - Made by UncleRon
color 0f

Rem Checking to see if the user is admin priv
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo You need to run this as admin for it to work...
    timeout /t 5 /nobreak >nul
    exit /b
)

Rem Closing files that are used for virus

Rem RegAsm is being used to shellcode inject and is not normally a virus
taskkill /im RegAsm.exe /f

Rem This is where the virus is started most likely the persistance part
taskkill /im Microsoft.exe /f

Rem deleting tasks made by the virus
schtasks /delete /tn BfeOnServiceStartTypeChange /f
schtasks /delete /tn MsCftMonitor /f
schtasks /delete /tn DobeDiscovery /f
schtasks /delete /tn "Microsoft Certificate Services" /f

Rem this virus excludes the c drive so here is it removing it
powershell -Command "Remove-MpPreference -ExclusionPath 'C:\'"

Rem this virus also sets your uac to no notifications so im resetting that
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 5 /f
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorUser /t REG_DWORD /d 3 /f
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 1 /f

Rem this virus sets its attributes to hidden so this removes that part
for /r "C:\ProgramData\MicrosoftTool" %%f in (*) do (
    attrib -h -r -s "%%f"
    echo Changed attributes for file: "%%f"
)

Rem this is where the actual payload is stored
IF EXIST "C:\Users\%username%\AppData\Roaming\Microsoft\SystemCertificates\My\CRLs\" (
    echo Deleted virus directory - CRLs
    rmdir /S /Q "C:\Users\UncleRon\AppData\Roaming\Microsoft\SystemCertificates\My\CRLs\"
)

Rem this is where the actual payload is stored
IF EXIST "C:\Users\%username%\AppData\Roaming\Microsoft\SystemCertificates\My\CTLs\" (
    echo Deleted virus directory - CTLs
    rmdir /S /Q "C:\Users\UncleRon\AppData\Roaming\Microsoft\SystemCertificates\My\CTLs\"
)

Rem Giving you an option if you want to see more and try to figure more stuff out.
echo. %blank%

echo The main infection file is called Microsoft.exe, It was hidden attributes but I made it visible again.
echo Would you just like to delete it or explore the path?
echo [1] Delete virus
echo [2] Explore further
set /p answer=
if %answer% == 1 rmdir /S /Q "C:\ProgramData\MicrosoftTool\"
if %answer% == 2 start C:\ProgramData\MicrosoftTool\
pause