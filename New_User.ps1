Set-ExecutionPolicy bypass -force
netsh wlan connect ssid="Prologic ITS" key="pr0l0gic"
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
choco install googlechrome 7zip notepadplusplus malwarebytes
new-psdrive -name "K" -psprovider filesystem -root "\\10.0.2.173\S" -Persist
start-process -FilePath "K:\New_User_Setup\Office\setup.exe"