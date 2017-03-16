##Script to setup new Device after imaging
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install googlechrome vlc 7zip notepadplusplus malwarebytes adobereader ###make a menu?
$Netloc = read-host -prompt 'Enter the network location'
$Netcred = read-host -prompt 'Enter the domain\username for the network share'
New-PSDrive -name R -psprovider FileSystem -Root $Netloc -persist -credential $Netcred
#####file installation here?