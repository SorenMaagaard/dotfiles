function Set-DotFile{
  param(
    [string] $source, [string]$dest, [switch]$addDot
  )

    $destAbsolute = Resolve-Path $dest;
    New-Item -Path $destAbsolute -ItemType Directory -ErrorAction Ignore
    $dot = if($addDot){"."} else {""}
    $fileName = Split-Path $source -Leaf
    $link = Join-Path -Path $destAbsolute -ChildPath "$dot$fileName"
    $sourceAbsolute = Resolve-Path $source;

    if(Test-Path $link -PathType Leaf){
        Remove-Item $link -Force
    }

    New-Item -Force -ItemType SymbolicLink -Target $sourceAbsolute -Path $link #| Out-Null";
}

function Set-SymLinkProfile([string] $source){
     $sourceAbsolute = Resolve-Path $source;
     New-Item -Force -ItemType SymbolicLink -Target $sourceAbsolute -Path $profile #| Out-Null";
     Write-host "Profile = $profile"
}


function Set-SymLinkProcessProfile([string]$process, [string] $source){
  Write-host "Setting symlink profile for $process"
  &$process -WindowStyle Hidden -NonInteractive -Command ${function:Set-SymLinkProfile} -args $source
}
