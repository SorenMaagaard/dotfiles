function Set-SymLinkFile{
  param(
    [string] $source, [string]$link
    )
    New-Item -Force -ItemType SymbolicLink -Target $source -Path $link #| Out-Null";
}

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

    SymLinkFile -source $sourceAbsolute -link $link
}

function Set-SymLinkPsProfile([string] $source){
     $sourceAbsolute = Resolve-Path $source;
     SymLinkFile $sourceAbsolute $profile
}
