#chocolatey packages to install
$WorkPackages = "vscode","git","7zip","slack","teamviewer","pwsh","firacode-ttf"
$PersonalPackages = "spotify","nordvpn"

Import-Module ".\scripts\DotFilesSetup" -Force

#install tools
Ensure-ChocoPackages @($WorkPackages + $PersonalPackages)

#vscode
Set-DotFile ".\vscode\settings.json" "$($env:APPDATA)\Code\User"

#powershell
Set-SymLinkProcessProfile "powershell" ".\powershell\profile.ps1"
Set-SymLinkProcessProfile "pwsh" ".\powershell\profile.ps1"

#git
Set-DotFile ".\git\gitconfig" "~" -addDot
Set-DotFile ".\git\gitconfig.personal" "~" -addDot
Set-DotFile ".\git\gitconfig.work" "~" -addDot
Set-DotFile ".\git\gitignore.global" "~" -addDot

Set-DotFile ".\ssh\config" "~\.ssh"
