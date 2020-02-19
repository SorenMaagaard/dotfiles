#chocolatey packages to install
$WorkPackages = "vscode","git","poshgit","7zip","slack","teamviewer","pwsh"
$PersonalPackages = "spotify","nordvpn"

Import-Module ".\scripts\DotFilesSetup" -Force

Ensure-ChocoPackages @($WorkPackages + $PersonalPackages)

Set-DotFile ".\vscode\settings.json" "$($env:APPDATA)\Code\User"
Set-SymLinkPsProfile ".\powershell\profile.ps1"

