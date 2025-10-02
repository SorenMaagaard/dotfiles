#chocolatey packages to install
#$WorkPackages = "vscode","git","7zip","slack","teamviewer","pwsh","firacode-ttf","oh-my-posh", "nerd-fonts-hack"
#$PersonalPackages = "spotify","nordvpn"

winget install JanDeDobbeleer.OhMyPosh --source winget --scope user --force

oh-my-posh font install firacode --user
oh-my-posh font install meslo --user

$currentDrive = $PSScriptRoot | Split-Path -Qualifier


Import-Module ".\scripts\DotFilesSetup" -Force

#install tools
#Install-ChocoPackages @($WorkPackages + $PersonalPackages)

#vscode
Set-DotFile ".\vscode\settings.json" "$($env:APPDATA)\Code\User"

# #powershell
Set-SymLinkProcessProfile "powershell" ".\powershell\profile.ps1"
Set-SymLinkProcessProfile "pwsh" ".\powershell\profile.ps1"

#git
#replace drive letter with current drive in gitconfig
(Get-Content ".\git\gitconfig" -Raw) -replace "gitdir/i:[A-Z]:", "gitdir/i:$currentDrive" | Set-Content ".\git\gitconfig"

Set-DotFile ".\git\gitconfig" "~" -addDot
Set-DotFile ".\git\gitconfig.personal" "~" -addDot
Set-DotFile ".\git\gitconfig.work" "~" -addDot
Set-DotFile ".\git\gitignore.global" "~" -addDot

Set-DotFile ".\ssh\config" "~\.ssh"
Set-DotFile ".\terminal\settings.json" "$($env:LOCALAPPDATA)\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

# #wsl2
Set-Dotfile ".\wsl\wslconfig" "~" -addDot

# set nuget cache if dev drive is used
if ($currentDrive -ne "C:") {
  $newNugetDir = "$currentDrive\.nuget\packages"
  $newHttpCacheDir = "$currentDrive\.nuget\v3-cache"
  New-Item -Path $newNugetDir -ItemType Directory -Force -ErrorAction Ignore
  # Copy-Item "$env:USERPROFILE\.nuget\packages\*.*" -Recurse "$currentDrive\.nuget\packages"
  [System.Environment]::SetEnvironmentVariable('NUGET_PACKAGES',$newNugetDir,'User')
}
