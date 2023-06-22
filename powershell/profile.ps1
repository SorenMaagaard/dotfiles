Set-PSReadlineOption -BellStyle None

# Modules should be installed on User scope
# if Modules are not installed on User scope please run as admin:
# Uninstall-Module -Name Module
function Get-EnsureModule {
  param(
    [parameter(Mandatory, ValueFromPipeline)]
    [string[]] $modulesNames
  )
  Process {
    foreach ($moduleName in $modulesNames) {
      if (!(Get-Module -Name $moduleName)) {
        try {
          Import-Module $moduleName -ErrorAction Stop
        } catch {
          Install-Module $moduleName -Scope CurrentUser -Force -AllowClobber
          Import-Module $moduleName
        }
      }
    }
  }
}

function Install-Modules {
  param(
    [parameter(Mandatory, ValueFromPipeline)]
    [string[]] $modulesNames
  )
  Begin {
    Write-Host "Installing Modules..."
  }
  Process {
    $installedModules = Get-InstalledModule
    $checkRepo = $true
    if ($checkRepo) {
      Update-Repo
      $checkRepo = $false
    }
    foreach ($moduleName in $modulesNames) {
      if (!(Get-Module -Name $moduleName)) {
        if ($installedModules.Name -notcontains $moduleName) {
          Write-Host "Installing $moduleName"
          Install-Module $moduleName -Scope CurrentUser -Force -AllowClobber
        }
      }
    }
  }
  End {
    Write-Host "Modules Installed"
  }
}

function Update-Modules {
  Update-Repo
  $installedModules = Get-InstalledModule
  foreach ($module in $installedModules) {
    Try {
      Write-Host "Checking $($module.name)"
      $online = Find-Module $module.name
    } Catch {
      Write-Warning "Module $($module.name) was not found in the PSGallery"
    }
    if ($online.version -gt $module.version) {
      Write-Host "Updating $($module.name) module"
      Update-Module -Name $module.name
    }
  }
}

function Update-Repo {
  # Ensure package mangers are installed
  $packageProviders = PackageManagement\Get-PackageProvider -ListAvailable
  $checkPowerShellGet = $packageProviders | Where-Object name -eq "PowerShellGet"
  $checkNuget = $packageProviders | Where-Object name -eq "NuGet"
  $checkPSGallery = Get-PSRepository PSGallery
  if (!$checkPSGallery -or $checkPSGallery.InstallationPolicy -ne 'Trusted') {
    Set-PSRepository PSGallery -InstallationPolicy trusted -SourceLocation "https://www.powershellgallery.com/api/v2"
  }
  if (!$checkPowerShellGet) {
    PackageManagement\Get-PackageProvider -Name PowerShellGet -Force
  }
  if (!$checkNuget) {
    PackageManagement\Get-PackageProvider -Name NuGet -Force
  }
}


$modules = (
  "Get-ChildItemColor",
  "DockerCompletion",
  "posh-git",
  "PSReadLine",
  "cd-extras"
)

$_PSVersion = $PSVersionTable.PSVersion.Major
$_File = "$PSScriptRoot/installed/$_PSVersion.test"
if (!(Test-Path $_File)) {
  Update-Repo
  $modules | Install-Modules
  New-Item -Path $_File -ItemType File -Force | Out-Null
}

$modules | Get-EnsureModule

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# setup oh-my-posh
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression

$developmentWorkspace = @("C:\git\personal", "C:\git\work")
# setup cd extras
$cde.CD_PATH = @($developmentWorkspace)

# clear variables
Remove-Variable _PSVersion, _File, modules
