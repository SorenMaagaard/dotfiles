#Requires -RunAsAdministrator
$cripts =  Get-ChildItem -Path "$PSScriptRoot\functions\*.ps1"
Foreach($import in $cripts)
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function *
