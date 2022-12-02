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

function Invoke-Wsl() {
  Invoke-Exe wsl -u root $args
}

# build libetebase
$libetebaseDir = "$env:RUNNER_TEMP\libetebase"
$installDir = "$env:GITHUB_WORKSPACE\packages\etebase\tool\integration\libetebase\lib\"
Invoke-Exe git clone https://github.com/etesync/libetebase.git -b v0.5.3 $libetebaseDir
cd $libetebaseDir
Invoke-Exe make
New-Item -ItemType Directory -Path $installDir
Copy-Item .\target\release\etebase.dll -Destination $installDir

# setup wsl
Invoke-Exe wsl --install
Invoke-Wsl apt-get -y update
Invoke-Wsl apt-get -y upgrade

# build etebase server
$etebaseServerDir = "/tmp/etebase-server"
Invoke-Wsl apt-get -y install python3
Invoke-Wsl git clone https://github.com/etesync/server.git $etebaseServerDir
Invoke-Wsl --cd $etebaseServerDir pip install -r requirements.txt

Invoke-Wsl sed -e '/ETEBASE_CREATE_USER_FUNC/s/^#*/#/g' -i "$etebaseServerDir/etebase_server/settings.py"
Invoke-Wsl cp -a  "$etebaseServerDir/etebase-server.ini.example" "$etebaseServerDir/etebase-server.ini"
Invoke-Wsl --cd $etebaseServerDir python3 ./manage.py migrate
Invoke-Wsl --cd $etebaseServerDir python3 ./manage.py createsuperuser
