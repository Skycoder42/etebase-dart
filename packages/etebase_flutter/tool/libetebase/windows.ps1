#$1 libetebase version
$ErrorActionPreference = "Stop"

# https://stackoverflow.com/a/58184408
function Invoke-Exe() {
    # A handy way to run a command, and automatically throw an error if the
    # exit code is non-zero.

    if ($args.Count -eq 0) {
        throw "Must supply some arguments."
    }

    $command = $args[0]
    $commandArgs = @()
    if ($args.Count -gt 1) {
        $commandArgs = $args[1..($args.Count - 1)]
    }

    & $command $commandArgs
    $result = $LASTEXITCODE

    if ($result -ne 0) {
        throw "$command $commandArgs exited with code $result."
    }
}

$arg1 = $args[0]
$version = "v$arg1"

$pwd = Get-Location
$buildDir = "$env:RUNNER_TEMP\libetebase"
$cacheDir = "$env:GITHUB_WORKSPACE\.cache"
$libDir = "$pwd\windows\lib"

if ($env:CACHE_HIT -eq "true") {
  New-Item -ItemType Directory -Path $libDir
  Copy-Item "$cacheDir\etebase.dll" -Destination $libDir
  exit
}

Invoke-Exe git clone https://github.com/etesync/libetebase.git -b $version $buildDir
cd $buildDir
Invoke-Exe cargo build --release
New-Item -ItemType Directory -Path $cacheDir
Move-Item .\target\release\etebase.dll -Destination $cacheDir

New-Item -ItemType Directory -Path $libDir
Copy-Item "$cacheDir\etebase.dll" -Destination $libDir
