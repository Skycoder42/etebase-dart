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

# Setup vcpkg
echo "::group::Setup vcpkg"
dir "C:\Program Files\"
Invoke-Exe vcpkg list
Invoke-Exe vcpkg install openssl-windows:x64-windows
Invoke-Exe vcpkg install openssl:x64-windows-static
Invoke-Exe vcpkg integrate install
echo ::endgroup::

# build libetebase
echo "::group::Build libetebase"
$pwd = Get-Location
$tag = $args[0] #?? "master"
$libetebaseDir = "$env:RUNNER_TEMP\libetebase"
$installDir = "$pwd\tool\integration\libetebase\lib\"
Invoke-Exe git clone https://github.com/etesync/libetebase.git -b $tag $libetebaseDir
cd $libetebaseDir
rm Cargo.lock # delete lockfile to get up-to-date dependencies
Invoke-Exe make
New-Item -ItemType Directory -Path $installDir
Copy-Item .\target\release\etebase.dll -Destination $installDir
echo ::endgroup::

