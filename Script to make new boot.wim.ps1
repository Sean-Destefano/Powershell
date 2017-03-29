Write-host 'Asking for all Variables up front so you can walk away'
get-disk | Out-host
$Disk = read-host -prompt 'Select the disk # of the hard drive'
$Clean = read-host -prompt "Type `'Clean' to wipe the host, otherwise leave blank"
if ($Clean -ne 'Clean') {$Partition = read-host -prompt 'Input the partition # you wish to wipe/image'}
$USB = read-host -prompt "Do you need a Bootable flash drive made? (Y/N)"
while("n","y" -notcontains $USB)
{
$USB = read-host -prompt "Do you need a Bootable flash drive made? (Y/N)"
}
if ($USB -eq "y") {
$Disknumber = read-host -Prompt 'Type in the disk number of the flash drive'
$Driveletter = read-host -Prompt 'Type in the desired USB volume letter'
$Filetocopy = read-host -Prompt 'Type in path to folder to copy, leave blank for manual'
$Fileextra = read-host -Prompt 'Type in path to any extra folder/files to copy'}
$Network = read-host -prompt 'Is the image located on a network share? (Y/N)'
if ($Network -eq 'Y') {
$Image = read-host -prompt 'Type in the Exact name (text.wim) of the image'
$NLoc = read-host -prompt 'Type the network location to connect to'
$NName = read-host -prompt 'Type the domain\username network credentials'
$NPass = read-host -prompt 'Type the password for the network account'}
else {$Image = read-host -prompt 'Type in the exact path of the image'}
write-host 'Discarding any mounted info'
dismount-windowsimage -path C:\winpe_amd64\mount -discard
write-host Mounting WinPE
Mount-WindowsImage -imagepath C:\winpe_amd64\media\sources\Boot.wim -index 1 -path C:\winpe_amd64\mount
$DiskM = read-host -Prompt: 'If you have manual commands for diskpart, please enter them here. Otherwise leave blank'
while ($diskD -ne 1) {
if (($diskn = (read-host -Prompt 'Next line, leave blank to end')) -ne '') {$diskm += "`n" + $diskn}
else {$diskd = 1}}
if ($Clean -eq 'Clean') {new-item -force -path 'C:\winpe_amd64\mount\windows\system32\diskpart.txt' -value ("$DiskM `n select disk $Disk `n clean `n create partition primary `n format fs=ntfs quick `n assign letter=c `n label='Windows' `n active `n exit") -itemtype "file"}
if ($Clean -ne 'Clean') {new-item -force -path 'C:\winpe_amd64\mount\windows\system32\diskpart.txt' -value ("$DiskM `n select disk $Disk `n select partition $Partition `n format fs=ntfs quick `n assign letter=c `n label='Windows' `n active `n exit") -itemtype "file"}
$DiskM1 = read-host -Prompt: 'If you have manual commands for CMD, please enter them here. Otherwise leave blank'
while ($diskD1 -ne 1) {
if (($diskn1 = (read-host -Prompt 'Next line, leave blank to end')) -ne '') {$diskm1 += "`n" + $diskn1}
else {$diskd1 = 1}}
if ($Network -eq 'Y'){
new-item -force -path 'C:\winpe_amd64\mount\windows\system32\image.bat' -value ("$diskm1 `n net use y:$NLoc /user:$NName $NPass `n dism /apply-image /imagefile:y:\$Image /index:1 /applydir:c:\") -itemtype file}
else {new-item -force -path 'C:\winpe_amd64\mount\windows\system32\image.bat' -value ("$diskm1 `n dism /apply-image /imagefile:$Image /index:1 /applydir:c:\") -itemtype file}
get-content 'c:\winpe_amd64\mount\windows\system32\diskpart.txt'
if ((read-host -Prompt '(y/n): Does this look correct?') -ne 'y')  {Return}
get-content 'C:\winpe_amd64\mount\windows\system32\image.bat'
if ((read-host -Prompt '(y/n): Does this look correct?') -ne 'y')  {Return}
dismount-windowsimage -path C:\winpe_amd64\mount -CheckIntegrity -save
### NEW DISK COMMANDS
if ($USB -eq 'y') {
if ($Disknumber -ne '') {get-disk $Disknumber | clear-Disk -RemoveData -Confirm}
else {return}
New-Partition -DiskNumber $Disknumber -UseMaximumSize -IsActive -DriveLetter $Driveletter | Format-Volume -FileSystem NTFS -NewFileSystemLabel USB
if ($filetocopy -ne '') {copy-item -path $Filetocopy -destination "$Driveletter`:\" -recurse -confirm -force}
if ($fileextra -ne '') {copy-item -path $Filetocopy -destination "$Driveletter`:\" -recurse -confirm -force}}