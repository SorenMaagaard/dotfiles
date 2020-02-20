function Ensure-ChocoPackages
{
  param (
    [string[]]$packages
  )

    $chocoVersion = powershell choco -v
  if(-not($chocoVersion)){
      Write-Output "Seems Chocolatey is not installed, installing now"
      Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  }
  else{
      Write-Output "Chocolatey Version $chocoVersion is already installed"
  }

  $installedPackages = &choco list --local-only --id-only -r
  $missing = $packages | ? {$_ -notin $installedPackages}

  if($missing){
    choco install $missing -y
  }
}
