$ErrorActionPreference = "Stop"

if ($env:CACHE_HIT -eq "true") {
    exit
}

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

# build libetebase
$pwd = Get-Location
$tag = $args[0] #?? "master"
$libetebaseDir = "$env:RUNNER_TEMP\libetebase"
$installDir = "$pwd\tool\integration\libetebase\lib\"
Invoke-Exe git clone https://github.com/etesync/libetebase.git -b $tag $libetebaseDir
cd $libetebaseDir
Invoke-Exe make
New-Item -ItemType Directory -Path $installDir
Copy-Item .\target\release\etebase.dll -Destination $installDir
